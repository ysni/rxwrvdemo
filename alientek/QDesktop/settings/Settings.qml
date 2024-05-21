/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   settings
* @brief         Settings.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-09-30
*******************************************************************/
import QtQuick 2.12
import QtQuick.Window 2.12

import QtQuick.Controls 2.5

Item {
    id: app_settings
    y: app_settings.height
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
                target: app_settings
                opacity: showPropertyChangeOpacity
                x: showPropertyChangeX
                y: showPropertyChangeY
            }
            when: !show
        }
    ]


    transitions: Transition {
        NumberAnimation{properties: "x,y"; easing.type: Easing.InOutQuad; duration: 0}
        NumberAnimation{properties: "opacity"; easing.type: Easing.InOutQuad; duration: 0}
    }

    Rectangle {
        anchors.fill: parent
        color: "#eff2f7"
    }

    SwipeView {
        id: settings_swipeView
        visible: true
        anchors.fill: parent
        clip: true
        interactive: false
        MainPage { }
        MyDevice { }
        BrightnessVolume{ }
    }
}
