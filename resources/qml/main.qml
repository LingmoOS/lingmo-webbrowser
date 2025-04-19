import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtWebEngine
import LingmoUI
import Qt.labs.platform
import org.lingmo.webbrowser
import global

LingmoObject {
    id: root
    Component.onCompleted: {
        LingmoApp.init(root, Qt.locale("en_US"));
        LingmoTheme.animationEnabled = true;
        LingmoTheme.blurBehindWindowEnabled = true;
        LingmoTheme.darkMode = LingmoThemeType.System;
        newWindow();
    }
    property WebEngineView newWindowView
    property WebEngineView newDialogView
    function newWindow(request){
        var new_window=com_web_window.createObject(null,{});
        if(request){
            newWindowView.acceptAsNewWindow(request);
            newWindowView.hidePages();
        }
        new_window.show();
    }
    function newDialog(request){
        var new_dialog=com_web_dialog.createObject(null,{});
        if(request){
            newDialogView.acceptAsNewWindow(request);
            newDialogView.hidePages();
            newDialogView.resizeByRequest(request);
        }
        new_dialog.show();
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
                newWindow(newWindowRequest);
            }
            onNewDialogRequested: {
                newDialog(newWindowRequest);
            }
            Component.onCompleted: {
                newWindowView=newWindowFirstView;
            }
        }
    }
    Component{
        id: com_web_dialog
        LingmoWebDialog{
            fileDialog: file_dialog
            folderDialog: folder_dialog
            colorDialog: color_dialog
            downloadRequests: download_requests
            onNewWindowRequested: {
                newWindow(newWindowRequest);
            }
            onNewDialogRequested: {
                newDialog(newWindowRequest);
            }
            Component.onCompleted: {
                newDialogView=webView;
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
