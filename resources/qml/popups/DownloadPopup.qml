import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQml
import QtCore
import QtWebEngine
import LingmoUI
import Qt.labs.platform
import org.lingmo.webbrowser
import QtQuick.Controls.LingmoStyle as QQCL

LingmoPopup{
    id: popup_
    width: 350
    height: 400
    modal: false
    closePolicy: pinned ? LingmoPopup.CloseOnEscape : LingmoPopup.CloseOnEscape|LingmoPopup.CloseOnPressOutside
    property bool pinned: false
    property LingmoWindow parentWindow
    property WebEngineView parentView
    property ListModel download_requests
    ColumnLayout{
        id: content_layout
        anchors.fill: parent
        anchors.margins: 15
        RowLayout{
            Layout.fillWidth: true
            spacing: content_layout.width-heading.width-buttons_row_layout.width
            LingmoText{
                id: heading
                text: qsTr("Downloads")
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                font: LingmoTextStyle.Subtitle
            }
            RowLayout{
                id: buttons_row_layout
                spacing: 10
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                LingmoIconButton{
                    id: more_btn
                    iconSource: LingmoIcons.More
                    text: qsTr("More")
                    Layout.alignment: Qt.AlignRight |Qt.AlignVCenter
                    onClicked: {
                        more_menu.open();
                    }
                }
                LingmoIconButton{
                    iconSource: popup_.pinned ? LingmoIcons.PinnedFill : LingmoIcons.Pin
                    text: qsTr(popup_.pinned ? "Cancel Stay On Top" : "Stay On Top")
                    Layout.alignment: Qt.AlignRight |Qt.AlignVCenter
                    onClicked: {
                        popup_.pinned = !popup_.pinned
                    }
                }
                LingmoIconButton{
                    iconSource: LingmoIcons.Cancel
                    text: qsTr("Close")
                    visible: popup_.pinned
                    Layout.alignment: Qt.AlignRight |Qt.AlignVCenter
                    onClicked: {
                        popup_.close();
                    }
                }
            }
        }
        LingmoTextBox{
            id: text_box
            placeholderText: qsTr("Search...")
            Layout.fillWidth: true
        }
        ListView{
            id: download_requests_view
            model: popup_.download_requests
            spacing: 5
            Layout.fillWidth: true
            Layout.fillHeight: true
            ScrollBar.vertical: LingmoScrollBar{}
            clip: true
            delegate: LingmoFrame{
                id: rect_delegate
                height: 60
                anchors.left: parent.left
                anchors.right: parent.right
                property WebEngineDownloadRequest request: model.request
                property bool cancelled: false
                property bool deleted: false
                visible: rect_delegate.request.downloadFileName.includes(text_box.text)
                RowLayout{
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    Image{
                        id: file_icon
                        source: FileIconProvidingHandler.icon(rect_delegate.request.downloadFileName)
                    }
                    ColumnLayout{
                        LingmoText{
                            text: {
                                return rect_delegate.request.downloadFileName
                            }
                            elide: Qt.ElideMiddle
                        }
                        QQCL.ProgressBar{
                            id: progress_bar
                            from: 0
                            value: rect_delegate.request.receivedBytes
                            to: rect_delegate.request.totalBytes
                            visible: {return !rect_delegate.request.isFinished}
                        }
                        LingmoText{
                            text: {
                                if(rect_delegate.cancelled){
                                    return qsTr("Have Been Canceled")
                                }
                                if(rect_delegate.deleted){
                                    return qsTr("Have Been Deleted")
                                }
                                if(rect_delegate.request.isFinished){
                                    return qsTr("Have Been Finished")
                                }
                                return rect_delegate.request.receivedBytes.toString()+"B/"+rect_delegate.request.totalBytes.toString()+"B";
                            }
                        }
                    }
                }
                RowLayout{
                    id: tool_buttons
                    anchors.right: parent.right
                    LingmoIconButton{
                        id: pauseResume_openDirectory_button
                        iconSource: rect_delegate.request.isFinished ? LingmoIcons.OpenFolderHorizontal : (rect_delegate.request.isPaused ? LingmoIcons.Play : LingmoIcons.Pause)
                        visible: !rect_delegate.cancelled && !rect_delegate.deleted
                        onClicked: {
                            if(rect_delegate.request.isFinished){
                                FileManagerHandler.open(rect_delegate.request.downloadDirectory)
                            }
                            else{
                                if(rect_delegate.request.isPaused){
                                    rect_delegate.request.resume();
                                }
                                else{
                                    rect_delegate.request.pause();
                                }
                            }
                        }
                    }
                    LingmoIconButton{
                        id: cancel_delete_button
                        iconSource: rect_delegate.request.isFinished ? LingmoIcons.Delete : LingmoIcons.Cancel
                        visible: !rect_delegate.cancelled && !rect_delegate.deleted
                        onClicked: {
                            if(rect_delegate.request.isFinished){
                                FileManagerHandler.delete(rect_delegate.request.downloadDirectory+"/"+rect_delegate.request.downloadFileName)
                                rect_delegate.deleted=true;
                            }
                            else{
                                rect_delegate.request.cancel()
                                rect_delegate.cancelled=true;
                            }
                            DownloadHistoryData.append(rect_delegate.request.downloadDirectory,rect_delegate.request.downloadFileName,rect_delegate.request.mimeType,rect_delegate.request.url,cancelled,deleted)
                        }
                    }
                    Connections{
                        target: menuItem_cancel_delete
                        enabled: delegate_menu.requestIndex===index
                        function onClicked(){
                            if(rect_delegate.request.isFinished){
                                FileManagerHandler.delete(rect_delegate.request.downloadDirectory+"/"+rect_delegate.request.downloadFileName)
                                rect_delegate.deleted=true;
                            }
                            else{
                                rect_delegate.request.cancel()
                                rect_delegate.cancelled=true;
                            }
                            DownloadHistoryData.append(rect_delegate.request.downloadDirectory,rect_delegate.request.downloadFileName,rect_delegate.request.mimeType,rect_delegate.request.url,cancelled,deleted)
                        }
                    }
                    LingmoIconButton{
                        id: redownload_button
                        iconSource: LingmoIcons.Refresh
                        visible: rect_delegate.cancelled || rect_delegate.deleted
                        onClicked: {
                            parentWindow.newTab(rect_delegate.request.url)
                        }
                    }
                }
                Connections{
                    target: model.profile
                    function onDownloadFinished(request_){
                        if(rect_delegate.request===request_){
                            file_icon.source=FileIconProvidingHandler.icon(rect_delegate.request.downloadFileName);
                            DownloadHistoryData.append(rect_delegate.request.downloadDirectory,rect_delegate.request.downloadFileName,rect_delegate.request.mimeType,rect_delegate.request.url,cancelled,deleted)
                        }
                    }
                }
                Connections{
                    target: rect_delegate.request
                    function onReceivedBytesChanged(){
                        progress_bar.from=0;
                        progress_bar.value=rect_delegate.request.receivedBytes;
                        progress_bar.to=rect_delegate.request.totalBytes;
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton
                    onClicked: function(mouse){
                        if(mouse.button===Qt.RightButton){
                            delegate_menu.request=rect_delegate.request;
                            delegate_menu.requestIndex=index
                            delegate_menu.x=mouseX
                            delegate_menu.y=mouseY
                            delegate_menu.open();
                        }
                    }
                }
                onCancelledChanged: {
                    menuItem_cancel_delete.visible=!rect_delegate.cancelled && !rect_delegate.deleted
                }
            }
        }
    }
    LingmoMenu{
        id: more_menu
        width: 250
        x: 300-width
        y: more_btn.y+more_btn.height
        LingmoMenuItem{
            iconSource: LingmoIcons.NewWindow
            text: qsTr("Open Downloads Page")
            onClicked: {
                popup_.close();
                parentWindow.newTab("browser://downloads/")
            }
        }
        LingmoMenuItem{
            iconSource: LingmoIcons.Delete
            text: qsTr("Clear All Download Records")
            onClicked: {
                DownloadHistoryData.clear();
            }
        }
        LingmoMenuItem{
            iconSource: LingmoIcons.FileExplorer
            text: qsTr("Open Download Directory")
            onClicked: {
                FileManagerHandler.open(parentView.profile.downloadPath)
            }
        }
        LingmoMenuItem{
            iconSource: LingmoIcons.FileExplorer
            text: qsTr("Open Download Settings")
            onClicked: {
                
            }
        }
    }
    LingmoMenu{
        id: delegate_menu
        width: 250
        property WebEngineDownloadRequest request
        property int requestIndex
        LingmoMenuItem{
            iconSource: LingmoIcons.OpenFile
            text: qsTr("Open File")
            onClicked: {
                FileManagerHandler.open(delegate_menu.request.downloadDirectory+"/"+delegate_menu.request.downloadFileName)
            }
        }
        LingmoMenuItem{
            iconSource: LingmoIcons.Folder
            text: qsTr("Show In Explorer")
            onClicked: {
                FileManagerHandler.open(delegate_menu.request.downloadDirectory)
            }
        }
        LingmoMenuItem{
            iconSource: LingmoIcons.Link
            text: qsTr("Copy Download Link")
            onClicked: {
                ClipboardHandler.write(delegate_menu.request.url)
            }
        }
        LingmoMenuItem{
            id: menuItem_cancel_delete
            iconSource: delegate_menu.request && delegate_menu.request.isFinished ? LingmoIcons.Delete : LingmoIcons.Cancel
            text: delegate_menu.request && delegate_menu.request.isFinished ? qsTr("Delete File") : qsTr("Cancel Downloading")
        }
        LingmoMenuItem{
            iconSource: LingmoIcons.Cancel
            text: qsTr("Remove From List")
            onClicked: {
                popup_.download_requests.remove(delegate_menu.requestIndex)
            }
        }
    }
}