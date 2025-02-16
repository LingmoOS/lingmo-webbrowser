from PySide6.QtGui import *
from PySide6.QtQml import *
from PySide6.QtQuick import *
from PySide6.QtCore import*
from PySide6.QtWebEngineQuick import *
from PySide6.QtWebEngineCore import *
from PySide6.QtNetwork import *

class FileIconProvidingHandler(QQuickItem):
    def __init__(self):
        super().__init__()
        self.fileIconHandler=QAbstractFileIconProvider()
    @Slot(str,result=QUrl)
    def icon(self,path):
        fileInfo=QFileInfo(path)
        icon=self.fileIconHandler.icon(fileInfo)
        image=icon.pixmap(128,128).toImage()
        buffer = QBuffer()
        buffer.open(QBuffer.OpenModeFlag.WriteOnly)
        image.save(buffer,'PNG')
        base64String=buffer.data().toBase64()
        url=QUrl('data:image/png;base64,'+base64String)
        return url