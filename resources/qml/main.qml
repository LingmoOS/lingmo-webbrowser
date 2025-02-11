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
    Component{
        id: com_web_window
        LingmoWebWindow{
            objectName: "web_window"
            fileDialog: file_dialog
            folderDialog: folder_dialog
            colorDialog: color_dialog
            settingsData: settings_data
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
    SettingsData{
        id: settings_data
    }
}
