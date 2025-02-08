import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtWebEngine
import LingmoUI
import org.lingmo.webbrowser
import pages

LingmoWindow{
    id: window
    visible: true
    width: 1000
    height: 600
    showDark: true
    property string config: {
        var request = new XMLHttpRequest();
        request.open("GET", 'file://../../conf/main.conf', false); 
        request.send(null);
        return request.responseText;
    }
    property string home_url: 'https://bing.com'
    property int webViewId: 0
    property FileDialog fileDialog
    property FolderDialog folderDialog
    property ColorDialog colorDialog
    function newTab(url= window.home_url){
        web_tabView.appendTab("https://cn.bing.com/sa/simg/favicon-trans-bg-blue-mg-png.png",qsTr("New Tab"),com_webView,{"url": url,"id": webViewId},true);
        webViewId+=1;
    }
    Component.onCompleted: {
        newTab()
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
                    more_menu.open()
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
                    more_menu.open()
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
                    more_menu.open()
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
                    more_menu.open()
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
                    more_menu.open()
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
                    more_menu.open()
                }
            }
            LingmoIconButton {
                id: btn_screen_shot
                Layout.preferredWidth: 40
                Layout.preferredHeight: 30
                padding: 0
                verticalPadding: 0
                horizontalPadding: 0
                rightPadding: 2
                iconSource: LingmoIcons.Annotation
                Layout.alignment: Qt.AlignVCenter
                iconSize: 15
                text: qsTr('Screen Shot')
                radius: LingmoUnits.windowRadius
                onClicked: {
                    more_menu.open()
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
                    more_menu.open()
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
            onColorDialogRequested: {

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
                        fileDialog.accepted.connect(request.dialogAccept);
                        fileDialog.rejected.connect(request.dialogReject);
                        fileDialog.visible = true;
                    }
                    case FileDialogRequest.FileModeOpenMultiple: {
                        fileDialog.accepted.connect(request.dialogAccept);
                        fileDialog.rejected.connect(request.dialogReject);
                        fileDialog.visible = true;
                    }
                    case FileDialogRequest.FileModeUploadFolder: {
                        forderDialog.accepted.connect(request.dialogAccept);
                        forderDialog.rejected.connect(request.dialogReject);
                        forderDialog.visible = true;
                    }
                    case FileDialogRequest.FileModeSave: {
                        fileDialog.accepted.connect(request.dialogAccept);
                        fileDialog.rejected.connect(request.dialogReject);
                        fileDialog.visible = true;
                    }
                }
            }
            onFileSystemAccessRequested: {
                
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
                var str=icon.toString()
                web_tabView.setCurrentTabIcon(str.replace("image://favicon/",""));
            }
            onLinkHovered: function(link){
                link_popup.visible=true;
                link_popup_text.text=link;
            }
            onJavaScriptDialogRequested: {

            }
            onLoadingChanged: {
                btn_reload.iconSource=loading ? LingmoIcons.Cancel : LingmoIcons.Refresh 
                btn_reload.text=loading ? qsTr('Cancel Reload') : qsTr('Reload')
            }
            onNavigationRequested: function(request){
                switch(request.navigationType){
                    case WebEngineNavigationRequest.LinkClickedNavigation: {
                        print('Link Clicked Navigation');
                        break;
                    }
                    case WebEngineNavigationRequest.TypedNavigation: {
                        print('Typed Navigation');
                        break;
                    }
                    case WebEngineNavigationRequest.FormSubmittedNavigation: {
                        print('Form Submitted Navigation');
                        break;
                    }
                    case WebEngineNavigationRequest.BackForwardNavigation: {
                        print('Back/Forward Navigation');
                        break;
                    }
                    case WebEngineNavigationRequest.ReloadNavigation: {
                        print('Reload Navigation');
                        break;
                    }
                    case WebEngineNavigationRequest.RedirectNavigation: {
                        print('Redirect Navigation');
                        break;
                    }
                    case WebEngineNavigationRequest.OtherNavigation: {
                        print('Other Navigation');
                        break;
                    }
                }
            }
            onNewWindowRequested: function(request) {
                window.newTab(request.requestedUrl)
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
            Connections{
                target: btn_back
                enabled: argument.id===web_tabView.currentItem.argument.id
                function onClicked() {
                    goBack()
                }
            }
            Connections{
                target: btn_forward
                enabled: argument.id===web_tabView.currentItem.argument.id
                function onClicked() {
                    goForward()
                }
            }
            Connections{
                target: btn_reload
                enabled: argument.id===web_tabView.currentItem.argument.id
                function onClicked() {
                    if(loading){
                        stop();
                    }
                    else{
                        reload()
                    }
                }
            }
            Connections{
                target: btn_home
                enabled: argument.id===web_tabView.currentItem.argument.id
                function onClicked() {
                    argument.url=window.home_url;
                    url=window.home_url;
                }
            }
            Connections{
                target: urlLine
                enabled: argument.id===web_tabView.currentItem.argument.id
                function onCommit(text) {
                    argument.url=text;
                    url=text;
                    forceActiveFocus();
                }
            }
            Connections{
                target: web_tabView
                enabled: argument.id===web_tabView.currentItem.argument.id
                function onCurrentIndexChanged(){
                    urlLine.text=url
                }
            }
            Connections{
                target: global_key_handler
                enabled: argument.id===web_tabView.currentItem.argument.id
                function onF11Pressed(){
                    if(is_fullscreen){
                        window.useSystemAppBar=false;
                        web_tabView.anchors.topMargin=30;
                        window.showNormal();
                        is_fullscreen=false;
                    }
                    else{
                        window.useSystemAppBar=true;
                        web_tabView.anchors.topMargin=-35;
                        window.showFullScreen();
                        is_fullscreen=true;
                    }
                }
            }
            Component.onCompleted: {
                btn_back.enabled = canGoBack;
                btn_forward.enabled = canGoForward;
                btn_reload.iconSource=loading ? LingmoIcons.Cancel : LingmoIcons.Refresh ;
                btn_reload.text=loading ? qsTr('Cancel Reload') : qsTr('Reload');
            }
        }
    }
    LingmoMenu{
        id: more_menu
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
        visible: false
        width: link_popup_text.width+10
        height: link_popup_text.height+10
        color: LingmoTheme.dark ? Qt.rgba(50 / 255, 49 / 255, 48 / 255,1) : Qt.rgba(1, 1, 1, 1)
        radius: LingmoUnits.smallRadius
        anchors.bottom: parent.bottom
        LingmoText{
            id: link_popup_text
            anchors.centerIn: parent
        }
    }
    GlobalKeyHandler{
        id: global_key_handler
        objectName: "global_key_handler"
    }
}