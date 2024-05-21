/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   photoview
* @brief         DisplayPhoto.qml
* @author        Deng Zhimao
* @email         1252699831@qq.com
* @date          2020-07-16
*******************************************************************/
import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls 2.5
import QtQml 2.12

Item {
    id: displayView

    onFocusChanged:  pathView.currentIndex = photoListModel.currentIndex

    Item {
        id: topMenu
        y: -80
        x: 0
        z: 50
        height: 80
        width: parent.width
        Rectangle{
            id: topMenuBg
            anchors.fill: parent
            color: "#eff2f7"
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    topContainer.state == 'topShow' ? topContainer.state = '' : topContainer.state = 'topShow'
                    bottomContainer.state == 'bottomShow' ? bottomContainer.state = '' : bottomContainer.state = 'bottomShow'
                }
            }
            Button {
                id: back_button
                anchors.top: parent.top
                anchors.topMargin: 40
                width: 80
                opacity: back_button.pressed ? 0.5 : 1.0
                background: Image {
                    id: back_image
                    source: "qrc:/icons/back.png"
                    width: 40
                    fillMode: Image.PreserveAspectCrop
                }
                onClicked: photoSwipeView.currentIndex = 0

                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("相簿")
                    font.family: "Montserrat Light"
                    color: "#0b62f6"
                    font.pixelSize: 20
                    font.underline: true
                }
            }
        }
    }
    Item {
        id: topContainer
        states: State {
            name: "topShow"
            PropertyChanges {
                target: topMenu
                y: 0
            }
        }
        transitions: Transition {
            NumberAnimation {
                property: "y"
                easing.type: Easing.InOutQuart
                duration: 500
            }
        }
    }

    Item {
        id: bottomMenu
        y: parent.height - 80
        x: 0
        z: 20
        height: 50
        width: parent.width
        Rectangle{
            id: bottomMenuBg
            anchors.fill: parent
            color: "#eff2f7"
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    topContainer.state == 'topShow' ? topContainer.state = '' : topContainer.state = 'topShow'
                    bottomContainer.state == 'bottomShow' ? bottomContainer.state = '' : bottomContainer.state = 'bottomShow'
                }
            }
        }
    }
    Item {
        id: bottomContainer
        states: State {
            name: "bottomShow"
            PropertyChanges {
                target: bottomMenu
                y: displayView.height - 130
            }
        }
        transitions: Transition {
            NumberAnimation {
                property: "y"
                easing.type: Easing.InOutQuart
                duration: 500
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        id:coverflow
        color:"black"
        Component.onCompleted: {
            //console.log(coverflow.width,coverflow,height)
        }

        property ListModel model
        property int itemCount: 1 //3
        PathView{
            id: pathView
            model: photoListModel
            currentIndex: photoListModel.currentIndex
            anchors.centerIn: parent
            Timer {
                id: db_timer
                interval: 200
                repeat: false
            }

            Timer {
                id: show_toolBar
                interval: 5000
                repeat: false
                onTriggered: {
                    topContainer.state = ''
                    bottomContainer.state = ''
                }
            }

            delegate: Item {
                id:delegateItem
                width: parent.width
                height: parent.height
                z: Math.floor(PathView.iconZ)
                //scale: Math.abs(PathView.iconScale)
                Image{
                    id:image
                    source: path
                    width: delegateItem.width
                    height: delegateItem.height
                    smooth: true
                    fillMode: Image.PreserveAspectFit
                    opacity: pathView.currentIndex == index ? 1 : 0.1
                    enabled: pathView.currentIndex == index ? true : false
                    antialiasing: true
                    Behavior on scale { PropertyAnimation { duration: 350; easing.type: Easing.Linear } }
                    MouseArea {
                        id: mapDragArea
                        anchors.fill: image
                        property int dragy
                        onClicked: {
                            show_toolBar.start()
                            //topContainer.state == 'topShow' ? topContainer.state = '' : topContainer.state = 'topShow'
                            //bottomContainer.state == 'bottomShow' ? bottomContainer.state = '' : bottomContainer.state = 'bottomShow'
                            topContainer.state = 'topShow'
                            bottomContainer.state = 'bottomShow'
                            if (db_timer.running)  {
                                image.scale = image.scale * 1.5
                                db_timer.stop()
                                show_toolBar.restart()
                            } else
                                db_timer.restart()
                        }
                        onPressAndHold: drag.target = image
                        onWheel: {
                            var datla = wheel.angleDelta.y / 120
                            if (datla > 0){
                                image.scale = image.scale / 0.9
                            } else {
                                image.scale = image.scale * 0.9
                            }
                        }
                        onDoubleClicked:  image.scale = image.scale * 1.5
                        onPressed: dragy = mouseY
                        onReleased: {
                            if (mouseY - dragy >= 20)
                                image.scale = image.scale / 1.5
                        }
                    }
                }
                transform: Rotation{
                    origin.x: image.width / 2.0
                    origin.y: image.height / 2.0
                    axis {x: 0; y:1; z:0}
                    //angle: Math.floor(delegateItem.PathView.iconAngle)
                }
            }
            path:coverFlowPath
            pathItemCount: coverflow.itemCount
            anchors.fill: parent

            preferredHighlightBegin: 0.5
            preferredHighlightEnd: 0.5

        }

        RoundButton {
            id: previous_button
            width: 80
            height: 80
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            background: Rectangle {
                anchors.fill: parent
                color: previous_button.pressed ? "#88888888" : "#44888888"
                radius: height / 2
                Image {
                    width: 40
                    height: 40
                    opacity: 0.6
                    anchors.centerIn: parent
                    source: "qrc:/icons/previous_button_icon.png"
                }
            }
            onClicked: pathView.currentIndex--
        }

        RoundButton {
            id: next_button
            width: 80
            height: 80
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            background: Rectangle {
                anchors.fill: parent
                color: next_button.pressed ? "#88888888" : "#44888888"
                radius: height / 2
                Image {
                    width: 40
                    height: 40
                    opacity: 0.6
                    anchors.centerIn: parent
                    source: "qrc:/icons/next_button_icon.png"
                }
            }
            onClicked: pathView.currentIndex++
        }

        Path {
            id:coverFlowPath
            startX: 0
            startY: coverflow.height/2

            //PathAttribute {name:"iconZ"; value: 0}
            //PathAttribute {name:"iconAngle"; value: 70}
            //PathAttribute {name:"iconScale"; value: 0.1}
            PathLine {x:coverflow.width/2; y:coverflow.height/2}

            //PathAttribute {name:"iconZ"; value: 100}
            //PathAttribute {name:"iconAngle"; value: 0}
            //PathAttribute {name:"iconScale"; value: 1.0}

            PathLine {x:coverflow.width; y:coverflow.height/2}
            //PathAttribute {name:"iconZ"; value: 0}
            //PathAttribute {name:"iconAngle"; value: -70}
            //PathAttribute {name:"iconScale"; value: 0.1}
            PathPercent {value:1.0}

        }
    }

    Rectangle {
        width: 40
        height: 40
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 130
        radius: height / 2
        anchors.right: parent.right
        anchors.rightMargin: 5
        color: "#88dddddd"
        Text {
            text: pathView.currentIndex == -1 ? "1" : pathView.currentIndex + 1
            font.pixelSize: 15
            anchors.centerIn: parent
            font.family: "Montserrat Light"
        }
    }
}
