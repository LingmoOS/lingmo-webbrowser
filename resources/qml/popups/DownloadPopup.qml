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

LingmoPopup{
    id: popup
    width: 600
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
            Layout.alignment: Qt.AlignVCenter
            onClicked: {
                popup.close();
                parentWindow.newTab("browser://downloads")
            }
        }
        LingmoIconButton{
            iconSource: popup.pinned ? LingmoIcons.PinnedFill : LingmoIcons.Pin
            Layout.alignment: Qt.AlignVCenter
            onClicked: {
                popup.pinned = !popup.pinned
            }
        }
        LingmoIconButton{
            iconSource: LingmoIcons.Cancel
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
        delegate: Rectangle{
            height: 50
            anchors.left: parent.left
            anchors.right: parent.right
            color: LingmoColor.Green.normal
            RowLayout{
                anchors.left: parent.left
                Image{
                    id: file_icon
                    source: FileIconProvidingHandler.icon(model.request.downloadFileName)
                }
                ColumnLayout{
                    LingmoText{
                        text: model.request.downloadFileName
                    }
                    LingmoText{
                        text: model.request.downloadFileName
                    }
                }
            }
            RowLayout{
                anchors.right: parent.right
                LingmoIconButton{
                    id: pause_resume_button
                }
            }
            Connections{
                target: model.request
                onDownloadCompleted: {
                    file_icon.source=FileIconProvidingHandler.icon(model.request.downloadFileName);
                }
            }
        }
    }
    
}