/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   QDesktop
* @brief         Cardvr_Window.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-14
* @link          www.opendev.com
*******************************************************************/
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5

import cardvrItem 1.0

Window {
    id: app_camera
    visible: true
    width: 800
    height: 480
    title: qsTr("app_cardvr")

    Rectangle {
        id: cameraBg
        anchors.fill: parent
        color: "black"
    }

    CardvrItem {
        id: cardvrItem
        anchors.fill: parent
        onCaptureStop: {
            console.log("cardvr thread stop!")
        }

        onMp4fileisReady: {
            toste.visible = true
        }

        onH264fileisReady: {
            recTimer.stop()
            recTimer.repeat = !readyFlag
            recRow.visible = !readyFlag
        }
    }
    Row {
        id: recRow
        visible: true
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.left: parent.left
        anchors.leftMargin: 20
        spacing: 15
        Rectangle {
            color: "red"
            radius: 20
            width: 40
            height: 40
        }
        Text {
            id: rec
            text: qsTr("REC")
            color: "red"
            font.family: "Montserrat Bold"
            font.pixelSize:  30
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Timer {
        id: recTimer
        repeat: true
        interval: 500
        running: true
        onTriggered: {
            recRow.visible = !recRow.visible
        }
    }

    Button {
        id: tipsButton
        width: 64
        height: 64
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
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
        id: toste
        visible: false
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 80
        anchors.horizontalCenter: parent.horizontalCenter
        width: 200
        height: 80
        radius: 10
        Text {
            font.pixelSize: 25
            text: qsTr("录像30S完成！")
            font.family: "Montserrat Light"
            anchors.centerIn: parent
            color: "black"
        }
        states: State {
            name: "show"; when: toste.visible
            PropertyChanges { target: toste; opacity: 0 }
        }

        transitions: Transition {
            NumberAnimation { properties: "opacity"; easing.type: Easing.InOutQuad; duration: 5000 }
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
                text: qsTr("本应用从启动到结束或者放于后台只会录制30s的视频文件(1920x1080@30fps)（防止一直录制导致储存空间不够用），
录制完成会保存到以下目录。\nH264录像文件路径\n" + cardvrItem.getVideoFilePath() + "/src/cardvr/cardvr.h264\nMP4录像文件路径\n"
                           + cardvrItem.getVideoFilePath() + "/src/cardvr/cardvr.mp4")
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
            cardvrItem.startCapture(true)
        } else {
            cardvrItem.startCapture(false)
        }
    }
}
