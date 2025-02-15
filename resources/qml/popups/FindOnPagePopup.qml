import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQml
import QtCore
import QtWebEngine
import LingmoUI

LingmoPopup{
    id: popup
    width: 600
    height: 400
    modal: false
    closePolicy: pinned ? LingmoPopup.CloseOnEscape : LingmoPopup.CloseOnEscape|LingmoPopup.CloseOnPressOutside
    property bool pinned: false
    property LingmoWindow parentWindow
    LingmoText{
        id: heading
        text: qsTr("Find On Page")
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
                popup.close()
            }
        }
    }
}