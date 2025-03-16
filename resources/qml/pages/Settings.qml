import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import LingmoUI
import global

Rectangle{
    id: rect
    LingmoSideBar{
        id: sidebar
        width: 300
        height: 600
        title: "Settings"
    }
    Component.onCompleted: {
        sidebar.model.append({title:"页面1",name:"page1",iconSource: "file-settings-line.svg"});
    }
}