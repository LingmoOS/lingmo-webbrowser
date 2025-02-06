from PySide6.QtGui import *
from PySide6.QtQml import *
from PySide6.QtQuick import *
from PySide6.QtCore import*
from PySide6.QtWebEngineQuick import *

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

    