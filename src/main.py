import sys
import os
from components import *
import updRes
import LingmoUIPy
import res

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    qmlRegisterType(GlobalKeyHandler,'org.lingmo.webbrowser',1,0,'GlobalKeyHandler')
    QtWebEngineQuick.initialize()
    engine = QQmlApplicationEngine()
    engine.addImportPath(os.getcwd()+'/../resources/qml')
    engine.load('qrc:/qml/main.qml')
    if not engine.rootObjects():
        sys.exit(-1)
    mainRootObject=engine.rootObjects()[0].children()[0]
    globalKeyHandler=mainRootObject.findChild(QObject,"global_key_handler")
    mainRootObject.installEventFilter(globalKeyHandler)
    sys.exit(app.exec())
