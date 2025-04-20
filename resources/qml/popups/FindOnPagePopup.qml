import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQml
import QtCore
import QtWebEngine
import LingmoUI

LingmoPopup{
    id: popup
    width: 400
    height: 50
    modal: false
    closePolicy: LingmoPopup.CloseOnEscape
    property bool is_opened: false
    property WebEngineView parentView
    property bool case_sensitive: false
    RowLayout{
        spacing: 10
        anchors.leftMargin: 10
        anchors.fill: parent
        LingmoTextBox{
            id: text_box
            Layout.fillWidth: true
            onTextChanged: {
                if(popup.case_sensitive){
                    popup.parentView.findText(text,WebEngineView.FindCaseSensitively)
                }
                else{
                    popup.parentView.findText(text)
                }
            }
            Connections{
                target: popup.parentView
                function onFindTextFinished(result){
                    text_information.text=result.activeMatch.toString()+"/"+result.numberOfMatches.toString();
                }
            }
        }
        LingmoText{
            id: text_information
            text: "0/0"
        }
        LingmoIconButton{
            iconSource: popup.case_sensitive ? LingmoIcons.FullAlpha : LingmoIcons.HalfAlpha
            Layout.alignment: Qt.AlignVCenter
            text: popup.case_sensitive ? qsTr("Cancel Find Case Sensitively") : qsTr("Find Case Sensitively")
            onClicked: {
                popup.case_sensitive = !popup.case_sensitive;
                if(popup.case_sensitive){
                    popup.parentView.findText(text,WebEngineView.FindCaseSensitively)
                }
                else{
                    popup.parentView.findText(text)
                }
            }
        }
        LingmoIconButton{
            iconSource: LingmoIcons.Cancel
            text: qsTr("Close")
            Layout.alignment: Qt.AlignVCenter
            onClicked: {
                popup.close()
                popup.is_opened=false;
                popup.parentView.findText("")
            }
        }
    }
}