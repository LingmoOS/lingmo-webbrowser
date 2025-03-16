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
        title: "Extensions"
    }
    Component.onCompleted: {
        sidebar.model.append({title:"默认分类",name:"defaultCategory",iconSource: "folder-2-line.svg"});
        sidebar.model.append({title:"未命名1",name:"untitled1",iconSource: "folder-3-line.svg"});
    }
}