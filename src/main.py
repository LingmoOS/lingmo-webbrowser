import sys
from PySide6.QtGui import *
from PySide6.QtQml import *
from PySide6.QtQuick import *
from PySide6.QtWebEngineQuick import *
import updRes
import LingmoUIPy
import res

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    QtWebEngineQuick.initialize()
    engine = QQmlApplicationEngine()
    engine.load('qrc:qml/main.qml')
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
