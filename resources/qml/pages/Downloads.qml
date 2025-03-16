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
        title: "Downloads"
    }
    Component.onCompleted: {
        sidebar.model.append({title:"最近下载",name:"recentlyDownloads",iconSource: "browser.svg"});
        sidebar.model.append({title:"下载历史",name:"downloadHistory",iconSource: "browser.svg"});
    }
}