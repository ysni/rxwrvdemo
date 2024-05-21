/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   iotest
* @brief         Iotest_Window.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-10-28
*******************************************************************/
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5

import beep 1.0

Window {
    visible: true
    width: 800
    height: 480
    id: app_iotest
    title: qsTr("app_iotest")
    property bool beepFlag: false

    onVisibleChanged: {
        beep.setKeyMonitor(visible)
        if (visible) {
            key0_bt.forceActiveFocus()
        }
    }

    Beep {
        id: beep
        onKeysPressChanged: {
            if (beep.key0Str)
                console.log("Key0 Pressed!")
            if (!beep.key0Str)
                beepFlag = false
            else
                beepFlag = true
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#888888"
    }

    Rectangle {
        id: title_Rect
        anchors.top: parent.top
        width: parent.width
        height: parent.width >= 800 ? 80 : 60
        color: "#313443"
        anchors.topMargin: 20

        Text {
            anchors.centerIn: parent
            text: qsTr("Key & Beep iotest")
            color: "white"
            font.pixelSize: 20
        }
    }

    RoundButton {
        id: key0_bt
        width: parent.width / 800 * 150
        height: width
        anchors.centerIn: parent
        opacity: key0_bt.pressed | beep.key0Str ? 0.5 : 1.0
        background: Rectangle {
            anchors.fill: parent
            radius: parent.height / 2
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#0b4c8c" }
                GradientStop { position: 0.2; color: "#0f4c99" }
                GradientStop { position: 0.5; color: "#3f559a" }
                GradientStop { position: 1.0; color: "#0b4c8c" }
            }
            border.width: 5
            border.color: "white"
        }
        onPressed: {
            if (armEnv)
                beep.setBeepState(true)
        }
        onReleased: {
            if (armEnv)
                beep.setBeepState(false)
        }

        Keys.enabled: true
        focus: true
        Keys.onPressed:  {
            if (event.key === Qt.Key_Up || event.key === Qt.Key_VolumeDown){
                console.log(event.key)
                beepFlag = true
                if(armEnv)
                    beep.setBeepState(true)
            }

            if (event.key === Qt.Key_Down || event.key === Qt.Key_VolumeUp ){
                console.log(event.key)
                beepFlag = true
                if(armEnv)
                    beep.setBeepState(true)
            }
        }
        Keys.onReleased: {
            if (event.key === Qt.Key_Up || event.key === Qt.Key_VolumeDown
                    || event.key === Qt.Key_Down || event.key === Qt.Key_VolumeUp ) {
                beepFlag = false
                if(armEnv)
                    beep.setBeepState(false)
            }
        }
    }

    Text {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("请按下板子上的KEY0,按下蜂鸣器会响")
        color: "white"
        font.pixelSize: 20
    }
}
