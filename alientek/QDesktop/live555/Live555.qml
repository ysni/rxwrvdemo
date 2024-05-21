/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   live555
* @brief         Live555.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-23
* @link          www.opendev.com
*******************************************************************/
import QtQuick 2.12

import QtQuick.Controls 2.12

import live555Thread 1.0

Item {
    visible: true
    width: 720
    height: 1280
    id: app_live555
    opacity: 0
    property real showPropertyChangeOpacity: 1
    property real showPropertyChangeX: 0
    property real showPropertyChangeY: 0
    property bool show: false


    property int time_cnt: 0

    Live555Thread {
        id: live555Thread
    }

    Timer {
        id: color_timer
        repeat: true
        interval: 1000
        onTriggered: {
            if (time_cnt >= 2) {
                btn_start_cover.color = "black"
            } else {
                btn_start_cover.color = "red"
            }
            time_cnt++
            if (time_cnt === 4)
                time_cnt = 0
        }
    }

    Rectangle {
        id: panelRect
        anchors.fill: parent
        color: "black"
        RoundButton {
            id: roundButton
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 100
            anchors.horizontalCenter: parent.horizontalCenter
            width:  200
            height: 200
            checkable: true
            checked: false
            background: Rectangle {
                id: btn_bg
                anchors.fill: parent
                radius:  100
                color: "black"
                border.color: "#eeeeee"
                border.width: 10

                Rectangle {
                    id: btn_start_cover
                    anchors.centerIn: parent
                    color: "black"
                    width: 180
                    height: 180
                    radius: 90
                    Behavior on color { PropertyAnimation { duration: 2000; easing.type: Easing.Linear } }
                }
            }
            Text {
                id: text_start
                text: qsTr("START")
                color: "white"
                font.pixelSize: 40
                font.family: "Montserrat Bold"
                anchors.centerIn: parent
            }

            onClicked: {
                live555Thread.setLive555MediaServerStart(roundButton.checked)
                if (roundButton.checked) {
                    color_timer.start()
                    text_start.text = "STOP"
                } else {
                    text_start.text = "START"
                    color_timer.stop()
                    time_cnt = 0
                    btn_start_cover.color = "black"
                }
            }
        }
    }

    Rectangle {
        width: parent.width - 100
        height: 300
        color: "white"
        radius: 20
        anchors.centerIn: parent

        Text {
            id: server_ipaddr
            anchors.centerIn: parent
            text: "拉流IP地址\n\n" + live555Thread.getHostInfo()
            color: "black"
            font.pixelSize: 40
            visible: true
            font.family: "Montserrat Bold"
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }

    state: ""
    states:[
        State {
            name: "show"
            PropertyChanges {
                target: app_live555
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
