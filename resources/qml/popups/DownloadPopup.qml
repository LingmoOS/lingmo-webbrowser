import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQml
import QtCore
import LingmoUI

LingmoPopup{
    id: popup
    width: 600
    height: 400
    modal: false
    closePolicy: LingmoPopup.CloseOnPressOutside
    LingmoText{
        id: heading
        text: qsTr("Downloads")
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 10
        anchors.leftMargin: 10
        font: LingmoTextStyle.Title
        
    }
}