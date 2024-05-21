SOURCES += \
    $$PWD/objectrecognitioncamerathread.cpp \
    $$PWD/objectrecognitionitem.cpp

RESOURCES += \
    $$PWD/objectrecognition_icons.qrc \
    $$PWD/objectrecognition_qml.qrc

TARGET_ARCH = $${QT_ARCH}
contains(TARGET_ARCH, arm) {
    LIBS +=  -latk_ssd_object_recognition  -lsample_common_isp -leasymedia
}

HEADERS += \
    $$PWD/objectrecognitioncamerathread.h \
    $$PWD/objectrecognitioncapturethread.h \
    $$PWD/objectrecognitionitem.h
