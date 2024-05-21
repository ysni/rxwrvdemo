/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   facedetectionitem
* @brief         facedetectionitem.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-29
* @link          http://www.openedv.com/forum.php
*******************************************************************/

import QtQuick 2.12
import QtQuick.Controls 2.5

import facedetectionitem 1.0

Item {
    id: app_facedetectionitem
    y: app_facedetectionitem.height
    x: 0
    opacity: 0
    property real showPropertyChangeOpacity: 1
    property real showPropertyChangeX: 0
    property real showPropertyChangeY: 0
    property bool show: false

    Rectangle {
        id: cameraBg
        anchors.fill: parent
        color: "black"
    }

    FaceDetectionItem {
        id: orItem
        anchors.fill: parent
        onCaptureStop: {
            console.log("facedetectionitem thread stop!")
        }

        Component.onCompleted: orItem.startCapture(true)
    }

    Button {
        id: tipsButton
        width: 64
        height: 64
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 80
        anchors.right: parent.right
        anchors.rightMargin: 20
        background: Image {
            source: "qrc:/icons/tips.png"
            anchors.fill: parent
        }
        onClicked: {
            warningDialog.open()
        }
    }

    Rectangle {
        id: warningDialog
        anchors.fill: parent
        visible: false
        color: "#55101010"

        function close() {
            warningDialog.visible = false
        }

        function open() {
            warningDialog.visible = true
        }

        MouseArea {
            anchors.fill: parent
            onClicked: warningDialog.close()
        }
        Rectangle {
            id: center_Rect
            width: parent.width - 100
            height: 600
            color: "#f0f0f0"
            radius: 20
            anchors.centerIn: parent
            Text {
                anchors.top: parent.top
                height: parent.height / 10
                width: parent.width
                color: "black"
                font.pixelSize: 30
                font.family: "Montserrat Light"
                text: "警告"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
                wrapMode: Text.WordWrap
            }
            Text {
                anchors.centerIn: parent
                width: parent.width
                color: "black"
                font.pixelSize: 25
                font.family: "Montserrat Light"
                text: qsTr("功能:检测人脸")
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }
            Rectangle {
                width: parent.width
                height: 1
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#d2d3d5"
                anchors.bottom: finish_button.top
            }
            Rectangle {
                width: parent.width
                height: 20
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: finish_button.top
                color: finish_button.pressed ?  "#dddddd" : "transparent"
            }
            Button {
                id: finish_button
                anchors.bottom: parent.bottom
                width: parent.width
                height: warningDialog.height / 10
                background: Rectangle {
                    anchors.fill: parent
                    radius: center_Rect.radius
                    color: finish_button.pressed ?  "#dddddd" : "transparent"
                }

                Text {
                    id: finish_bt
                    font.pixelSize: 30
                    text: qsTr("完成")
                    font.family: "Montserrat Light"
                    anchors.centerIn: parent
                    color: "#007aff"
                }
                onClicked: warningDialog.close()
            }
        }
    }

    onVisibleChanged: {
        if (visible) {
            orItem.startCapture(true)
        } else {
            orItem.startCapture(false)
        }
    }


    state: ""
    states:[
        State {
            name: "show"
            PropertyChanges {
                target: app_facedetectionitem
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
