from PySide6.QtGui import *
from PySide6.QtQml import *
from PySide6.QtQuick import *
from PySide6.QtCore import*
from PySide6.QtWebEngineQuick import *

class GlobalKeyHandler(QQuickItem):
    pressed=Signal(QKeyEvent)
    def __init__(self,parent=None):
        super().__init__(parent)
    def eventFilter(self, watched, event):
        if event.type()==QEvent.Type.KeyPress:
            print(1)
            self.pressed.emit(event)
            return True
        return False

    