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
        title: "History"
    }
    Component.onCompleted: {
        sidebar.model.append({title:"昨天",name:"yesterday",iconSource: "time-line.svg"});
    }
}