import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtWebEngine
import LingmoUI
import org.lingmo.webbrowser

LingmoObject {
    id: root
    Component.onCompleted: {
        LingmoApp.init(root, Qt.locale("zh_CN"));
        LingmoTheme.animationEnabled = true;
        LingmoTheme.blurBehindWindowEnabled = true;
        LingmoTheme.darkMode = LingmoThemeType.Dark;
    }
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
                id: contorlButtons
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
                anchors.left: contorlButtons.right 
                anchors.right: btn_more.left
                cleanEnabled: false
                height: parent.height
            }
            LingmoIconButton {
                id: btn_more
                width: 40
                height: 30
                padding: 0
                verticalPadding: 0
                horizontalPadding: 0
                rightPadding: 2
                iconSource: LingmoIcons.More
                Layout.alignment: Qt.AlignVCenter
                iconSize: 15
                text: qsTr('More')
                radius: LingmoUnits.windowRadius
                anchors.right: parent.right
                onClicked: {
                    more_menu.open()
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
                onUrlChanged: {
                    urlLine.text = url
                }
                onNewWindowRequested: function(request) {
                    window.newTab(request.requestedUrl)
                }
                onTitleChanged:{
                    web_tabView.setCurrentText(title);
                }
                onIconChanged:{
                    var str=icon.toString()
                    web_tabView.setCurrentTabIcon(str.replace("image://favicon/",""));
                }
                onWindowCloseRequested: {
                    web_tabView.closeTab(web_tabView.currentIndex);
                }
                onLoadingChanged: {
                    btn_reload.iconSource=loading ? LingmoIcons.Cancel : LingmoIcons.Refresh 
                    btn_reload.text=loading ? qsTr('Cancel Reload') : qsTr('Reload')
                }
                onCanGoBackChanged: {
                    btn_back.enabled = canGoBack
                }
                onCanGoForwardChanged: {
                    btn_forward.enabled = canGoForward
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
                onContextMenuRequested: {
                    context_menu.open();
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
            LingmoMenuItem{
                text: '1'
            }
            LingmoMenuItem{
                text: '1'
            }
        }
        GlobalKeyHandler{
            id: global_key_handler
            objectName: "global_key_handler"
        }
    }
}
