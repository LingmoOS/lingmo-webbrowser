from PySide6.QtGui import *
from PySide6.QtQml import *
from PySide6.QtQuick import *
from PySide6.QtCore import *
from PySide6.QtWebEngineQuick import *
from PySide6.QtWebEngineCore import *
from PySide6.QtNetwork import *
import os
import re


def is_valid_url(url):
    pattern = re.compile(
        r"^(?:http|ftp)s?://"
        r"(?:(?:[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?\.)+(?:[A-Z]{2,6}\.?|[A-Z0-9-]{2,}\.?)|"
        r"localhost|"
        r"\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})"
        r"(?::\d+)?"
        r"(?:/?|[/?]\S+)$",
        re.IGNORECASE,
    )
    return re.match(pattern, url) is not None


def is_valid_localfile_url(url):
    pattern = re.compile(
        r'^((?:file):///)?(?:(?:[a-zA-Z]:|\.{1,2})?[\\/](?:[^\\?/*|<>:"]+[\\/])*)(?:(?:[^\\?/*|<>:"]+?)(?:\.[^.\\?/*|<>:"]+)?)?$'
    )
    return re.match(pattern, url) is not None


def is_valid_browser_url(url):
    pattern = re.compile(
        r'^((?:browser):/)?(?:(?:[a-zA-Z]:|\.{1,2})?[\\/](?:[^\\?/*|<>:"]+[\\/])*)(?:(?:[^\\?/*|<>:"]+?)(?:\.[^.\\?/*|<>:"]+)?)?$'
    )
    return re.match(pattern, url) is not None


class FileIconProvidingHandler(QQuickItem):
    def __init__(self):
        super().__init__()
        self.fileIconHandler = QAbstractFileIconProvider()

    @Slot(str, result=QUrl)
    def icon(self, path):
        fileInfo = QFileInfo(path)
        icon = self.fileIconHandler.icon(fileInfo)
        image = icon.pixmap(32, 32).toImage()
        buffer = QBuffer()
        buffer.open(QBuffer.OpenModeFlag.WriteOnly)
        image.save(buffer, "PNG")
        base64String = buffer.data().toBase64()
        url = QUrl("data:image/png;base64," + base64String)
        return url


class FileManagerHandler(QQuickItem):
    def __init__(self):
        super().__init__()

    @Slot(str)
    def open(self, path):
        QDesktopServices.openUrl(QUrl.fromLocalFile(path))

    @Slot(str)
    def delete(self, path):
        os.remove(path)


class EventFilter(QObject, QAbstractNativeEventFilter):
    ctrlWheelEvent = Signal()

    def __init__(self):
        super().__init__()

    def eventFilter(self, watched, event):
        if event.type() == QEvent.Type.Wheel:
            wheelEvent = QWheelEvent(event)
            if wheelEvent.modifiers() & Qt.KeyboardModifier.ControlModifier:
                self.ctrlWheelEvent.emit()
                return True
        return super().eventFilter(watched, event)


class UrlRedirectHandler(QQuickItem):
    def __init__(self):
        super().__init__()

    @Slot(str, result=str)
    def redirect(self, url):
        if is_valid_url(url):
            return url
        if is_valid_browser_url(url):
            return url
        elif is_valid_url("http://" + url):
            return "http://" + url
        elif is_valid_localfile_url(url):
            return url
        else:
            return "https://cn.bing.com/search?form=bing&q=" + url


class WebCookiesHandler(QQuickItem):
    def __init__(self):
        super().__init__()


class UrlSchemeHandler(QWebEngineUrlSchemeHandler):
    def __init__(self):
        super().__init__()

    def requestStarted(self, job: QWebEngineUrlRequestJob):
        job.fail(QWebEngineUrlRequestJob.Error.RequestFailed)


class ClipboardHandler(QQuickItem):
    def __init__(self):
        super().__init__()
        self.clipboard=QClipboard()
    @Slot(str)
    def write(self,content):
        self.clipboard.setText(content)
