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
    closePolicy: pinned ? LingmoPopup.CloseOnEscape : LingmoPopup.CloseOnEscape|LingmoPopup.CloseOnReleaseOutside
    property bool pinned: false
    property LingmoWindow parentWindow
    LingmoText{
        id: heading
        text: qsTr("Collections")
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 20
        anchors.leftMargin: 20
        font: LingmoTextStyle.Subtitle
    }
    RowLayout{
        spacing: 10
        anchors.right: parent.right
        LingmoIconButton{
            iconSource: LingmoIcons.NewWindow
            Layout.alignment: Qt.AlignVCenter
            text: qsTr("More")
            onClicked: {
                popup_.close();
                parentWindow.newTab("browser://collections")
            }
        }
        LingmoIconButton{
            iconSource: popup_.pinned ? LingmoIcons.PinnedFill : LingmoIcons.Pin
            Layout.alignment: Qt.AlignVCenter
            text: qsTr(popup_.pinned ? "Cancel Stay On Top" : "Stay On Top")
            onClicked: {
                popup_.pinned = !popup_.pinned
            }
        }
        LingmoIconButton{
            iconSource: LingmoIcons.Cancel
            text: qsTr("Close")
            Layout.alignment: Qt.AlignVCenter
            onClicked: {
                popup_.close()
            }
        }
    }
}