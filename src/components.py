from PySide6.QtGui import *
from PySide6.QtQml import *
from PySide6.QtQuick import *
from PySide6.QtCore import*
from PySide6.QtWebEngineQuick import *
import json

class GlobalKeyHandler(QQuickItem):
    f11Pressed=Signal()
    def __init__(self,parent=None):
        super().__init__(parent)
    def eventFilter(self, watched, event: QKeyEvent):
        if event.type()==QEvent.Type.KeyPress:
            if event.key()==Qt.Key.Key_F11:
                self.f11Pressed.emit()
                return True
        return False


class JsonHandler(QQuickItem):
    sourceFilePathChanged=Signal(str)
    def __init__(self,parent=None):
        super().__init__(parent)
        self.sourceFilePath=Property(str,'sourceFilePath',notify=self.sourceFilePathChanged)
        self.data=Property(QJSValue,'data',notify=False)
        self.sourceFilePathChanged.connect()
    def load(self):
        with open(self.sourceFilePath,'r',encoding='utf-8') as file:
            self.data=QJSValue()
    def dump(self):
        with open(self.sourceFilePath,'w',encoding='utf-8') as file:
            json.dump(self.data,file)

