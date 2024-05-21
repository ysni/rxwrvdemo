/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   desktop
* @brief         CircleView.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-09-13
*******************************************************************/
import QtQuick 2.0
import QtQuick.Controls 2.5

Item {
    onVisibleChanged: {
        if (parent.visible)
            circle_timer.start()
        else
            circle_timer.stop()
    }
    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - 20
        height: parent.height
        color: "white"
        radius: 30

        ListModel {
            id: contactModel
            ListElement {
                name: "Bill Jones"
                icon: "qrc:/images/music_image_1.png"
            }
            ListElement {
                name: "Jane Doe"
                icon: "qrc:/images/music_image_2.png"
            }
            ListElement {
                name: "John Smith"
                icon: "qrc:/images/music_image_3.png"
            }
        }

        Component {
            id: delegate
            Image {
                source: icon
                fillMode: Image.PreserveAspectFit
                //PreserveAspectCrop
                anchors.verticalCenter: parent.verticalCenter
                opacity: PathView.isCurrentItem ? 1 : 0.5
                z: PathView.isCurrentItem ? 2 : 0
                width: PathView.isCurrentItem ? 400 : 300
                height: PathView.isCurrentItem ? 600 : 250
                MouseArea {
                    hoverEnabled: true
                    anchors.fill: parent
                    onPressed: circle_timer.stop()
                    onReleased: circle_timer.start()
                    onExited: circle_timer.start()
                }
            }
        }
    }
    PathView {
        id: circle_pathView
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        model: contactModel
        delegate: delegate
        path: Path {
            startX: parent.width / 2; startY: 100
            PathQuad { x: parent.width / 2; y: 100; controlX: parent.width / 2 - 400; controlY: 75 }
            PathQuad { x: parent.width / 2; y: 100; controlX: parent.width / 2 + 400; controlY: 75 }
        }
    }

    Timer {
        id: circle_timer
        interval: 5000
        repeat: true
        running: music_cd_dawer_bottom.y != 0
        onTriggered: {
            circle_pathView.currentIndex++
        }
    }

    Button {
        id: circle_previous_button
        width: 80
        height: 80
        //x: parent.width / 2 - 200
        //y: 80
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 50
        Rectangle {
            anchors.fill: parent
            radius: 40
            color: circle_previous_button.pressed | circle_previous_button.hovered ? "#55101010" : "#22101010"
        }
        background: Image {
            width: 40
            height: 40
            anchors.centerIn: parent
            id: circle_pre
            source: "qrc:/icons/previous_button_icon.png"
        }

        onClicked: circle_pathView.currentIndex--
    }

    Button {
        id: circle_next_button
        width: 80
        height: 80
        //x: parent.width / 2 + 160
        //y: 80
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 50
        Rectangle {
            anchors.fill: parent
            radius: 40
            color: circle_next_button.pressed | circle_next_button.hovered ? "#55101010" : "#22101010"
        }
        background: Image {
            width: 40
            height: 40
            anchors.centerIn: parent
            id: circle_next
            source: "qrc:/icons/next_button_icon.png"
        }
        onClicked: circle_pathView.currentIndex++
    }
}
