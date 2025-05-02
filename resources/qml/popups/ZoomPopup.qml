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
    width: 250
    height: 100
    modal: false
    closePolicy: pinned ? LingmoPopup.CloseOnEscape : LingmoPopup.CloseOnEscape|LingmoPopup.CloseOnReleaseOutside
    property bool pinned: false
    property alias text: factor_text.text
    property alias zoom_in_button: zoom_in
    property alias zoom_out_button: zoom_out
    property alias reset_button: reset
    property LingmoWindow parentWindow
    LingmoText{
        id: heading
        text: qsTr("Zoom")
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 20
        anchors.leftMargin: 20
        font: LingmoTextStyle.Body
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
            visible: !popup.pinned
            onClicked: {
                popup.close()
            }
        }
    }
    RowLayout{
        anchors.top: heading.bottom
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        LingmoText{
            id: factor_text
            text: "100%"
        }
        LingmoIconButton{
            id: zoom_in
            iconSource: LingmoIcons.Add
        }
        LingmoIconButton{
            id: zoom_out
            iconSource: LingmoIcons.Remove
        }
        LingmoButton{
            id: reset
            text: qsTr("Reset")
        }
    }
}