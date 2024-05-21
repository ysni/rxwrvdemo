QT += quick network widgets

CONFIG += c++11

SOURCES += \
        $$PWD/myjsonparse.cpp \
        $$PWD/mymodel.cpp \
        $$PWD/weatherdata.cpp

RESOURCES += \
    $$PWD/weather_images.qrc \
    $$PWD/weather_qml.qrc

HEADERS += \
    $$PWD/myjsonparse.h \
    $$PWD/mymodel.h \
    $$PWD/weatherdata.h
