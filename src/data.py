from PySide6.QtGui import *
from PySide6.QtQml import *
from PySide6.QtQuick import *
from PySide6.QtCore import *
from PySide6.QtWebEngineQuick import *
import json

data = {
    "../resources/data/settings.json": {},
    "../resources/data/downloadHistory.json": {},
}
for i in data:
    with open(i, "r", encoding="utf-8") as f:
        data[i] = json.load(f)


def Data(file, i):
    return data[file][i]


def dumpData(file, property, val):
    data[file][property] = val
    with open(file, "w", encoding="utf-8") as f:
        json.dump(data[file], f, indent=4)


class SettingsData(QQuickItem):
    for i in data["../resources/data/settings.json"]:
        exec(
            i
            + "Changed=Signal(type(Data('../resources/data/settings.json','"
            + i
            + "')))"
        )
        exec(
            i
            + "=Property(type(Data('../resources/data/settings.json','"
            + i
            + "')),(lambda self: Data('../resources/data/settings.json','"
            + i
            + "')),(lambda self,val: dumpData('../resources/data/settings.json','"
            + i
            + "',val)),notify="
            + i
            + "Changed)"
        )

    def __init__(self, parent=None):
        super().__init__(parent)


class DownloadHistoryData(QQuickItem):
    downloadHistory: list = Data("../resources/data/downloadHistory.json", "list")

    def __init__(self, parent=None):
        super().__init__(parent)

    @Slot(int, str, result=type)
    def get(self, index, prop):
        return self.downloadHistory[index][prop]

    @Slot(int, str, type)
    def set(self, index, prop, val):
        self.downloadHistory[index][prop] = val
        dumpData("../resources/data/downloadHistory.json", "list", self.downloadHistory)

    @Slot(str, str, str, str, bool, bool)
    def append(
        self, downloadDirectory, downloadFileName, mimeType, url, cancelled, deleted
    ):
        self.downloadHistory.append(
            {
                "downloadDirectory": downloadDirectory,
                "downloadFileName": downloadFileName,
                "mimeType": mimeType,
                "url": url,
                "cancelled": cancelled,
                "deleted": deleted,
            }
        )
        dumpData("../resources/data/downloadHistory.json", "list", self.downloadHistory)

    @Slot(int)
    def delete(self, index):
        self.downloadHistory.pop(index)
