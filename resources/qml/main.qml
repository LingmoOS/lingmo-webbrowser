import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtWebEngine
import LingmoUI
import org.lingmo.webbrowser
import global

LingmoObject {
    id: root
    Component.onCompleted: {
        LingmoApp.init(root, Qt.locale("zh_CN"));
        LingmoTheme.animationEnabled = true;
        LingmoTheme.blurBehindWindowEnabled = true;
        LingmoTheme.darkMode = LingmoThemeType.System;
        newWindow()
    }
    function newWindow(){
        var new_window=com_web_window.createObject(null,{})
        new_window.show()
    }
    ListModel{
        id: download_requests
    }
    Component{
        id: com_web_window
        LingmoWebWindow{
            fileDialog: file_dialog
            folderDialog: folder_dialog
            colorDialog: color_dialog
            downloadRequests: download_requests
            onNewWindowRequested: {
                newWindow()
            }
        }
    }
    FileDialog{
        id: file_dialog
        visible: false
    }
    FolderDialog{
        id: folder_dialog
        visible: false
    }
    ColorDialog{
        id: color_dialog
        visible: false
    }
}
