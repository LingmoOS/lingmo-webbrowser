import QtQuick
import QtQuick.Layouts
import QtWebEngine
import LingmoUI
import QtQuick.Controls.LingmoStyle

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
    property string home_url: 'https://lingmo.org'
    Row{
        id: tabRow
        height: 40
        TabBar{
            id: tabBar
            anchors.left: parent.left
            height: 40
            contentHeight: 30
            background: Rectangle{
                color: 'transparent'
            }
            spacing:5
            padding:5
            TabButton{
                id: tabButton
                implicitWidth: 200
                width: implicitWidth
                background: Rectangle{
                    color: LingmoTheme.dark ? Qt.rgba(0,0,0,1) : Qt.rgba(1,1,1,1) 
                    radius: LingmoUnits.smallRadius
                }
                LingmoText{
                    text:'111'
                    color: window.textColor
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
        LingmoIconButton {
            id: btn_add
            width: 40
            height: 30
            anchors.left: tabBar.right
            padding: 0
            verticalPadding: 0
            horizontalPadding: 0
            rightPadding: 2
            iconSource: LingmoIcons.Add
            anchors.verticalCenter: parent.verticalCenter
            iconSize: 15
            text: qsTr('Add New Tab')
            radius: LingmoUnits.windowRadius
            iconColor: window.textColor
            onClicked: {
                tabBar.addItem(tabButton)
            }
        }
        
    }
    Rectangle{
        id: toolArea
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: tabRow.bottom
        height: 30
        color: "transparent"
        RowLayout {
            id: contorlButtons
            height: parent.height
            spacing: 0
            LingmoIconButton {
                id: btn_back
                enabled: webView.canGoBack
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
                    webView.goBack()
                }
            }
            LingmoIconButton {
                id: btn_forward
                enabled: webView.canGoForward
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
                    webView.goForward()
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
                iconSource: webView.loading ? LingmoIcons.Cancel : LingmoIcons.Refresh 
                Layout.alignment: Qt.AlignVCenter
                iconSize: 15
                text: webView.loading ? qsTr('Cancel Reload') : qsTr('Reload')
                radius: LingmoUnits.windowRadius
                iconColor: window.textColor
                onClicked: {
                    if(webView.loading){
                        webView.stop();
                    }
                    else{
                        webView.reload();
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
                    webView.url= window.home_url
                }
            }
        }
        LingmoTextBox{
            id: urlLine
            text: webView.url
            anchors.left: contorlButtons.right
            anchors.right: btn_more.left
            cleanEnabled: false
            height: parent.height
            onCommit: {
                webView.url=urlLine.text
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
            anchors.right:parent.right
        }
    }
    StackLayout{
        currentIndex: tabBar.currentIndex
        anchors.top: toolArea.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        WebEngineView{
            id: webView
            url: window.home_url
            onUrlChanged: {
                urlLine.text = url
            }
        }
    }
}