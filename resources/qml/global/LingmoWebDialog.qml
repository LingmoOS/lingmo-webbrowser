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
    property int webViewId: 0
    property FileDialog fileDialog
    property FolderDialog folderDialog
    property ColorDialog colorDialog
    property ListModel downloadRequests
    property int menuTriggerIndex: 0
    property list<LingmoMenuItem> targets: [contextMenuItem_back,contextMenuItem_forward,
                    contextMenuItem_undo,contextMenuItem_redo,contextMenuItem_cut,contextMenuItem_copy,
                    contextMenuItem_paste,contextMenuItem_paste_and_match_style,contextMenuItem_select_all,
                    contextMenuItem_text_direction_ltr,contextMenuItem_text_direction_rtl,contextMenuItem_open_link_in_this_window,contextMenuItem_open_link_in_new_window,
                    contextMenuItem_open_link_in_new_tab,contextMenuItem_copy_link_to_clipboard,contextMenuItem_download_link_to_disk,contextMenuItem_copy_image_to_clipboard,
                    contextMenuItem_copy_image_url_to_clipboard,contextMenuItem_download_image_to_disk,contextMenuItem_copy_media_url_to_clipboard,contextMenuItem_toggle_media_controls,
                    contextMenuItem_toggle_media_loop,contextMenuItem_toggle_media_play_pause,contextMenuItem_toggle_media_mute,contextMenuItem_download_media_to_disk,
                    contextMenuItem_exit_fullscreen,contextMenuItem_save_page,contextMenuItem_view_source];
    property list<int> actions: [WebEngineView.Back,WebEngineView.Forward,
                    WebEngineView.Undo,WebEngineView.Redo,WebEngineView.Cut,WebEngineView.Copy,
                    WebEngineView.Paste,WebEngineView.PasteAndMatchStyle,WebEngineView.SelectAll,
                    WebEngineView.ChangeTextDirectionLTR,WebEngineView.ChangeTextDirectionRTL,WebEngineView.OpenLinkInThisWindow,WebEngineView.OpenLinkInNewWindow,
                    WebEngineView.OpenLinkInNewTab,WebEngineView.CopyLinkToClipboard,WebEngineView.DownloadLinkToDisk,WebEngineView.CopyImageToClipboard,
                    WebEngineView.CopyImageUrlToClipboard,WebEngineView.DownloadImageToDisk,WebEngineView.CopyMediaUrlToClipboard,WebEngineView.ToggleMediaControls,
                    WebEngineView.ToggleMediaLoop,WebEngineView.ToggleMediaPlayPause,WebEngineView.ToggleMediaMute,WebEngineView.DownloadMediaToDisk,
                    WebEngineView.ExitFullScreen,WebEngineView.SavePage,WebEngineView.ViewSource];
    property int contextMenuRequestViewId: 0
    signal newWindowRequested
    signal newDialogRequested
    property WebEngineView newWindowFirstView
    property WebEngineNewWindowRequest newWindowRequest
    function getSpecialTitle(url){
        if(url=="browser://collections"){
            return "Collections"
        }
        else if(url=="browser://downloads"){
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
    Component.onCompleted: {
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
            text: webView_.url
            anchors.left: contorlLeftButtons.right 
            anchors.right: parent.right
            cleanEnabled: false
            height: parent.height
        }
    }
    property alias webView: webView_
    WebEngineView{
        id: webView_
        y: contorlLeftButtons.height
        width: window.width
        height: window.height - contorlLeftButtons.height
        property bool is_fullscreen: false
        property real prev_zoomFactor: 1.0
        onAuthenticationDialogRequested: {
            
        }
        onCanGoBackChanged: {
            btn_back.enabled = canGoBack
            contextMenuItem_back.enabled = canGoBack
        }
        onCanGoForwardChanged: {
            btn_forward.enabled = canGoForward
            contextMenuItem_forward.enabled = canGoForward
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
            contextMenuRequestViewId=argument.id;
            context_menu.x=request.position.x;
            context_menu.y=request.position.y+60;
            for(var i=2;i<=10;i++){
                targets[i].visible=request.isContentEditable;
            }
            contextMenuDivider_edit.visible=request.isContentEditable;
            for(var i=11;i<=15;i++){
                targets[i].visible=request.linkUrl!==Qt.url("");
            }
            contextMenuDivider_link.visible=request.linkUrl!==Qt.url("");
            for(var i=16;i<=18;i++){
                targets[i].visible=request.mediaUrl!==Qt.url("")&&request.mediaType==ContextMenuRequest.MediaTypeImage;
            }
            contextMenuDivider_image.visible=request.mediaUrl!==Qt.url("")&&request.mediaType==ContextMenuRequest.MediaTypeImage;
            for(var i=19;i<=24;i++){
                targets[i].visible=request.mediaUrl!==Qt.url("");
            }
            contextMenuDivider_media.visible=request.mediaUrl!==Qt.url("");
            context_menu.contentData[12].visible=request.isContentEditable;
            contextMenuItem_exit_fullscreen.visible=webView_.is_fullscreen||webView_.isFullScreen;
            contextMenuDivider_exit_fullscreen.visible=webView_.is_fullscreen||webView_.isFullScreen;
            contextMenuItem_undo.enabled=(request.editFlags&ContextMenuRequest.CanUndo);
            contextMenuItem_redo.enabled=(request.editFlags&ContextMenuRequest.CanRedo);
            contextMenuItem_cut.enabled=(request.editFlags&ContextMenuRequest.CanCut);
            contextMenuItem_copy.enabled=(request.editFlags&ContextMenuRequest.CanCopy);
            contextMenuItem_paste.enabled=(request.editFlags&ContextMenuRequest.CanPaste);
            contextMenuItem_paste_and_match_style.enabled=(request.editFlags&ContextMenuRequest.CanPaste);
            contextMenuItem_select_all.enabled=(request.editFlags&ContextMenuRequest.CanSelectAll);
            context_menu.open();
        }
        onFeaturePermissionRequested: function(securityOrigin,feature){
            feature_request_popup.securityOrigin=securityOrigin;
            feature_request_popup.feature=feature;
            feature_request_popup.webView=webView_;
            switch(feature){
                case WebEngineView.Geolocation:
                    feature_request_popup.requestText=qsTr("Geolocation")
                    break;
                case WebEngineView.MediaAudioCapture:
                    feature_request_popup.requestText=qsTr("Audio Capture")
                    break;
                case WebEngineView.MediaVideoCapture:
                    feature_request_popup.requestText=qsTr("Video Capture")
                    break;
                case WebEngineView.MediaAudioVideoCapture:
                    feature_request_popup.requestText=qsTr("Audio and Video Capture")
                    break;
                case WebEngineView.DesktopVideoCapture:
                    feature_request_popup.requestText=qsTr("Desktop Video Capture")
                    break;
                case WebEngineView.DesktopAudioVideoCapture:
                    feature_request_popup.requestText=qsTr("Desktop Audio and Video Capture")
                    break;
                case WebEngineView.Notifications:
                    feature_request_popup.requestText=qsTr("Notifications")
                    break;
            }
            feature_request_popup.open();
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
        onLinkHovered: function(link){
            link_popup.visible=true;
            link_popup_text.text=link;
        }
        onJavaScriptDialogRequested: function(request){
            request.accepted=true;
            dialog_request_popup.request=request;
            dialog_entry.text="";
            dialog_request_popup.open();
        }
        onLoadingChanged: {
            btn_reload.iconSource=loading ? LingmoIcons.Cancel : LingmoIcons.Refresh 
            btn_reload.text=loading ? qsTr('Cancel Reload') : qsTr('Reload')
            contextMenuItem_reload_cancel.iconSource=loading ? LingmoIcons.Cancel : LingmoIcons.Refresh 
            contextMenuItem_reload_cancel.text=loading ? qsTr('Cancel Reload') : qsTr('Reload')
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
            webView_.url=request.requestedUrl;
        }
        onPrintRequested: {

        }
        onRegisterProtocolHandlerRequested: {

        }
        onTooltipRequested: function(request){
            request.accepted=true;
            toolTip.x=request.x;
            toolTip.y=request.y+30;
            toolTip.text=request.text;
            toolTip.requestType=request.type;
        }
        onUrlChanged: {
            if(collections_page.visible){
                return;
            }
            if(download_page.visible){
                return;
            }
            if(extension_page.visible){
                return;
            }
            if(history_page.visible){
                return;
            }
            if(settings_page.visible){
                return;
            }
            if(start_page.visible){
                return;
            }
            urlLine.text = url
        }
        onWebAuthUxRequested: {
            
        }
        onWindowCloseRequested: {
            window.close();
        }
        settings.pluginsEnabled: true
        settings.fullScreenSupportEnabled: true
        profile.offTheRecord: false
        profile.downloadPath: {return SettingsData.downloadPath}
        settings.localStorageEnabled: true
        profile.onDownloadRequested: function(request){
            for(var i=0;i<window.downloadRequests.count;i++){
                if(window.downloadRequests.get(i).id==request.id)return;
            }
            window.downloadRequests.append({"request": request,"id": request.id,"profile": profile})
            request.accept();
            download_popup.open();
        }
        Connections{
            target: btn_back 
            function onClicked() {
                webView_.goBack()
            }
        }
        Connections{
            target: btn_forward
            function onClicked() {
                webView_.goForward()
            }
        }
        Connections{
            target: btn_reload
            function onClicked() {
                if(webView_.loading){
                    webView_.stop();
                }
                else{
                    webView_.reload();
                }
            }
        }
        Connections{
            target: btn_home
            function onClicked() {
                urlLine.text=SettingsData.homeUrl;
                argument.url=SettingsData.homeUrl;
                webView_.url=SettingsData.homeUrl;
            }
        }
        Connections{
            target: urlLine
            function onCommit(text) {
                text=UrlRedirectHandler.redirect(text);
                argument.url=text;
                webView_.url=text;
                forceActiveFocus();
                collections_page.visible=(webView_.url=="browser://collections");
                download_page.visible=(webView_.url=="browser://downloads");
                extension_page.visible=(webView_.url=="browser://extensions");
                history_page.visible=(webView_.url=="browser://history");
                settings_page.visible=(webView_.url=="browser://settings");
                start_page.visible=(webView_.url=="browser://start");
                web_tabView.setCurrentText(window.getSpecialTitle(text))
            }
        }
        Connections{
            target: contextMenuItem_reload_cancel
            function onClicked() {
                if(webView_.loading){
                    webView_.stop();
                }
                else{
                    webView_.reload();
                }
            }
        }
        Connections{
            target: contextMenuItem_home
            function onClicked() {
                urlLine.text=SettingsData.homeUrl;
                argument.url=SettingsData.homeUrl;
                webView_.url=SettingsData.homeUrl;
            }
        }
        Connections{
            target: contextMenuItem_exit_fullscreen
            function onClicked(){
                web_tabView.anchors.topMargin=30;
                window.showNormal();
                webView_.is_fullscreen=false;
            }
        }
        Component.onCompleted: {
            newWindowFirstView=webView_;
            btn_back.enabled = canGoBack;
            btn_forward.enabled = canGoForward;
            btn_reload.iconSource=loading ? LingmoIcons.Cancel : LingmoIcons.Refresh ;
            btn_reload.text=loading ? qsTr('Cancel Reload') : qsTr('Reload');
            contextMenuItem_back.enabled = canGoBack;
            contextMenuItem_forward.enabled = canGoForward;
            contextMenuItem_reload_cancel.iconSource=loading ? LingmoIcons.Cancel : LingmoIcons.Refresh ;
            contextMenuItem_reload_cancel.text=loading ? qsTr('Cancel Reload') : qsTr('Reload');
            profile.persistentStoragePath=Qt.resolvedUrl(".").toString().replace("qml/global","data/storage").replace("file:///","");
            profile.persistentCookiesPolicy=WebEngineProfile.ForcePersistentCookies;
            profile.cachePath=Qt.resolvedUrl(".").toString().replace("qml/global","data/cache").replace("file:///","");
            profile.httpCacheType=WebEngineProfile.DiskHttpCache;
            for(var i=0;i<targets.length;i++){
                targets[i].clicked.connect(function(){
                    if(argument&&window.isCurrentTab(argument.id)){
                        webView_.triggerWebAction(actions[menuTriggerIndex]);
                    }
                })
            }
        }
        Collections{
            id: collections_page
            visible: webView_.url=="browser://collections"
            z: 32767
        }
        Downloads{
            id: download_page
            visible: webView_.url=="browser://downloads"
            z: 32767
        }
        Extensions{
            id: extension_page
            visible: webView_.url=="browser://extensions"
            z: 32767
        }
        History{
            id: history_page
            visible: webView_.url=="browser://history"
            z: 32767
        }
        Settings{
            id: settings_page
            visible: webView_.url=="browser://settings"
            z: 32767
        }
        StartPage{
            id: start_page
            visible: webView_.url=="browser://start"
            z: 32767
        }
        function hidePages(){
            collections_page.visible=false;
            download_page.visible=false;
            extension_page.visible=false;
            history_page.visible=false;
            settings_page.visible=false;
            start_page.visible=false;
        }
        function resizeByRequest(request){
            window.x=request.requestedGeometry.x;
            window.y=request.requestedGeometry.y;
            window.width=request.requestedGeometry.width;
            window.height=request.requestedGeometry.height+contorlLeftButtons.height;
        }
    }
    LingmoMenu{
        id: context_menu
        width: 300
        LingmoMenuItem{
            id: contextMenuItem_back
            text: qsTr('Back')
            iconSource: LingmoIcons.Back
            onClicked:{
                window.menuTriggerIndex=0;
            }
        }
        LingmoMenuItem{
            id: contextMenuItem_forward
            text: qsTr('Forward')
            iconSource: LingmoIcons.Forward
            onClicked:{
                window.menuTriggerIndex=1;
            }
        }
        LingmoMenuItem{
            id: contextMenuItem_reload_cancel
            text: qsTr('Reload')
            iconSource: LingmoIcons.Refresh
        }
        LingmoMenuItem{
            id: contextMenuItem_home
            text: qsTr('Home')
            iconSource: LingmoIcons.Home
        }
        LingmoDivider{
            orientation: Qt.Horizontal
        }
        LingmoMenuItem{
            id: contextMenuItem_undo
            text: qsTr('Undo')
            iconSource: LingmoIcons.Undo
            onClicked:{
                window.menuTriggerIndex=2;
            }
        }
        LingmoMenuItem{
            id: contextMenuItem_redo
            text: qsTr('Redo')
            iconSource: LingmoIcons.Redo
            onClicked:{
                window.menuTriggerIndex=3;
            }
        }
        LingmoMenuItem{
            id: contextMenuItem_cut
            text: qsTr('Cut')
            iconSource: LingmoIcons.Cut
            onClicked:{
                window.menuTriggerIndex=4;
            }
        }
        LingmoMenuItem{
            id: contextMenuItem_copy
            text: qsTr('Copy')
            iconSource: LingmoIcons.Copy
            onClicked:{
                window.menuTriggerIndex=5;
            }
        }
        LingmoMenuItem{
            id: contextMenuItem_paste
            text: qsTr('Paste')
            iconSource: LingmoIcons.Paste
            onClicked:{
                window.menuTriggerIndex=6;
            }
        }
        LingmoMenuItem{
            id: contextMenuItem_paste_and_match_style
            text: qsTr('Paste And Match Style')
            iconSource: LingmoIcons.Paste
            onClicked:{
                window.menuTriggerIndex=7;
            }
        }
        LingmoMenuItem{
            id: contextMenuItem_select_all
            text: qsTr('Select All')
            iconSource: LingmoIcons.SelectAll
            onClicked:{
                window.menuTriggerIndex=8;
            }
        }
        LingmoMenu{
            id: contextMenuItem_text_direction
            title: qsTr('Text Direction')
            width: 300
            LingmoMenuItem{
                id: contextMenuItem_text_direction_ltr
                text: qsTr('Change Text Direction Left To Right')
                iconSource: LingmoIcons.ArrowRight8
                onClicked:{
                    window.menuTriggerIndex=9;
                }
            }
            LingmoMenuItem{
                id: contextMenuItem_text_direction_rtl
                text: qsTr('Change Text Direction Right To Left')
                iconSource: LingmoIcons.ArrowLeft8
                onClicked:{
                    window.menuTriggerIndex=10;
                }
            }
        }
        LingmoDivider{
            id: contextMenuDivider_edit
            orientation: Qt.Horizontal
        }
        LingmoMenuItem{
            id: contextMenuItem_open_link_in_this_window
            text: qsTr('Open Link In This Tab')
            iconSource: LingmoIcons.OpenPaneMirrored
            onClicked:{
                window.menuTriggerIndex=11;
            }
        }
        LingmoMenuItem{
            id: contextMenuItem_open_link_in_new_window
            text: qsTr('Open Link In New Window')
            iconSource: LingmoIcons.OpenInNewWindow
            onClicked:{
                window.menuTriggerIndex=12;
            }
        }
        LingmoMenuItem{
            id: contextMenuItem_open_link_in_new_tab
            text: qsTr('Open Link In New Tab')
            iconSource: LingmoIcons.OpenWith
            onClicked:{
                window.menuTriggerIndex=13;
            }
        }
        LingmoMenuItem{
            id: contextMenuItem_copy_link_to_clipboard
            text: qsTr('Copy Link To Clipboard')
            iconSource: LingmoIcons.CopyTo
            onClicked:{
                window.menuTriggerIndex=14;
            }
        }
        LingmoMenuItem{
            id: contextMenuItem_download_link_to_disk
            text: qsTr('Download Link To Disk')
            iconSource: LingmoIcons.Download
            onClicked:{
                window.menuTriggerIndex=15;
            }
        }
        LingmoDivider{
            id: contextMenuDivider_link
            orientation: Qt.Horizontal
        }
        LingmoMenuItem{
            id: contextMenuItem_copy_image_to_clipboard
            text: qsTr('Copy Image To Clipboard')
            iconSource: LingmoIcons.CopyTo
            onClicked:{
                window.menuTriggerIndex=16;
            }
        }
        LingmoMenuItem{
            id: contextMenuItem_copy_image_url_to_clipboard
            text: qsTr('Copy Image Url To Clipboard')
            iconSource: LingmoIcons.CopyTo
            onClicked:{
                window.menuTriggerIndex=17;
            }
        }
        LingmoMenuItem{
            id: contextMenuItem_download_image_to_disk
            text: qsTr('Download Image To Disk')
            iconSource: LingmoIcons.Download
            onClicked:{
                window.menuTriggerIndex=18;
            }
        }
        LingmoDivider{
            id: contextMenuDivider_image
            orientation: Qt.Horizontal
        }
        LingmoMenuItem{
            id: contextMenuItem_copy_media_url_to_clipboard
            text: qsTr('Copy Media Url To Clipboard')
            iconSource: LingmoIcons.Download
            onClicked:{
                window.menuTriggerIndex=19;
            }
        }
        LingmoMenuItem{
            id: contextMenuItem_toggle_media_controls
            text: qsTr('Toggle Media Controls')
            iconSource: LingmoIcons.CallControl
            onClicked:{
                window.menuTriggerIndex=20;
            }
        }
        LingmoMenuItem{
            id: contextMenuItem_toggle_media_loop
            text: qsTr('Toggle Media Loop')
            iconSource: LingmoIcons.RestartUpdate
            onClicked:{
                window.menuTriggerIndex=21;
            }
        }
        LingmoMenuItem{
            id: contextMenuItem_toggle_media_play_pause
            text: qsTr('Toggle Media Play Pause')
            iconSource: LingmoIcons.Play
            onClicked:{
                window.menuTriggerIndex=22;
            }
        }
        LingmoMenuItem{
            id: contextMenuItem_toggle_media_mute
            text: qsTr('Toggle Media Mute')
            iconSource: LingmoIcons.Mute
            onClicked:{
                window.menuTriggerIndex=23;
            }
        }
        LingmoMenuItem{
            id: contextMenuItem_download_media_to_disk
            text: qsTr('Download Media To Disk')
            iconSource: LingmoIcons.Download
            onClicked:{
                window.menuTriggerIndex=24;
            }
        }
        LingmoDivider{
            id: contextMenuDivider_media
            orientation: Qt.Horizontal
        }
        LingmoMenuItem{
            id: contextMenuItem_exit_fullscreen
            text: qsTr("Exit Fullescreen")
            iconSource: LingmoIcons.BackToWindow
            onClicked:{
                window.menuTriggerIndex=25;
            }
        }
        LingmoDivider{
            id: contextMenuDivider_exit_fullscreen
            orientation: Qt.Horizontal
        }
        LingmoMenuItem{
            id: contextMenuItem_save_page
            text: qsTr("Save Page")
            iconSource: LingmoIcons.Save
            onClicked:{
                window.menuTriggerIndex=26;
            }
        }
        LingmoDivider{
            orientation: Qt.Horizontal
        }
        LingmoMenuItem{
            id: contextMenuItem_view_source
            text: qsTr("View Source")
            iconSource: LingmoIcons.Code
            onClicked:{
                window.menuTriggerIndex=27;
            }
        }
        onAboutToHide: {
            contextMenuItem_text_direction.close();
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
}