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
    id: popup
    width: 350
    height: 400
    modal: false
    closePolicy: pinned ? LingmoPopup.CloseOnEscape : LingmoPopup.CloseOnEscape|LingmoPopup.CloseOnPressOutside
    property bool pinned: false
    property LingmoWindow parentWindow
    property ListModel download_requests
    property bool showHistory
    LingmoText{
        id: heading
        text: qsTr("Downloads")
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 20
        anchors.leftMargin: 20
        font: LingmoTextStyle.Title
    }
    RowLayout{
        spacing: 10
        anchors.right: parent.right
        LingmoIconButton{
            iconSource: LingmoIcons.NewWindow
            text: "Open Downloads Page"
            Layout.alignment: Qt.AlignVCenter
            onClicked: {
                popup.close();
                parentWindow.newTab("browser://downloads")
            }
        }
        LingmoIconButton{
            iconSource: popup.pinned ? LingmoIcons.PinnedFill : LingmoIcons.Pin
            text: popup.pinned ? "Cancel Stay On Top" : "Stay On Top"
            Layout.alignment: Qt.AlignVCenter
            onClicked: {
                popup.pinned = !popup.pinned
            }
        }
        LingmoIconButton{
            iconSource: LingmoIcons.Cancel
            text: "Close"
            visible: popup.pinned
            Layout.alignment: Qt.AlignVCenter
            onClicked: {
                popup.close();
                WebEngineDownloadRequest
            }
        }
    }
    ListView{
        id: download_requests_view
        model: popup.download_requests
        spacing: 5
        anchors.top: heading.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        ScrollBar.vertical: LingmoScrollBar{}
        clip: true
        delegate: Rectangle{
            id: rect_delegate
            height: 60
            anchors.left: parent.left
            anchors.right: parent.right
            property WebEngineDownloadRequest request: model.request
            property bool cancelled: false
            property bool deleted: false
            RowLayout{
                anchors.left: parent.left
                Image{
                    id: file_icon
                    source: FileIconProvidingHandler.icon(request.downloadFileName)
                }
                ColumnLayout{
                    LingmoText{
                        text: {
                            if(request.downloadFileName.length>25){
                                return request.downloadFileName.substr(0,25)+"..."
                            }
                            return request.downloadFileName
                        }
                    }
                    QQCL.ProgressBar{
                        id: progress_bar
                        from: 0
                        value: request.receivedBytes
                        to: request.totalBytes
                        visible: {return !request.isFinished}
                    }
                    LingmoText{
                        text: {
                            if(rect_delegate.cancelled){
                                return "Have Been Canceled"
                            }
                            if(rect_delegate.deleted){
                                return "Have Been Deleted"
                            }
                            if(request.isFinished){
                                return "Have Been Finished"
                            }
                            return request.receivedBytes.toString()+"B/"+request.totalBytes.toString()+"B";
                        }
                    }
                }
            }
            RowLayout{
                id: tool_buttons
                anchors.right: parent.right
                LingmoIconButton{
                    id: pauseResume_openDirectory_button
                    iconSource: request.isFinished ? LingmoIcons.OpenFolderHorizontal : (request.isPaused ? LingmoIcons.Play : LingmoIcons.Pause)
                    visible: !rect_delegate.cancelled && !rect_delegate.deleted
                    onClicked: {
                        if(request.isFinished){
                            FileManagerHandler.open(request.downloadDirectory)
                        }
                        else{
                            if(request.isPaused){
                                request.resume();
                            }
                            else{
                                request.pause();
                            }
                        }
                    }
                }
                LingmoIconButton{
                    id: cancel_delete_button
                    iconSource: request.isFinished ? LingmoIcons.Delete : LingmoIcons.Cancel
                    visible: !rect_delegate.cancelled && !rect_delegate.deleted
                    onClicked: {
                        if(request.isFinished){
                            FileManagerHandler.delete(request.downloadDirectory+"/"+request.downloadFileName)
                            rect_delegate.deleted=true;
                        }
                        else{
                            request.cancel()
                            rect_delegate.cancelled=true;
                        }
                    }
                }
                LingmoIconButton{
                    id: redownload_button
                    iconSource: LingmoIcons.Refresh
                    visible: rect_delegate.cancelled || rect_delegate.deleted
                    onClicked: {
                        parentWindow.newTab(request.url)
                    }
                }
            }
            Connections{
                target: model.profile
                function onDownloadFinished(request_){
                    if(request===request_){
                        file_icon.source=FileIconProvidingHandler.icon(request.downloadFileName);
                    }
                }
            }
            Connections{
                target: request
                function onReceivedBytesChanged(){
                    progress_bar.from=0;
                    progress_bar.value=request.receivedBytes;
                    progress_bar.to=request.totalBytes;
                }
            }
        }
    }
}