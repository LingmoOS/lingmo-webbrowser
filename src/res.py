# Resource object code (Python 3)
# Created by: object code
# Created by: The Resource Compiler for Qt version 6.7.3
# WARNING! All changes made in this file will be lost!

from PySide6 import QtCore

qt_resource_data = b"\
\x00\x00\x03\xc6\
i\
mport QtQuick\x0d\x0ai\
mport QtQuick.Co\
ntrols\x0d\x0aimport Q\
tQuick.Layouts\x0d\x0a\
import QtQuick.D\
ialogs\x0d\x0aimport Q\
tWebEngine\x0d\x0aimpo\
rt LingmoUI\x0d\x0aimp\
ort org.lingmo.w\
ebbrowser\x0d\x0aimpor\
t global\x0d\x0a\x0d\x0aLing\
moObject {\x0d\x0a    \
id: root\x0d\x0a    Co\
mponent.onComple\
ted: {\x0d\x0a        \
LingmoApp.init(r\
oot, Qt.locale(\x22\
zh_CN\x22));\x0d\x0a     \
   LingmoTheme.a\
nimationEnabled \
= true;\x0d\x0a       \
 LingmoTheme.blu\
rBehindWindowEna\
bled = true;\x0d\x0a  \
      LingmoThem\
e.darkMode = Lin\
gmoThemeType.Dar\
k;\x0d\x0a    }\x0d\x0a    L\
ingmoWebWindow{\x0d\
\x0a        fileDia\
log: file_dialog\
\x0d\x0a        folder\
Dialog: folder_d\
ialog\x0d\x0a        c\
olorDialog: colo\
r_dialog\x0d\x0a      \
  // jsonHandler\
: json_handler\x0d\x0a\
    }\x0d\x0a    FileD\
ialog{\x0d\x0a        \
id: file_dialog\x0d\
\x0a        visible\
: false\x0d\x0a    }\x0d\x0a\
    FolderDialog\
{\x0d\x0a        id: f\
older_dialog\x0d\x0a  \
      visible: f\
alse\x0d\x0a    }\x0d\x0a   \
 ColorDialog{\x0d\x0a \
       id: color\
_dialog\x0d\x0a       \
 visible: false\x0d\
\x0a    }\x0d\x0a    // J\
sonHandler{\x0d\x0a   \
 //     id: json\
_handler\x0d\x0a    //\
     sourceFileP\
ath: \x22../resourc\
es/data/settings\
.json\x22\x0d\x0a    // }\
\x0d\x0a}\x0d\x0a\
"

qt_resource_name = b"\
\x00\x03\
\x00\x00x<\
\x00q\
\x00m\x00l\
\x00\x08\
\x08\x01Z\x5c\
\x00m\
\x00a\x00i\x00n\x00.\x00q\x00m\x00l\
"

qt_resource_struct = b"\
\x00\x00\x00\x00\x00\x02\x00\x00\x00\x01\x00\x00\x00\x01\
\x00\x00\x00\x00\x00\x00\x00\x00\
\x00\x00\x00\x00\x00\x02\x00\x00\x00\x01\x00\x00\x00\x02\
\x00\x00\x00\x00\x00\x00\x00\x00\
\x00\x00\x00\x0c\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\
\x00\x00\x01\x94\xe9\xd8\xb2\x04\
"

def qInitResources():
    QtCore.qRegisterResourceData(0x03, qt_resource_struct, qt_resource_name, qt_resource_data)

def qCleanupResources():
    QtCore.qUnregisterResourceData(0x03, qt_resource_struct, qt_resource_name, qt_resource_data)

qInitResources()
