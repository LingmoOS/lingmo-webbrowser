import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtWebEngine
import LingmoUI

LingmoWindow{
    id: window
    visible: true
    width: 1000
    height: 600
    showDark: true
    property color textColor: appBar.textColor
    property string config: {
        var request = new XMLHttpRequest();
        request.open("GET", 'file://../../conf/main.conf', false); 
        request.send(null);
        return request.responseText;
    }
    property string home_url: 'https://baidu.com'
    function newTab(url= window.home_url){
        stack_webView.appendTab(undefined,qsTr("New Tab"),com_webWiew,{"url": url});
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
                enabled: stack_webView.currentItem.canGoBack
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
                iconColor: window.textColor
                onClicked: {
                    stack_webView.currentItem.goBack()
                }
            }
            LingmoIconButton {
                id: btn_forward
                enabled: stack_webView.currentItem.canGoForward
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
                iconColor: window.textColor
                onClicked: {
                    stack_webView.currentItem.goForward()
                }
            }
            LingmoIconButton {
                id: btn_reload
                Layout.preferredWidth: 40
                Layout.preferredHeight: 30
                padding: 0
                verticalPadding: 0
                horizontalPadding: 0
                rightPadding: 2
                iconSource: stack_webView.currentItem.loading ? LingmoIcons.Cancel : LingmoIcons.Refresh 
                Layout.alignment: Qt.AlignVCenter
                iconSize: 15
                text: stack_webView.currentItem.loading ? qsTr('Cancel Reload') : qsTr('Reload')
                radius: LingmoUnits.windowRadius
                iconColor: window.textColor
                onClicked: {
                    if(stack_webView.currentItem.loading){
                        stack_webView.currentItem.stop();
                    }
                    else{
                        stack_webView.currentItem.reload();
                    }
                }
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
                iconColor: window.textColor
                onClicked: {
                    stack_webView.currentItem.url= window.home_url
                }
            }
        }
        LingmoTextBox{
            id: urlLine
            text: stack_webView.currentItem.url
            anchors.left: contorlButtons.right
            anchors.right: btn_more.left
            cleanEnabled: false
            height: parent.height
            onCommit: {
                stack_webView.currentItem.url=urlLine.text
            }
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
            iconColor: window.textColor
            anchors.right: parent.right
        }
    }
    LingmoTabView{
        id: stack_webView
        anchors.topMargin: 30
        onNewPressed: {
            window.newTab()
        }
    }
    Component{
        id: com_webWiew
        WebEngineView{
            id: web_web_view
            url: window.home_url
            onUrlChanged: {
                urlLine.text = url
            }
            onNewWindowRequested: {
                newView=window.newTab()
                request.openIn(web_web_view)
            }
        }
    }
}