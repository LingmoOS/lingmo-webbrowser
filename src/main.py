import sys
import os
from handlers import *
from data import SettingsData
import updRes
import LingmoUIPy
import res

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    qmlRegisterType(SettingsData,'org.lingmo.webbrowser',1,0,'SettingsData')
    QtWebEngineQuick.initialize()
    engine = QQmlApplicationEngine()
    engine.addImportPath(os.getcwd()+'/../resources/qml')
    engine.load('qrc:/qml/main.qml')
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
