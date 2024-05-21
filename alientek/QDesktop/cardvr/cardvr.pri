QT += gui core quick quickwidgets

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET_ARCH = $${QT_ARCH}
contains(TARGET_ARCH, arm) {
    LIBS +=  -latk_venc  -lsample_common_isp -leasymedia
}
SOURCES += \
    $$PWD/cardvrcamerathread.cpp \
    $$PWD/cardvritem.cpp

RESOURCES += \
    $$PWD/cardvr_icons.qrc \
    $$PWD/cardvr_qml.qrc

HEADERS += \
    $$PWD/cardvrcamerathread.h \
    $$PWD/cardvrcapturethread.h \
    $$PWD/cardvritem.h \
    $$PWD/covertomp4thread.h
