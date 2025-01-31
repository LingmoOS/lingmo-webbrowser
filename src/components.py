from PySide6.QtGui import *
from PySide6.QtQml import *
from PySide6.QtQuick import *

QML_IMPORT_NAME='Components'
QML_IMPORT_MAJOR_VERSION=1

@QmlElement
class TabWidget(QQuickItem):
    def __init__(self):
        super().__init__()
    