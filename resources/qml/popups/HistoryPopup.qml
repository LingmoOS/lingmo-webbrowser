import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQml
import QtCore
import QtWebEngine
import LingmoUI

LingmoPopup{
    id: popup_
    width: 350
    height: 400
    modal: false
    closePolicy: pinned ? LingmoPopup.CloseOnEscape : LingmoPopup.CloseOnEscape|LingmoPopup.CloseOnPressOutside
    property bool pinned: false
    property LingmoWindow parentWindow
    LingmoText{
        id: heading
        text: qsTr("History")
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 20
        anchors.leftMargin: 20
        font: LingmoTextStyle.Subtitle
    }
    RowLayout{
        spacing: 10
        Layout.fillWidth: true
        LingmoIconButton{
            iconSource: LingmoIcons.More
            Layout.alignment: Qt.AlignVCenter
            onClicked: {
                menu.open();
            }
        }
        LingmoIconButton{
            iconSource: popup_.pinned ? LingmoIcons.PinnedFill : LingmoIcons.Pin
            Layout.alignment: Qt.AlignVCenter
            onClicked: {
                popup_.pinned = !popup_.pinned
            }
        }
        LingmoIconButton{
            iconSource: LingmoIcons.Cancel
            Layout.alignment: Qt.AlignVCenter
            onClicked: {
                popup_.close()
            }
        }
    }
    LingmoMenu{
        id: menu
        LingmoMenuItem{
            iconSource: LingmoIcons.NewWindow
            text: "Open History Page"
            onClicked: {
                popup_.close();
                parentWindow.newTab("browser://history/")
            }
        }
    }
}