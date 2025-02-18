from PySide6.QtGui import *
from PySide6.QtQml import *
from PySide6.QtQuick import *
from PySide6.QtCore import*
from PySide6.QtWebEngineQuick import *
from PySide6.QtWebEngineCore import *
from PySide6.QtNetwork import *
import os

class FileIconProvidingHandler(QQuickItem):
    def __init__(self):
        super().__init__()
        self.fileIconHandler=QAbstractFileIconProvider()
    @Slot(str,result=QUrl)
    def icon(self,path):
        fileInfo=QFileInfo(path)
        icon=self.fileIconHandler.icon(fileInfo)
        image=icon.pixmap(32,32).toImage()
        buffer = QBuffer()
        buffer.open(QBuffer.OpenModeFlag.WriteOnly)
        image.save(buffer,'PNG')
        base64String=buffer.data().toBase64()
        url=QUrl('data:image/png;base64,'+base64String)
        return url


class FileManagerHandler(QQuickItem):
    def __init__(self):
        super().__init__()
    @Slot(str)
    def open(self,path):
        QDesktopServices.openUrl(QUrl.fromLocalFile(path))
    @Slot(str)
    def delete(self,path):
        os.remove(path)