import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQml
import QtCore
import QtWebEngine
import LingmoUI
import Qt.labs.platform as QLPF
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
    property int menuTriggerIndex: 0
    property list<LingmoMenuItem> targets: [contextMenuItem_back,contextMenuItem_forward,
                    contextMenuItem_undo,contextMenuItem_redo,contextMenuItem_cut,contextMenuItem_copy,
                    contextMenuItem_paste,contextMenuItem_paste_and_match_style,contextMenuItem_select_all,
                    contextMenuItem_text_direction_ltr,contextMenuItem_text_direction_rtl,contextMenuItem_open_link_in_this_window,contextMenuItem_open_link_in_new_window,
                    contextMenuItem_open_link_in_new_tab,contextMenuItem_copy_link_to_clipboard,contextMenuItem_download_link_to_disk,contextMenuItem_copy_image_to_clipboard,
                    contextMenuItem_copy_image_url_to_clipboard,contextMenuItem_download_image_to_disk,contextMenuItem_copy_media_url_to_clipboard,contextMenuItem_toggle_media_controls,
                    contextMenuItem_toggle_media_loop,contextMenuItem_toggle_media_play_pause,contextMenuItem_toggle_media_mute,contextMenuItem_download_media_to_disk,
                    contextMenuItem_exit_fullscreen,contextMenuItem_save_page,contextMenuItem_view_source,contextMenuItem_inspect_element];
    property list<int> actions: [WebEngineView.Back,WebEngineView.Forward,
                    WebEngineView.Undo,WebEngineView.Redo,WebEngineView.Cut,WebEngineView.Copy,
                    WebEngineView.Paste,WebEngineView.PasteAndMatchStyle,WebEngineView.SelectAll,
                    WebEngineView.ChangeTextDirectionLTR,WebEngineView.ChangeTextDirectionRTL,WebEngineView.OpenLinkInThisWindow,WebEngineView.OpenLinkInNewWindow,
                    WebEngineView.OpenLinkInNewTab,WebEngineView.CopyLinkToClipboard,WebEngineView.DownloadLinkToDisk,WebEngineView.CopyImageToClipboard,
                    WebEngineView.CopyImageUrlToClipboard,WebEngineView.DownloadImageToDisk,WebEngineView.CopyMediaUrlToClipboard,WebEngineView.ToggleMediaControls,
                    WebEngineView.ToggleMediaLoop,WebEngineView.ToggleMediaPlayPause,WebEngineView.ToggleMediaMute,WebEngineView.DownloadMediaToDisk,
                    WebEngineView.ExitFullScreen,WebEngineView.SavePage,WebEngineView.ViewSource,WebEngineView.InspectElement];
    property int contextMenuRequestViewId: 0
    signal newWindowRequested
    signal newDialogRequested
    property WebEngineView newWindowFirstView
    property WebEngineNewWindowRequest newWindowRequest
    function getSpecialTitle(url){
        if(url=="browser://collections/"||url=="browser://collections"){
            return "Collections"
        }
        else if(url=="browser://downloads/"||url=="browser://downloads"){
            return "Downloads"
        }
        else if(url=="browser://extensions/"||url=="browser://extensions"){
            return "Extensions"
        }
        else if(url=="browser://history/"||url=="browser://history"){
            return "History"
        }
        else if(url=="browser://settings/"||url=="browser://settings"){
            return "Settings"
        }
        else if(url=="browser://start/"||url=="browser://start"){
            return "Start Page"
        }
        else{
            return "New Tab"
        }
    }
    function newTab(url= SettingsData.homeUrl,autoSwitch=true){
        web_tabView.appendTab("qrc:/images/browser.svg",qsTr(getSpecialTitle(url)),com_webView,{"url": url,"id": webViewId},autoSwitch);
        webViewId+=1;
    }
    function isCurrentTab(tabId){
        if(web_tabView.currentItem){
            return tabId===web_tabView.currentItem.argument.id && window.active;
        }
        return false;
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
                    window.newTab("browser://settings/")
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
        SplitView{
            WebEngineView{
                id: webView_
                SplitView.preferredWidth: parent.width*0.7
                SplitView.fillHeight: true
                url: argument.url
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
                onIconChanged:{
                    var str=icon.toString();
                    web_tabView.get(now_index()).tab_icon=str.replace("image://favicon/","");
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
                    switch(request.destination){
                        case WebEngineNewWindowRequest.InNewTab:
                            window.newTab(request.requestedUrl);
                            break;
                        case WebEngineNewWindowRequest.InNewWindow:{
                            newWindowRequest=request;
                            window.newWindowRequested();
                            break;
                        }
                        case WebEngineNewWindowRequest.InNewDialog:{
                            newWindowRequest=request;
                            window.newDialogRequested();
                            break;
                        }
                        case WebEngineNewWindowRequest.InNewBackgroundTab:{
                            window.newTab(request.requestedUrl,false);
                            break;
                        }
                    }
                }
                onPrintRequested: {
                    
                }
                onRegisterProtocolHandlerRequested: function(request){
                    register_protocol_handler_request_popup.request=reqeust;
                    register_protocol_handler_request_popup.open();
                }
                onTitleChanged:{
                    if(window.getSpecialTitle(url)==="New Tab"){
                        web_tabView.get(now_index()).text=title;
                    }
                    else{
                        web_tabView.get(now_index()).text=window.getSpecialTitle(url);
                    }
                }
                onTooltipRequested: function(request){
                    request.accepted=true;
                    toolTip.x=request.x;
                    toolTip.y=request.y+30;
                    toolTip.text=request.text;
                    toolTip.requestType=request.type;
                }
                onUrlChanged: {
                    collections_page.visible=(webView_.url=="browser://collections/");
                    download_page.visible=(webView_.url=="browser://downloads/");
                    extension_page.visible=(webView_.url=="browser://extensions/");
                    history_page.visible=(webView_.url=="browser://history/");
                    settings_page.visible=(webView_.url=="browser://settings/");
                    start_page.visible=(webView_.url=="browser://start/");
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
                    web_tabView.closeTab(web_tabView.currentIndex);
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
                profile.onPresentNotification: function(request){
                    system_tray_icon.request=request;
                    system_tray_icon.visible=true;
                    system_tray_icon.icon.source="qrc:/images/tray-icon.png";
                    system_tray_icon.showMessage(request.title,request.message,webView_.icon);
                    request.show();
                }
                Connections{
                    target: btn_back
                    enabled: window.isCurrentTab(argument.id) 
                    function onClicked() {
                        webView_.goBack()
                    }
                }
                Connections{
                    target: btn_forward
                    enabled: window.isCurrentTab(argument.id)
                    function onClicked() {
                        webView_.goForward()
                    }
                }
                Connections{
                    target: btn_reload
                    enabled: window.isCurrentTab(argument.id)
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
                    enabled: window.isCurrentTab(argument.id)
                    function onClicked() {
                        urlLine.text=SettingsData.homeUrl;
                        argument.url=SettingsData.homeUrl;
                        webView_.url=SettingsData.homeUrl;
                    }
                }
                Connections{
                    target: urlLine
                    enabled: window.isCurrentTab(argument.id)
                    function onCommit(text) {
                        text=UrlRedirectHandler.redirect(text);
                        argument.url=text;
                        webView_.url=text;
                        forceActiveFocus();
                        collections_page.visible=(webView_.url=="browser://collections/");
                        download_page.visible=(webView_.url=="browser://downloads/");
                        extension_page.visible=(webView_.url=="browser://extensions/");
                        history_page.visible=(webView_.url=="browser://history/");
                        settings_page.visible=(webView_.url=="browser://settings/");
                        start_page.visible=(webView_.url=="browser://start/");
                        web_tabView.setCurrentText(window.getSpecialTitle(text))
                    }
                }
                Connections{
                    target: web_tabView
                    enabled: window.isCurrentTab(argument.id)
                    function onCurrentIndexChanged(){
                        urlLine.text=webView_.url
                    }
                }
                Connections{
                    target: hotkey_toggle_fullscreen
                    enabled: window.isCurrentTab(argument.id)
                    function onActivated(){
                        if(webView_.is_fullscreen){
                            web_tabView.anchors.topMargin=30;
                            window.showNormal();
                            webView_.is_fullscreen=false;
                        }
                        else{
                            web_tabView.anchors.topMargin=-35;
                            window.showFullScreen();
                            window.y=-31;
                            window.height+=31;
                            webView_.is_fullscreen=true;
                        }
                    }
                }
                Connections{
                    target: hotkey_open_devTools
                    enabled: window.isCurrentTab(argument.id)
                    function onActivated(){
                        webView_devtools.visible=!webView_devtools.visible;
                    }
                }
                Connections{
                    target: zoom_popup.zoom_in_button
                    enabled: window.isCurrentTab(argument.id)
                    function onClicked(){
                        webView_.zoomFactor+=0.05
                        zoom_popup.text=Math.floor(webView_.zoomFactor*100+0.5).toString()+"%"
                    }
                }
                Connections{
                    target: zoom_popup.zoom_out_button
                    enabled: window.isCurrentTab(argument.id)
                    function onClicked(){
                        webView_.zoomFactor-=0.05;
                        zoom_popup.text=Math.floor(webView_.zoomFactor*100+0.5).toString()+"%"
                    }
                }
                Connections{
                    target: zoom_popup.reset_button
                    enabled: window.isCurrentTab(argument.id)
                    function onClicked(){
                        webView_.zoomFactor=1;
                        zoom_popup.text=Math.floor(webView_.zoomFactor*100+0.5).toString()+"%"
                    }
                }
                Connections{
                    target: contextMenuItem_reload_cancel
                    enabled: window.isCurrentTab(argument.id)
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
                    enabled: window.isCurrentTab(argument.id)
                    function onClicked() {
                        urlLine.text=SettingsData.homeUrl;
                        argument.url=SettingsData.homeUrl;
                        webView_.url=SettingsData.homeUrl;
                    }
                }
                Connections{
                    target: contextMenuItem_inspect_element
                    enabled: window.isCurrentTab(argument.id)
                    function onClicked() {
                        webView_devtools.visible=true;
                    }
                }
                Connections{
                    target: contextMenuItem_exit_fullscreen
                    enabled: window.isCurrentTab(argument.id)
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
                    visible: argument.url=="browser://collections/"
                    z: 32767
                }
                Downloads{
                    id: download_page
                    visible: argument.url=="browser://downloads/"
                    z: 32767
                }
                Extensions{
                    id: extension_page
                    visible: argument.url=="browser://extensions/"
                    z: 32767
                }
                History{
                    id: history_page
                    visible: argument.url=="browser://history/"
                    z: 32767
                }
                Settings{
                    id: settings_page
                    visible: argument.url=="browser://settings/"
                    z: 32767
                }
                StartPage{
                    id: start_page
                    visible: argument.url=="browser://start/"
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
            }
            WebEngineView{
                id: webView_devtools
                url: "http://127.0.0.1:1112/devtools/inspector.html?ws=127.0.0.1:1112/devtools/page/"+webView_.devToolsId
                SplitView.fillHeight: true
                visible: false
                onTooltipRequested: function(request){
                    request.accepted=true;
                    toolTip.x=request.x+webView_devtools.x;
                    toolTip.y=request.y+30;
                    toolTip.text=request.text;
                    toolTip.requestType=request.type;
                }
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
                window.newTab("browser://settings/")
            }
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
        LingmoMenuItem{
            id: contextMenuItem_inspect_element
            text: qsTr("Inspect Element")
            iconSource: LingmoIcons.NewWindow
            onClicked:{
                window.menuTriggerIndex=28;
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
    LingmoPopup{
        id: feature_request_popup
        x: 10
        y: {return window.appBar.height+toolArea.height}
        width: 400
        height: 150
        modal: false
        property url securityOrigin
        property var feature
        property string requestText
        property WebEngineView webView
        ColumnLayout{
            anchors.fill: parent
            anchors.margins: 10
            LingmoText{
                text: feature_request_popup.securityOrigin+" "+qsTr("Requests")
                font: LingmoTextStyle.BodyStrong
            }
            LingmoText{
                text: feature_request_popup.requestText
                font: LingmoTextStyle.Body
            }
            RowLayout{
                spacing: 10
                Layout.alignment: Qt.AlignJustify
                LingmoButton{
                    text: qsTr("Accept")
                    onClicked: {
                        feature_request_popup.close();
                        feature_request_popup.webView.grantFeaturePermission(feature_request_popup.securityOrigin,feature_request_popup.feature,true);
                    }
                }
                LingmoButton{
                    text: qsTr("Reject")
                    onClicked: {
                        feature_request_popup.close();
                        feature_request_popup.webView.grantFeaturePermission(feature_request_popup.securityOrigin,feature_request_popup.feature,false);
                    }
                }
            }
        }
    }
    LingmoPopup{
        id: dialog_request_popup
        y: {return window.appBar.height+toolArea.height}
        width: 400
        padding: 10
        bottomPadding: 20
        modal: false
        property JavaScriptDialogRequest request
        ColumnLayout{
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10
            LingmoText{
                text: dialog_request_popup.request ? dialog_request_popup.request.securityOrigin + qsTr(" Displays") : ""
                font: LingmoTextStyle.BodyStrong
            }
            LingmoText{
                text: dialog_request_popup.request ? (dialog_request_popup.request.type===JavaScriptDialogRequest.DialogTypeBeforeUnload ? "Are you sure you want to leave this page? The changes you have made may not be saved." : dialog_request_popup.request.message ): ""
                wrapMode: Text.WordWrap
                font: LingmoTextStyle.Body
                Layout.preferredWidth: parent.width-10
            }
            LingmoTextBox{
                id: dialog_entry
                visible: dialog_request_popup.request && dialog_request_popup.request.type===JavaScriptDialogRequest.DialogTypePrompt
                placeholderText: dialog_request_popup.request ? dialog_request_popup.request.defaultText : ""
                Layout.fillWidth: true
                cleanEnabled: false
            }
            RowLayout{
                spacing: 10
                Layout.alignment: Qt.AlignRight
                LingmoFilledButton{
                    text: qsTr("OK")
                    Layout.alignment: Qt.AlignRight
                    onClicked: {
                        if(dialog_request_popup.request && dialog_request_popup.request.type===JavaScriptDialogRequest.DialogTypePrompt){
                            dialog_request_popup.request.dialogAccept(dialog_entry.text);
                        }
                        else{
                            dialog_request_popup.request.dialogAccept()
                        }
                        dialog_request_popup.close();
                    }
                }
                LingmoButton{
                    text: qsTr("Cancel")
                    Layout.alignment: Qt.AlignRight
                    visible: dialog_request_popup.request &&(dialog_request_popup.request.type===JavaScriptDialogRequest.DialogTypePrompt || 
                                dialog_request_popup.request.type===JavaScriptDialogRequest.DialogTypeConfirm ||
                                dialog_request_popup.request.type===JavaScriptDialogRequest.DialogTypeBeforeUnload)
                    onClicked: {
                        dialog_request_popup.request.dialogReject()
                        dialog_request_popup.close();
                    }
                }
            }
        }
    }
    LingmoPopup{
        id: register_protocol_handler_request_popup
        x: {return window.width-width-10}
        y: {return window.appBar.height+toolArea.height}
        width: 400
        padding: 10
        bottomPadding: 20
        modal: false
        property var request
        ColumnLayout{
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10
            LingmoText{
                text: register_protocol_handler_request_popup.request ? register_protocol_handler_request_popup.request.origin : ""
                font: LingmoTextStyle.BodyStrong
            }
            LingmoText{
                text: qsTr("Requests Register Protocol Handler")
                font: LingmoTextStyle.Body
                Layout.preferredWidth: parent.width-10
            }
            RowLayout{
                spacing: 10
                Layout.alignment: Qt.AlignRight
                LingmoFilledButton{
                    text: qsTr("Accept")
                    Layout.alignment: Qt.AlignRight
                    onClicked: {
                        register_protocol_handler_request_popup.request.accept();
                        register_protocol_handler_request_popup.close();
                    }
                }
                LingmoButton{
                    text: qsTr("Reject")
                    Layout.alignment: Qt.AlignRight
                    onClicked: {
                        register_protocol_handler_request_popup.request.reject()
                        register_protocol_handler_request_popup.close();
                    }
                }
            }
        }
    }
    LingmoHotkey{
        id: hotkey_toggle_fullscreen
        name: qsTr("Toogle Full Screen")
        sequence: "F11"
    }
    LingmoHotkey{
        id: hotkey_open_devTools
        name: qsTr("Open Dev Tools")
        sequence: "Alt+F12"
    }
    QLPF.SystemTrayIcon{
        id: system_tray_icon
        property WebEngineNotification request
        onMessageClicked: {
            request.click();
        }
        onVisibleChanged: {
            if(visible==false){
                request.close();
            }
        }
        visible: true
        
        icon.source: "qrc:/images/browser.svg"
    }
}