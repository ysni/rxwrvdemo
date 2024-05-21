QT += quick multimedia

CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        ../board/board.cpp \
        main.cpp

RESOURCES += \
    deskop_sounds.qrc \
    desktop_fonts.qrc \
    desktop_icons.qrc \
    desktop_images.qrc \
    desktop_qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

include(../music/music.pri)
include(../photoview/photoview.pri)
include(../fileview/fileview.pri)
include(../camera/camera.pri)
include(../settings/settings.pri)
include(../calculator/calculator.pri)
include(../notepad/notepad.pri)
include(../vdecplayer/vdecplayer.pri)
include(../cardvr/cardvr.pri)
include(../recorder/recorder.pri)
include(../live555/live555.pri)
include(../objectrecognition/objectrecognition.pri)
include(../facedetection/facedetection.pri)
include(../factorytest/factorytest.pri)

DISTFILES +=

HEADERS += \
    ../board/board.h
