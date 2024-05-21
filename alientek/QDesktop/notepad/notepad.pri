QT += virtualkeyboard core widgets

SOURCES += \
        $$PWD/filereadwrite.cpp \
        $$PWD/notepadListModel.cpp

RESOURCES += \
    $$PWD/greywhite/virtualkeyboard_custom_style.qrc \
    $$PWD/notepad_icons.qrc \
    $$PWD/notepad_qml.qrc


HEADERS += \
    $$PWD/filereadwrite.h \
    $$PWD/notepadListModel.h
