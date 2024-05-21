QT += gui core quick

CONFIG += c++11

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

SOURCES += \
    $$PWD/vdecplayeritem.cpp \
    $$PWD/vdecthread.cpp

RESOURCES += \
    $$PWD/vdecplayer_qml.qrc

TARGET_ARCH = $${QT_ARCH}
contains(TARGET_ARCH, arm) {
    LIBS +=  -latk_vdec  -lsample_common_isp -leasymedia
}

HEADERS += \
    $$PWD/playerthread.h \
    $$PWD/vdecplayeritem.h \
    $$PWD/vdecthread.h

