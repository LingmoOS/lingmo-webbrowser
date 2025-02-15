import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import LingmoUI

Rectangle{
    id: rect
    LingmoText{
        id: heading
        text: "Settings"
        font: LingmoTextStyle.Title
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 20
        anchors.leftMargin: 20
    }
}