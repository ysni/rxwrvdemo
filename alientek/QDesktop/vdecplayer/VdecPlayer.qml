/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   desktop
* @brief         VdecPlayer.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2022-10-11
*******************************************************************/

import QtQuick 2.12
import QtQuick.Controls 2.5

import vdecplayer 1.0

Item {
    id: app_vdecPlayer
    y: app_vdecPlayer.height
    x: 0
    opacity: 0
    property real showPropertyChangeOpacity: 1
    property real showPropertyChangeX: 0
    property real showPropertyChangeY: 0
    property bool show: false

    Rectangle {
        id: playerBackground
        anchors.fill: parent
        color: "black"
    }
    VdecPlayerItem {
        id: player
        anchors.fill: parent
        onVdecStop: {
            console.log("Vdec thread stop!")
        }
        Component.onCompleted:  player.startVdec(true)
    }

    Rectangle {
        width: parent.width
        height: 60
        anchors.top: parent.top
        color: "black"
        z: 2
    }

    Rectangle {
        id: vdecPlayerInfo
        anchors.centerIn: parent
        radius: 20
        color: "#555555"
        visible: false
        Text {
            visible: false
            anchors.top: parent.top
            anchors.topMargin: parent.height / 480 * 80
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Vdec无法使用！")
            font.family: "Montserrat Light"
            font.pixelSize: parent.width / 800 * 20
            color: "black"
        }
    }

    onVisibleChanged: {
        if (visible)
            player.startVdec(true)
        else
            player.startVdec(false)
    }

    state: ""
    states:[
        State {
            name: "show"
            PropertyChanges {
                target: app_vdecPlayer
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
}
