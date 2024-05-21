/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   weather
* @brief         Weather.qml
* @author        Deng Zhimao
* @email         1252699831@qq.com
* @date          2020-07-31
*******************************************************************/
import QtQuick 2.7
import QtQuick.Controls 2.2
import QtCharts 2.2
import weatherModel 1.0
import an.weather 1.0

Item {
    id: app_weather

    property bool dayOrNight: false
    y: app_weather.height
    x: 0
    opacity: 0
    property real showPropertyChangeOpacity: 1
    property real showPropertyChangeX: 0
    property real showPropertyChangeY: 0
    property bool show: false

    state: ""
    states:[
        State {
            name: "show"
            PropertyChanges {
                target: app_weather
                opacity: showPropertyChangeOpacity
                x: showPropertyChangeX
                y: showPropertyChangeY
            }
            when: !show
        }
    ]


    transitions: Transition {
        NumberAnimation{properties: "x,y"; easing.type: Easing.InOutQuad; duration: 500}
        NumberAnimation{properties: "opacity"; easing.type: Easing.InOutQuad; duration: 500}
    }

    Rectangle {
        anchors.fill: parent
        visible: !dayOrNight
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#0b4c8c" }
            GradientStop { position: 0.2; color: "#0b4c8c" }
            GradientStop { position: 0.5; color: "#4580bb" }
            GradientStop { position: 0.8; color: "#6ea1d3" }
            GradientStop { position: 1.0; color: "#6ea1d3" }
        }
    }

    Rectangle {
        anchors.fill: parent
        visible: dayOrNight
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#0b4c8c" }
            GradientStop { position: 0.2; color: "#0b4c8c" }
            GradientStop { position: 0.5; color: "#444444" }
            GradientStop { position: 0.8; color: "#444444" }
            GradientStop { position: 1.0; color: "#000000" }
        }
    }

    WeatherModel {
        id: weatherModel
        onDayOrNightChanged: {
            dayOrNight = dayFlag
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        SwipeView {
            id: weatherSwipeView
            interactive: true
            anchors.fill: parent
            WeatherPage1 {}
            WeatherPage2 {}
        }
    }
}
