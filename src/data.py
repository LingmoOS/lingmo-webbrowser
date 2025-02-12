from PySide6.QtGui import *
from PySide6.QtQml import *
from PySide6.QtQuick import *
from PySide6.QtCore import*
from PySide6.QtWebEngineQuick import *
import json

with open('../resources/data/settings.json','r',encoding='utf-8') as file:
    data=json.load(file)
def Data(i):
    return data[i]
def dumpData(property,val):
    data[property]=val
    with open('../resources/data/settings.json','w',encoding='utf-8') as file:
        json.dump(data,file,indent=4)

class SettingsData(QQuickItem):
    for i in data:
        exec(i+'''=Property(type(Data(\''''+i+'''\')),(lambda self: Data(\''''+i+'''\')),(lambda self,val: dumpData(\''''+i+'''\',val)))''')
    def __init__(self,parent=None):
        super().__init__(parent)
    

    