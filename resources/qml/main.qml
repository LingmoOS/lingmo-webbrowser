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
        LingmoTheme.darkMode = LingmoThemeType.Dark;
    }
    LingmoWebWindow{
        fileDialog: file_dialog
        folderDialog: folder_dialog
        colorDialog: color_dialog
        // jsonHandler: json_handler
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
    // JsonHandler{
    //     id: json_handler
    //     sourceFilePath: "../resources/data/settings.json"
    // }
}
