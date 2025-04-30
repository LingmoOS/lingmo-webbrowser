import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQml
import QtCore
import QtWebEngine
import LingmoUI
import org.lingmo.webbrowser

LingmoPopup{
    id: popup_
    width: 350
    height: 400
    modal: false
    closePolicy: pinned ? LingmoPopup.CloseOnEscape : LingmoPopup.CloseOnEscape|LingmoPopup.CloseOnPressOutside
    property bool pinned: false
    property LingmoWindow parentWindow
    property var historyKeys: {return HistoryData.getDates()}
    signal flushRequested
    ColumnLayout{
        id: content_layout
        anchors.fill: parent
        anchors.margins: 15
        RowLayout{
            spacing: content_layout.width-heading.width-buttons_row_layout.width
            Layout.fillWidth: true
            LingmoText{
                id: heading
                text: qsTr("History")
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                font: LingmoTextStyle.Subtitle
            }
            RowLayout{
                id: buttons_row_layout
                spacing: 10
                Layout.fillWidth: true
                LingmoIconButton{
                    iconSource: LingmoIcons.More
                    Layout.alignment: Qt.AlignVCenter
                    onClicked: {
                        menu.open();
                    }
                }
                LingmoIconButton{
                    iconSource: popup_.pinned ? LingmoIcons.PinnedFill : LingmoIcons.Pin
                    Layout.alignment: Qt.AlignVCenter
                    onClicked: {
                        popup_.pinned = !popup_.pinned
                    }
                }
                LingmoIconButton{
                    iconSource: LingmoIcons.Cancel
                    Layout.alignment: Qt.AlignVCenter
                    visible: !popup_.pinned
                    onClicked: {
                        popup_.close()
                    }
                }
            }
        }
        LingmoTextBox{
            id: text_box
            placeholderText: qsTr("Search...")
            Layout.fillWidth: true
        }
        ListView{
            id: history_view
            model: popup_.historyKeys
            spacing: 5
            Layout.fillWidth: true
            Layout.fillHeight: true
            ScrollBar.vertical: LingmoScrollBar{}
            clip: true
            delegate: LingmoFrame{
                id: frame_delegate
                padding: 10
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: 15
                visible: views.searchCount()!==0
                ColumnLayout{
                    LingmoText{
                        text: popup_.historyKeys[index]
                        font: LingmoTextStyle.BodyStrong
                    }
                    ListView{
                        id: views
                        property string date: popup_.historyKeys[index]
                        Layout.preferredHeight: searchCount()*30
                        model: ListModel{
                            id: listView_model
                        }
                        Layout.fillWidth: true
                        delegate: LingmoButton{ 
                            id: itemBtn
                            width: popup_.width-65
                            visible: model.title.includes(text_box.text)
                            RowLayout{
                                x: (itemBtn.width-width)/2
                                y: (itemBtn.height-height)/2
                                Image{
                                    source: model.favicon
                                    Layout.preferredWidth: 20
                                    Layout.preferredHeight: 20
                                }
                                LingmoText{
                                    Layout.preferredWidth: 180
                                    text: model.title
                                    elide: Qt.ElideRight
                                }
                                LingmoText{
                                    Layout.preferredWidth: 30
                                    color: LingmoColor.Grey100
                                    text: model.time
                                }
                                LingmoIconButton{
                                    iconSource: LingmoIcons.Cancel
                                    Layout.preferredWidth: 25
                                    Layout.preferredHeight: 25
                                    padding: 0
                                    verticalPadding: 0
                                    horizontalPadding: 0
                                    iconSize: 15
                                    onClicked: {
                                        HistoryData.delete(views.date,index);
                                        popup_.flushRequested();
                                    }
                                }
                            }
                        }
                        function searchCount(){
                            var count=0;
                            for(var i=0;i<listView_model.count;i++){
                                count+=(listView_model.get(i).title.includes(text_box.text)?1:0);
                            }
                            return count;
                        }
                    }
                }
                Component.onCompleted: {
                    popup_.flushRequested();
                }
                Connections{
                    target: popup_
                    function onFlushRequested(){
                        flush();
                    }
                }
                function flush(){
                    listView_model.clear();
                    var p=HistoryData.getDateList(views.date);
                    for(var i=0;i<p.length;i++){
                        listView_model.append({favicon:p[i].favicon,title:p[i].title,time:p[i].time});
                    }
                }
            }
            Connections{
                target: popup_
                function onFlushRequested(){
                    popup_.historyKeys=HistoryData.getDates();
                }
            }
        }
    }
    LingmoMenu{
        id: menu
        LingmoMenuItem{
            iconSource: LingmoIcons.NewWindow
            text: "Open History Page"
            onClicked: {
                popup_.close();
                parentWindow.newTab("browser://history/")
            }
        }
    }
}