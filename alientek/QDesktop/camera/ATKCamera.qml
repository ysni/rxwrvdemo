/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   desktop
* @brief         RKCamera.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2022-10-09
*******************************************************************/

import QtQuick 2.12
import QtQuick.Controls 2.5

import cameraItem 1.0

Item {
    id: app_camera
    y: app_camera.height
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

    CameraItem {
        id: cameraItem
        anchors.fill: parent
        onCaptureStop: {
            console.log("camera thread stop!")
            cameraInfoText.text = "摄像头无法使用！"
            roundButton2.enabled = true
            cameraInfo.visible = true
            moreCamera.enabled = true
        }

        onCaptureStart: {
            console.log("camera thread start!")
            cameraInfo.visible = false
        }
        onFinishedPhoto: {
            shotPhoto.source = "file:///" + photoPath
            roundButton2.enabled = true
        }

        Component.onCompleted: {
            cameraItem.startCapture(true)
            cameraInfo.visible = false
        }
    }

    Rectangle {
        width: parent.width
        height: 60
        anchors.top: parent.top
        color: "black"
        z: 2
    }

    Rectangle {
        id: cameraInfo
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.bottom: parent.bottom
        color: "#D1D1D6"
        visible: false
        Text {
            id: cameraInfoText
            visible: true
            anchors.centerIn: parent
            text: qsTr("摄像头无法使用！")
            font.family: "Montserrat Regular"
            font.pixelSize: 50
            color: "black"
        }
    }

    onVisibleChanged: {
        if (visible) {
            cameraItem.startCapture(true)
            cameraInfo.visible = false
        } else {
            cameraItem.startCapture(false)
        }
    }

    state: ""
    states:[
        State {
            name: "show"
            PropertyChanges {
                target: app_camera
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

    Item {
        id: panelRect
        height: 200
        width: parent.width
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        Item {
            id: item1
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter

            width: 80
            height: 80
            RoundButton {
                id: roundButton1
                anchors.centerIn: parent
                width:  80
                height: 80
                background: Rectangle {
                    anchors.fill: parent
                    radius:  40
                    border.color: "white"
                    border.width: 6
                    color: "transparent"
                    Rectangle {
                        width: roundButton1.pressed ? 55 : 60
                        height: roundButton1.pressed ? 55 : 60
                        color: "white"
                        radius: height / 2
                        anchors.centerIn: parent
                    }
                }

                onClicked: {
                    cameraItem.startCapture(true)
                    cameraItem.startPhotoGraph(true)
                    roundButton2.enabled = false
                }
            }
        }

        RoundButton {
            id: roundButton2
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: item1.verticalCenter
            width: 60
            height: width
            background: Image {
                anchors.centerIn: parent
                width: parent.width
                height: parent.width
                source: "qrc:/icons/switch_camera_icon.png"
                opacity: roundButton2.pressed ? 0.8 : 1.0
            }

            onClicked: camera_dawer_bottom.open()
        }

        Button {
            id: roundButton3
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: item1.verticalCenter
            width: 60
            height: width
            checkable: true
            checked: false
            Image {
                id: shotPhoto
                z: -1
                anchors.centerIn: parent
                width: parent.width - 20
                height: parent.width - 20
            }
            background: Rectangle {
                anchors.fill: parent
                radius:  6
                border.width: 2
                border.color: "white"
                opacity: roundButton3.pressed ? 0.8 : 1.0
                color: "transparent"
            }
            onClicked: {
                global_photo_Check =  false
                global_appIndex = 2
            }
        }
    }

    Rectangle {
        id: camera_dawer_bottom
        width: parent.width
        height: parent.height
        z: 2
        color: "#55101010"
        x: 0
        y: height
        Behavior on y { PropertyAnimation { duration: 250; easing.type: Easing.OutQuad } }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                camera_dawer_bottom.close()
            }
        }

        MoreCamera {
            id: moreCamera
            anchors.fill: parent
        }

        function open() {
            camera_dawer_bottom.y = 0
            moreCamera.enabled = true
            //cameraItem.startCapture(false)
        }

        function close() {
            camera_dawer_bottom.y = height
            //cameraItem.startCapture(true)
            cameraInfo.visible = false
        }
    }
}
