import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import LingmoUI

Item {
    implicitWidth: 230

    property int itemRadiusV: 8
    property string title: ''

    property alias view: listView
    property alias model: listModel
    property alias currentIndex: listView.currentIndex

    Rectangle {
        anchors.fill: parent
        color: LingmoTheme.darkMode ? Qt.lighter(LingmoTheme.backgroundColor, 1.5) : Qt.darker(LingmoTheme.backgroundColor, 1.05)
        opacity: Window.window.compositing ? 0.3 : 0.4
        Behavior on color {
            ColorAnimation {
                duration: 250
                easing.type: Easing.Linear
            }
        }
    }

    ListModel {
        id: listModel
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 0
        spacing: 0

        Label {
            text: title
            color: Window.window.active ? LingmoTheme.fontPrimaryColor : LingmoTheme.fontTertiaryColor
            Layout.preferredHeight: 60
            leftPadding: LingmoUnits.largeSpacing + LingmoUnits.smallSpacing
            rightPadding: LingmoUnits.largeSpacing + LingmoUnits.smallSpacing
            topPadding: LingmoUnits.smallSpacing
            bottomPadding: 0
            font.pointSize: 30
        }

        ListView {
            id: listView
            Layout.fillHeight: true
            Layout.fillWidth: true
            clip: true
            model: listModel

            spacing: LingmoUnits.smallSpacing
            leftMargin: LingmoUnits.largeSpacing
            rightMargin: LingmoUnits.largeSpacing
            topMargin: 0
            bottomMargin: LingmoUnits.largeSpacing

            ScrollBar.vertical: ScrollBar {}

            highlightFollowsCurrentItem: true
            highlightMoveDuration: 0
            highlightResizeDuration : 0
            highlight: Rectangle {
                radius: LingmoUnits.mediumRadius
                color: LingmoTheme.primaryColor
                smooth: true
            }

            delegate: Item {
                id: item
                width: ListView.view.width - ListView.view.leftMargin - ListView.view.rightMargin
                height: LingmoUnits.fontMetrics.height + LingmoUnits.largeSpacing * 1.5

                property bool isCurrent: listView.currentIndex === index

                Rectangle {
                    anchors.fill: parent

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton
                        onClicked: listView.currentIndex = index
                    }

                    radius: LingmoUnits.mediumRadius
                    color: mouseArea.containsMouse && !isCurrent ? Qt.rgba(LingmoTheme.fontPrimaryColor.r,
                                                                           LingmoTheme.fontPrimaryColor.g,
                                                                           LingmoTheme.fontPrimaryColor.b,
                                                                   0.1) : "transparent"

                    smooth: true
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: LingmoUnits.largeSpacing
                    spacing: LingmoUnits.smallSpacing * 1.5

                    Rectangle {
                        id: iconRect
                        width: 24
                        height: 24
                        Layout.alignment: Qt.AlignVCenter
                        radius: 20
                        color: LingmoTheme.primaryColor

                        Image {
                            id: icon
                            anchors.centerIn: parent
                            width: 16
                            height: width
                            source: "qrc:/images/" + model.iconSource
                            sourceSize: Qt.size(width, height)
                            Layout.alignment: Qt.AlignVCenter
                            antialiasing: false
                            smooth: false
                        }
                    }

                    Label {
                        id: itemTitle
                        text: model.title
                        color: isCurrent ? LingmoTheme.fontPrimaryColor : LingmoTheme.fontPrimaryColor
                    }

                    Item {
                        Layout.fillWidth: true
                    }
                }
            }

        }
    }

    function removeItem(name) {
        for (var i = 0; i < listModel.count; ++i) {
            if (name === listModel.get(i).name) {
                listModel.remove(i)
                break
            }
        }
    }
}
