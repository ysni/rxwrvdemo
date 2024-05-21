QT += core widgets

SOURCES += \
        $$PWD/recordListModel.cpp \
        $$PWD/recordcontrol.cpp

RESOURCES += \
    $$PWD/recorder_icons.qrc \
    $$PWD/recorder_qml.qrc

TARGET_ARCH = $${QT_ARCH}
contains(TARGET_ARCH, arm) {
    LIBS +=  -latk_ai -leasymedia
}

HEADERS += \
    $$PWD/aithread.h \
    $$PWD/covertomp3thread.h \
    $$PWD/recordListModel.h \
    $$PWD/recordcontrol.h
