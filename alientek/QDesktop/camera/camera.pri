QT += gui core quick quickwidgets

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET_ARCH = $${QT_ARCH}
contains(TARGET_ARCH, arm) {
    LIBS +=  -latk_camera  -lsample_common_isp -leasymedia
}

SOURCES += \
    $$PWD/cameraitem.cpp \
    $$PWD/camerathread.cpp

RESOURCES += \
    $$PWD/camera_icons.qrc \
    $$PWD/camera_qml.qrc

HEADERS += \
    $$PWD/cameraitem.h \
    $$PWD/camerathread.h \
    $$PWD/capturethread.h \
    $$PWD/photothread.h
