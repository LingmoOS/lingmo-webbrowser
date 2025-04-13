import sys
import os
from handlers import *
from data import SettingsData,DownloadHistoryData
import updRes
import LingmoUIPy
import res

if __name__ == "__main__":
    os.environ['QTWEBENGINE_REMOTE_DEBUGGING']="1112"
    scheme=QWebEngineUrlScheme(QByteArray('browser'))
    scheme.setSyntax(QWebEngineUrlScheme.Syntax.HostAndPort)
    scheme.setDefaultPort(2345)
    scheme.setFlags(QWebEngineUrlScheme.Flag.SecureScheme)
    QWebEngineUrlScheme.registerScheme(scheme)
    app = QGuiApplication(sys.argv)
    qmlRegisterSingletonType(SettingsData,'org.lingmo.webbrowser',1,0,'SettingsData')
    qmlRegisterSingletonType(FileIconProvidingHandler,'org.lingmo.webbrowser',1,0,'FileIconProvidingHandler')
    qmlRegisterSingletonType(FileManagerHandler,'org.lingmo.webbrowser',1,0,'FileManagerHandler')
    qmlRegisterSingletonType(UrlRedirectHandler,'org.lingmo.webbrowser',1,0,'UrlRedirectHandler')
    qmlRegisterSingletonType(DownloadHistoryData,'org.lingmo.webbrowser',1,0,'DownloadHistoryData')
    QtWebEngineQuick.initialize()
    handler=UrlSchemeHandler()
    QQuickWebEngineProfile.defaultProfile().installUrlSchemeHandler(QByteArray('browser'),handler)
    engine = QQmlApplicationEngine()
    engine.addImportPath(os.getcwd()+'/../resources/qml')
    engine.load('qrc:/qml/main.qml')
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
