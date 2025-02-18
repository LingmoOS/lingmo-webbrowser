import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQml
import QtCore
import QtWebEngine
import LingmoUI
import org.lingmo.webbrowser
import pages
import popups

LingmoWindow{
    id: window
    visible: true
    width: 1000
    height: 600
    property int webViewId: 0
    property FileDialog fileDialog
    property FolderDialog folderDialog
    property ColorDialog colorDialog
    property ListModel downloadRequests
    signal newWindowRequested
    function getSpecialTitle(url){
        if(url=="browser://downloads"){
            return "Downloads"
        }
        else if(url=="browser://extensions"){
            return "Extensions"
        }
        else if(url=="browser://history"){
            return "History"
        }
        else if(url=="browser://settings"){
            return "Settings"
        }
        else if(url=="browser://start"){
            return "Start Page"
        }
        else{
            return "New Tab"
        }
    }
    function newTab(url= SettingsData.homeUrl){
        web_tabView.appendTab("qrc:/images/browser.svg",qsTr(getSpecialTitle(url)),com_webView,{"url": url,"id": webViewId},true);
        webViewId+=1;
    }
    function isCurrentTab(tabId){
        return tabId===web_tabView.currentItem.argument.id && window.active
    }
    Component.onCompleted: {
        newTab();
        if(SettingsData.downloadPath==="undefined"){
            SettingsData.downloadPath=StandardPaths.writableLocation(StandardPaths.DownloadLocation).toString().replace("file:///", "");
        }
    }
    Rectangle{
        id: toolArea
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 30
        color: "transparent"
        RowLayout {
            id: contorlLeftButtons
            height: parent.height
            spacing: 0
            LingmoIconButton {
                id: btn_back
                Layout.preferredWidth: 40
                Layout.preferredHeight: 30
                padding: 0
                verticalPadding: 0
                horizontalPadding: 0
                rightPadding: 2
                iconSource: LingmoIcons.Back
                Layout.alignment: Qt.AlignVCenter
                iconSize: 15
                text: qsTr('Back')
                radius: LingmoUnits.windowRadius
            }
            LingmoIconButton {
                id: btn_forward
                Layout.preferredWidth: 40
                Layout.preferredHeight: 30
                padding: 0
                verticalPadding: 0
                horizontalPadding: 0
                rightPadding: 2
                iconSource: LingmoIcons.Forward
                Layout.alignment: Qt.AlignVCenter
                iconSize: 15
                text: qsTr('Forward')
                radius: LingmoUnits.windowRadius
            }
            LingmoIconButton {
                id: btn_reload
                Layout.preferredWidth: 40
                Layout.preferredHeight: 30
                padding: 0
                verticalPadding: 0
                horizontalPadding: 0
                rightPadding: 2
                Layout.alignment: Qt.AlignVCenter
                iconSize: 15
                radius: LingmoUnits.windowRadius
            }
            LingmoIconButton {
                id: btn_home
                Layout.preferredWidth: 40
                Layout.preferredHeight: 30
                padding: 0
                verticalPadding: 0
                horizontalPadding: 0
                rightPadding: 2
                iconSource: LingmoIcons.Home
                Layout.alignment: Qt.AlignVCenter
                iconSize: 15
                text: qsTr('Home')
                radius: LingmoUnits.windowRadius
            }
        }
        LingmoTextBox{
            id: urlLine
            text: web_tabView.currentItem.url
            anchors.left: contorlLeftButtons.right 
            anchors.right: contorlRightButtons.left
            cleanEnabled: false
            height: parent.height
        }
        RowLayout {
            id: contorlRightButtons
            anchors.right: parent.right
            height: parent.height
            spacing: 0
            LingmoIconButton {
                id: btn_collections
                Layout.preferredWidth: 40
                Layout.preferredHeight: 30
                padding: 0
                verticalPadding: 0
                horizontalPadding: 0
                rightPadding: 2
                iconSource: LingmoIcons.FavoriteList
                Layout.alignment: Qt.AlignVCenter
                iconSize: 15
                text: qsTr('Collections')
                radius: LingmoUnits.windowRadius
                onClicked: {
                    collections_popup.open()
                }
            }
            LingmoIconButton {
                id: btn_history
                Layout.preferredWidth: 40
                Layout.preferredHeight: 30
                padding: 0
                verticalPadding: 0
                horizontalPadding: 0
                rightPadding: 2
                iconSource: LingmoIcons.History
                Layout.alignment: Qt.AlignVCenter
                iconSize: 15
                text: qsTr('History')
                radius: LingmoUnits.windowRadius
                onClicked: {
                    history_popup.open()
                }
            }
            LingmoIconButton {
                id: btn_download
                Layout.preferredWidth: 40
                Layout.preferredHeight: 30
                padding: 0
                verticalPadding: 0
                horizontalPadding: 0
                rightPadding: 2
                iconSource: LingmoIcons.Download
                Layout.alignment: Qt.AlignVCenter
                iconSize: 15
                text: qsTr('Download')
                radius: LingmoUnits.windowRadius
                onClicked: {
                    download_popup.open()
                }
            }
            LingmoIconButton {
                id: btn_zoom
                Layout.preferredWidth: 40
                Layout.preferredHeight: 30
                padding: 0
                verticalPadding: 0
                horizontalPadding: 0
                rightPadding: 2
                iconSource: LingmoIcons.ZoomIn
                Layout.alignment: Qt.AlignVCenter
                iconSize: 15
                text: qsTr('Zoom')
                radius: LingmoUnits.windowRadius
                onClicked: {
                    zoom_popup.open()
                }
            }
            LingmoIconButton {
                id: btn_translation
                Layout.preferredWidth: 40
                Layout.preferredHeight: 30
                padding: 0
                verticalPadding: 0
                horizontalPadding: 0
                rightPadding: 2
                iconSource: LingmoIcons.Characters
                Layout.alignment: Qt.AlignVCenter
                iconSize: 15
                text: qsTr('Translation')
                radius: LingmoUnits.windowRadius
                onClicked: {
                    translation_popup.open()
                }
            }
            LingmoIconButton {
                id: btn_extensions
                Layout.preferredWidth: 40
                Layout.preferredHeight: 30
                padding: 0
                verticalPadding: 0
                horizontalPadding: 0
                rightPadding: 2
                iconSource: LingmoIcons.Puzzle
                Layout.alignment: Qt.AlignVCenter
                iconSize: 15
                text: qsTr('Extensions')
                radius: LingmoUnits.windowRadius
                onClicked: {
                    extension_popup.open()
                }
            }
            LingmoIconButton {
                id: btn_find
                Layout.preferredWidth: 40
                Layout.preferredHeight: 30
                padding: 0
                verticalPadding: 0
                horizontalPadding: 0
                rightPadding: 2
                iconSource: LingmoIcons.SearchAndApps
                Layout.alignment: Qt.AlignVCenter
                iconSize: 15
                text: qsTr('Find on Page')
                radius: LingmoUnits.windowRadius
                onClicked: {
                    find_on_page_popup.open()
                }
            }
            LingmoIconButton {
                id: btn_settings
                Layout.preferredWidth: 40
                Layout.preferredHeight: 30
                padding: 0
                verticalPadding: 0
                horizontalPadding: 0
                rightPadding: 2
                iconSource: LingmoIcons.Settings
                Layout.alignment: Qt.AlignVCenter
                iconSize: 15
                text: qsTr('Settings')
                radius: LingmoUnits.windowRadius
                onClicked: {
                    window.newTab("browser://settings")
                }
            }
            LingmoIconButton {
                id: btn_more
                Layout.preferredWidth: 40
                Layout.preferredHeight: 30
                padding: 0
                verticalPadding: 0
                horizontalPadding: 0
                rightPadding: 2
                iconSource: LingmoIcons.More
                Layout.alignment: Qt.AlignVCenter
                iconSize: 15
                text: qsTr('More')
                radius: LingmoUnits.windowRadius
                onClicked: {
                    more_menu.open()
                }
            }
        }
    }
    LingmoTabView{
        id: web_tabView
        anchors.topMargin: 30
        onNewPressed: {
            window.newTab()
        }
    }
    Component{
        id: com_webView
        WebEngineView{
            id: webView_
            anchors.fill: parent
            url: argument.url
            property bool is_fullscreen: false
            onAuthenticationDialogRequested: {

            }
            onCanGoBackChanged: {
                btn_back.enabled = canGoBack
            }
            onCanGoForwardChanged: {
                btn_forward.enabled = canGoForward
            }
            onCertificateError:{

            }
            onColorDialogRequested: function(request){
                request.accepted=true;
                colorDialog.accepted.connect(function(){request.dialogAccept(colorDialog.selectedColor)})
                colorDialog.rejected.connect(request.dialogReject)
                colorDialog.visible = true;
            }
            onContextMenuRequested: function(request) {
                request.accepted=true;
                context_menu.x=request.position.x;
                context_menu.y=request.position.y+60;
                context_menu.open();
            }
            onDesktopMediaRequested: {
                
            }
            onFeaturePermissionRequested: {

            }
            onFileDialogRequested: function(request) {
                request.accepted = true;
                switch(request.mode){
                    case FileDialogRequest.FileModeOpen: {
                        fileDialog.fileMode=FileDialog.OpenFile
                        fileDialog.nameFilters=request.acceptedMimeTypes
                        fileDialog.accepted.connect(function(){request.dialogAccept(fileDialog.selectedFiles)});
                        fileDialog.rejected.connect(request.dialogReject);
                        fileDialog.visible = true;
                        break;
                    }
                    case FileDialogRequest.FileModeOpenMultiple: {
                        fileDialog.fileMode=FileDialog.OpenFiles
                        fileDialog.nameFilters=request.acceptedMimeTypes
                        fileDialog.accepted.connect(function(){request.dialogAccept(fileDialog.selectedFiles)});
                        fileDialog.rejected.connect(request.dialogReject);
                        fileDialog.visible = true;
                        break;
                    }
                    case FileDialogRequest.FileModeUploadFolder: {
                        folderDialog.accepted.connect(function(){request.dialogAccept(folderDialog.selectedFolder)});
                        forderDialog.rejected.connect(request.dialogReject);
                        forderDialog.visible = true;
                        break;
                    }
                    case FileDialogRequest.FileModeSave: {
                        fileDialog.fileMode=FileDialog.SaveFile
                        fileDialog.nameFilters=request.acceptedMimeTypes
                        fileDialog.accepted.connect(function(){request.dialogAccept(fileDialog.selectedFiles)});
                        fileDialog.rejected.connect(request.dialogReject);
                        fileDialog.visible = true;
                        break;
                    }
                }
            }
            onFileSystemAccessRequested: function(request){
                request.accept();
            }
            onFindTextFinished: {
                
            }
            onFullScreenRequested: function(request){
                if(!is_fullscreen){
                    if(request.toggleOn){
                        window.useSystemAppBar=true;
                        web_tabView.anchors.topMargin=-35;
                        window.showFullScreen();
                    }
                    else{
                        window.useSystemAppBar=false;
                        web_tabView.anchors.topMargin=30;
                        window.showNormal();
                    }
                }
                request.accept();
            }
            onGeometryChangeRequested: function(geometry){
                window.x = geometry.x;
                window.y = geometry.y-65;
                window.width = geometry.width;
                window.height = geometry.height+65;
            }
            onIconChanged:{
                var str=icon.toString();
                web_tabView.setCurrentTabIcon(str.replace("image://favicon/",""));
            }
            onLinkHovered: function(link){
                link_popup.visible=true;
                link_popup_text.text=link;
            }
            onJavaScriptConsoleMessage: {
                
            }
            onJavaScriptDialogRequested: {

            }
            onLoadingChanged: {
                btn_reload.iconSource=loading ? LingmoIcons.Cancel : LingmoIcons.Refresh 
                btn_reload.text=loading ? qsTr('Cancel Reload') : qsTr('Reload')
                if(loading){
                    web_tabView.setCurrentTabIcon("qrc:/images/browser.svg")
                }
            }
            // onNavigationRequested: function(request){
            //     switch(request.navigationType){
            //         case WebEngineNavigationRequest.LinkClickedNavigation: {
            //             print('Link Clicked Navigation');
            //             break;
            //         }
            //         case WebEngineNavigationRequest.TypedNavigation: {
            //             print('Typed Navigation');
            //             break;
            //         }
            //         case WebEngineNavigationRequest.FormSubmittedNavigation: {
            //             print('Form Submitted Navigation');
            //             break;
            //         }
            //         case WebEngineNavigationRequest.BackForwardNavigation: {
            //             print('Back/Forward Navigation');
            //             break;
            //         }
            //         case WebEngineNavigationRequest.ReloadNavigation: {
            //             print('Reload Navigation');
            //             break;
            //         }
            //         case WebEngineNavigationRequest.RedirectNavigation: {
            //             print('Redirect Navigation');
            //             break;
            //         }
            //         case WebEngineNavigationRequest.OtherNavigation: {
            //             print('Other Navigation');
            //             break;
            //         }
            //     }
            // }
            onNewWindowRequested: function(request) {
                window.newTab(request.requestedUrl);
            }
            onPrintRequested: {

            }
            onQuotaRequested: {

            }
            onRegisterProtocolHandlerRequested: {

            }
            onTitleChanged:{
                web_tabView.setCurrentText(title);
            }
            onTooltipRequested: function(request){
                request.accepted=true;
                toolTip.x=request.x;
                toolTip.y=request.y+30;
                toolTip.text=request.text;
                toolTip.requestType=request.type;
            }
            onUrlChanged: {
                urlLine.text = url
            }
            onWebAuthUxRequested: {
                
            }
            onWindowCloseRequested: {
                web_tabView.closeTab(web_tabView.currentIndex);
            }
            onZoomFactorChanged: {
                
            }
            settings.pluginsEnabled: true
            settings.fullScreenSupportEnabled: true
            profile.offTheRecord: false
            profile.downloadPath: {return SettingsData.downloadPath}
            settings.localStorageEnabled: true
            profile.onDownloadRequested: function(request){
                window.downloadRequests.append({"request": request,"id": request.id,"profile": profile})
                request.accept();
                download_popup.open();
            }
            Connections{
                target: btn_back
                enabled: window.isCurrentTab(argument.id) 
                function onClicked() {
                    goBack()
                }
            }
            Connections{
                target: btn_forward
                enabled: window.isCurrentTab(argument.id)
                function onClicked() {
                    goForward()
                }
            }
            Connections{
                target: btn_reload
                enabled: window.isCurrentTab(argument.id)
                function onClicked() {
                    if(loading){
                        stop();
                    }
                    else{
                        reload();
                    }
                }
            }
            Connections{
                target: btn_home
                enabled: window.isCurrentTab(argument.id)
                function onClicked() {
                    argument.url=SettingsData.homeUrl;
                    url=SettingsData.homeUrl;
                }
            }
            Connections{
                target: urlLine
                enabled: window.isCurrentTab(argument.id)
                function onCommit(text) {
                    argument.url=text;
                    webView_.url=text;
                    forceActiveFocus();
                    download_page.visible=(webView_.url=="browser://downloads");
                    extension_page.visible=(webView_.url=="browser://extensions");
                    history_page.visible=(webView_.url=="browser://history");
                    settings_page.visible=(webView_.url=="browser://settings");
                    start_page.visible=(webView_.url=="browser://start");
                    web_tabView.setCurrentText(window.getSpecialTitle(text))
                }
            }
            Connections{
                target: web_tabView
                enabled: window.isCurrentTab(argument.id)
                function onCurrentIndexChanged(){
                    urlLine.text=url
                }
            }
            Connections{
                target: hotkey_toggle_fullscreen
                enabled: window.isCurrentTab(argument.id)
                function onActivated(){
                    if(is_fullscreen){
                        web_tabView.anchors.topMargin=30;
                        window.showNormal();
                        is_fullscreen=false;
                    }
                    else{
                        web_tabView.anchors.topMargin=-35;
                        window.showFullScreen();
                        window.y=-31;
                        window.height+=31;
                        is_fullscreen=true;
                    }
                }
            }
            Component.onCompleted: {
                btn_back.enabled = canGoBack;
                btn_forward.enabled = canGoForward;
                btn_reload.iconSource=loading ? LingmoIcons.Cancel : LingmoIcons.Refresh ;
                btn_reload.text=loading ? qsTr('Cancel Reload') : qsTr('Reload');
                profile.persistentStoragePath=Qt.resolvedUrl(".").toString().replace("qml/global","data/storage").replace("file:///","");
            }
            Downloads{
                id: download_page
                visible: argument.url=="browser://downloads"
                z: 32767
            }
            Extensions{
                id: extension_page
                visible: argument.url=="browser://extensions"
                z: 32767
            }
            History{
                id: history_page
                visible: argument.url=="browser://history"
                z: 32767
            }
            Settings{
                id: settings_page
                visible: argument.url=="browser://settings"
                z: 32767
            }
            StartPage{
                id: start_page
                visible: argument.url=="browser://start"
                z: 32767
            }
        }
    }
    LingmoMenu{
        id: more_menu
        width: 200
        x: parent.width-width
        y: 30
        LingmoMenuItem{
            text: qsTr('Open New Window')
            iconSource: LingmoIcons.FuzzyReading
            onClicked: {
                window.newWindowRequested()
            }
        }
        LingmoMenuItem{
            text: qsTr('Open New Tab')
            iconSource: LingmoIcons.OpenPane
            onClicked: {
                window.newTab()
            }
        }
        LingmoDivider{
            orientation: Qt.Horizontal
        }
        LingmoMenuItem{
            text: qsTr('Collections')
            iconSource: LingmoIcons.FavoriteList
            onClicked: {
                collections_popup.open()
            }
        }
        LingmoMenuItem{
            text: qsTr('History')
            iconSource: LingmoIcons.History
            onClicked: {
                history_popup.open()
            }
        }
        LingmoMenuItem{
            text: qsTr('Download')
            iconSource: LingmoIcons.Download
            onClicked: {
                download_popup.open()
            }
        }
        LingmoMenuItem{
            text: qsTr('Zoom')
            iconSource: LingmoIcons.ZoomIn
            onClicked: {
                zoom_popup.open()
            }
        }
        LingmoMenuItem{
            text: qsTr('Translations')
            iconSource: LingmoIcons.Characters
            onClicked: {
                translation_popup.open()
            }
        }
        LingmoMenuItem{
            text: qsTr('Extensions')
            iconSource: LingmoIcons.Puzzle
            onClicked: {
                extension_popup.open()
            }
        }
        LingmoMenuItem{
            text: qsTr('Find On Page')
            iconSource: LingmoIcons.SearchAndApps
            onClicked: {
                find_on_page_popup.open()
            }
        }
        LingmoMenuItem{
            text: qsTr('Settings')
            iconSource: LingmoIcons.Settings
            onClicked: {
                window.newTab("browser://settings")
            }
        }
    }
    LingmoMenu{
        id: context_menu
        LingmoMenuItem{
            text: '1'
        }
        LingmoMenuItem{
            text: '1'
        }
        LingmoMenuItem{
            text: '1'
        }
        LingmoDivider{
            orientation: Qt.Horizontal
        }
        LingmoMenuItem{
            text: '1'
        }
        LingmoMenuItem{
            text: '1'
        }
        LingmoMenuItem{
            text: '1'
        }
        LingmoMenuItem{
            text: '1'
        }
        LingmoMenuItem{
            text: '1'
        }
        LingmoMenuItem{
            text: '1'
        }
    }
    LingmoTooltip{
        id: toolTip
        property var requestType: TooltipRequest.Hide
        visible: requestType==TooltipRequest.Show
    }
    Rectangle{
        id: link_popup
        width: link_popup_text.width ? link_popup_text.width+10 : 0
        height: link_popup_text.height+10
        color: LingmoTheme.dark ? Qt.rgba(50 / 255, 49 / 255, 48 / 255,1) : Qt.rgba(1, 1, 1, 1)
        radius: LingmoUnits.smallRadius
        anchors.bottom: parent.bottom
        LingmoText{
            id: link_popup_text
            anchors.centerIn: parent
        }
        Behavior on visible {
            PropertyAnimation {
                duration: 500
            }
        }
    }
    CollectionsPopup{
        id: collections_popup
        parentWindow: window
        x: {return btn_collections.x+contorlRightButtons.x+btn_download.width-width}
        y: {return window.appBar.height+toolArea.height}
    }
    DownloadPopup{
        id: download_popup
        parentWindow: window
        download_requests: window.downloadRequests
        x: {return btn_download.x+contorlRightButtons.x+btn_download.width-width}
        y: {return window.appBar.height+toolArea.height}
    }
    ExtensionPopup{
        id: extension_popup
        parentWindow: window
        x: {return btn_extensions.x+contorlRightButtons.x+btn_download.width-width}
        y: {return window.appBar.height+toolArea.height}
    }
    FindOnPagePopup{
        id: find_on_page_popup
        parentWindow: window
        x: {return btn_find.x+contorlRightButtons.x+btn_download.width-width}
        y: {return window.appBar.height+toolArea.height}
    }
    HistoryPopup{
        id: history_popup
        parentWindow: window
        x: {return btn_history.x+contorlRightButtons.x+btn_download.width-width}
        y: {return window.appBar.height+toolArea.height}
    }
    TranslationPopup{
        id: translation_popup
        parentWindow: window
        x: {return btn_translation.x+contorlRightButtons.x+btn_download.width-width}
        y: {return window.appBar.height+toolArea.height}
    }
    ZoomPopup{
        id: zoom_popup
        parentWindow: window
        x: {return btn_zoom.x+contorlRightButtons.x+btn_download.width-width}
        y: {return window.appBar.height+toolArea.height}
    }
    LingmoHotkey{
        id: hotkey_toggle_fullscreen
        name: qsTr("Toogle Full Screen")
        sequence: "F11"
    }
}