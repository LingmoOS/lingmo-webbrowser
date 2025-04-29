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
                    onClicked: {
                        popup_.close()
                    }
                }
            }
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
                ColumnLayout{
                    LingmoText{
                        text: popup_.historyKeys[index]
                        font: LingmoTextStyle.BodyStrong
                    }
                    ListView{
                        id: views
                        property string date: popup_.historyKeys[index]
                        Layout.preferredHeight: listView_model.count*30
                        model: ListModel{
                            id: listView_model
                        }
                        Layout.fillWidth: true
                        delegate: LingmoButton{ 
                            width: popup_.width-65
                            RowLayout{
                                // Image{
                                //     source: model.favicon
                                //     Layout.preferredWidth: 14
                                //     Layout.preferredHeight: 14
                                // }
                                LingmoText{
                                    Layout.preferredWidth: 200
                                    text: model.title
                                    elide: Qt.ElideRight
                                }
                                LingmoText{
                                    color: LingmoColor.Grey100
                                    text: model.time
                                }
                                LingmoIconButton{
                                    iconSource: LingmoIcons.Cancel
                                    onClicked: {
                                        HistoryData.delete(views.date,index);
                                        frame_delegate.flush();
                                    }
                                }
                            }
                        }
                        Component.onCompleted: {
                            flush();
                        }
                        Connections{
                            target: popup_
                            function onFlushRequested(){
                                flush();
                            }
                        }
                    }
                }
                function flush(){
                    listView_model.clear();
                    var p=HistoryData.getDateList(views.date);
                    for(var i=0;i<p.length;i++){
                        listView_model.append({title:p[i].title,time:p[i].time});
                    }
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