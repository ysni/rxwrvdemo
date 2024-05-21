/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   sensor
* @brief         Sensor_Window.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-10-22
*******************************************************************/
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5

import ap3216c 1.0
import icm20608 1.0

Window {
    visible: true
    width: 800
    height: 480
    title: qsTr("Sensor")

    property var strArray:[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    id: sensor

    Rectangle {
        anchors.fill: parent
        color: "#eff2f7"
    }

    onVisibleChanged: {
        if(armEnv){
            ap3216c.setCapture(sensor.visible)
            icm20608.setCapture(sensor.visible)
        }
    }

    ListModel {
        id: m_model
        ListElement {
            title1: "3&1环境传感器AP3216C"
            title2: "环境光强度(ALS)"
            title3: "ALS"
            itemValue: "0"
            rect_color: "#65c3df"
            imageSrc: "qrc:/icons/als_icon.png"
        }
        ListElement {
            title1: "3&1环境传感器AP3216C"
            title2: "接近距离(PS)"
            title3: "PS"
            itemValue: "0"
            rect_color: "#ffd800"
            imageSrc: "qrc:/icons/als_icon.png"
        }
        ListElement {
            title1: "3&1环境传感器AP3216C"
            title2: "红外线强度(IR)"
            title3: "IR"
            itemValue: "0"
            rect_color: "#ff3e3f"
            imageSrc: "qrc:/icons/als_icon.png"
        }
        ListElement {
            title1: "六轴MEMS传感器"
            title2: "陀螺仪X轴(GX)"
            title3: "GX"
            itemValue: "0"
            rect_color: "#4ac3aa"
            imageSrc: "qrc:/icons/gyro_icon.png"
        }
        ListElement {
            title1: "六轴MEMS传感器"
            title2: "陀螺仪Y轴(GY)"
            title3: "GY"
            itemValue: "0"
            rect_color: "#ffd800"
            imageSrc: "qrc:/icons/gyro_icon.png"
        }
        ListElement {
            title1: "六轴MEMS传感器"
            title2: "陀螺仪Z轴(GZ)"
            title3: "GZ"
            itemValue: "0"
            rect_color: "#65c3df"
            imageSrc: "qrc:/icons/gyro_icon.png"
        }
        ListElement {
            title1: "六轴MEMS传感器"
            title2: "加速度计X轴(AX)"
            title3: "AX"
            itemValue: "0"
            rect_color: "#ffd800"
            imageSrc: "qrc:/icons/gyro_icon.png"
        }
        ListElement {
            title1: "六轴MEMS传感器"
            title2: "加速度计Y轴(AY)"
            title3: "AY"
            itemValue: "0"
            rect_color: "#65c3df"
            imageSrc: "qrc:/icons/gyro_icon.png"
        }
        ListElement {
            title1: "六轴MEMS传感器"
            title2: "加速度计Z轴(AZ)"
            title3: "AZ"
            itemValue: "0"
            rect_color: "#ff3e3f"
            imageSrc: "qrc:/icons/gyro_icon.png"
        }
        ListElement {
            title1: "六轴MEMS传感器"
            title2: "温度值(TEMP)"
            title3: "T"
            itemValue: "0"
            rect_color: "#4ac3aa"
            imageSrc: "qrc:/icons/gyro_icon.png"
        }
    }

    function setValue() {
        for (var i = 0; i < m_model.count; i++) {
            var item = m_model.get(i);
            item.itemValue = strArray[i]
        }
    }

    Ap3216c {
        id: ap3216c
        onAp3216cDataChanged: {
            strArray[0] = alsData
            strArray[1] = psData
            strArray[2] = irData
        }
    }

    Icm20608 {
        id: icm20608
        onIcm20608DataChanged: {
            strArray[3] = gxData + "°/S"
            strArray[4] = gyData + "°/S"
            strArray[5] = gzData + "°/S"
            strArray[6] = axData + "g"
            strArray[7] = ayData + "g"
            strArray[8] = azData + "g"
            strArray[9] = tempData + "℃"
            setValue()
        }
    }
    Rectangle {
        id: title_Rect
        anchors.top: parent.top
        width: parent.width
        height: 80
        color: "#313443"
        anchors.topMargin: 20

        Text {
            anchors.centerIn: parent
            text: qsTr("Sensor")
            color: "white"
            font.pixelSize: 20
        }

        /*Row {
            anchors.centerIn: parent
            Image {
                width: 40
                height: 40
                source: "qrc:/icons/gyro_icon.png"
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("陀螺仪")
                color: "white"
                font.pixelSize: 20
            }

            Image {
                width: 40
                height: 40
                source: "qrc:/icons/als_icon.png"
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("环境传感")
                color: "white"
                font.pixelSize: 20
            }
        }*/
    }

    Rectangle {
        id: backgroud_rect1
        color: "white"
        anchors.top: title_Rect.bottom
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.topMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
        width: listview.width / 5 * 2
    }

    Rectangle {
        id: backgroud_rect2
        color: "white"
        anchors.top: title_Rect.bottom
        anchors.left: backgroud_rect1.right
        anchors.leftMargin: 20
        anchors.topMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
        width: listview.width / 5 * 3 - 20
    }

    ListView {
        id: listview
        width: parent.width - 40
        anchors.top: title_Rect.bottom
        anchors.topMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        clip: true
        model: m_model
        ScrollBar.vertical: ScrollBar {
            id: scrollBar
            width: 10
            onActiveChanged: {
                active = true
            }
            Component.onCompleted: {
                scrollBar.active = true
            }
            contentItem: Rectangle{
                implicitWidth: 10
                implicitHeight: 100
                radius: width / 2
                color: scrollBar.hovered ? "#88101010" : "#30101010"
            }
            background: Rectangle {
                anchors.fill: parent
                color: "transparent"
            }
        }
        delegate:Rectangle {
            height: 80
            width: parent.width
            //color: index % 2 == 0? "transparent" : "#304d87ee"
            color: "transparent"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    listview.currentIndex = index
                }
            }

            Rectangle {
                id: round_rect
                width: parent.height - 20
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 20
                height: width
                radius: height / 2
                color: rect_color

                Image {
                    anchors.centerIn: parent
                    width: parent.width - 20
                    height: width
                    source: imageSrc
                }
                /*Text {
                    text: title3
                    color: "white"
                    font.bold: true
                    anchors.centerIn: parent
                    font.pixelSize: 15
                }*/
            }

            Column {
                anchors.left: round_rect.right
                anchors.leftMargin: 20
                anchors.verticalCenter:  parent.verticalCenter
                Text {
                    id: functionText1
                    text: title1
                    color: "black"
                    font.pixelSize: 15
                }
                Text {
                    id: functionText2
                    text: title2
                    color: "#8297a8"
                    font.pixelSize: 13
                }
            }
            Rectangle {
                height: 1
                width: parent.width / 5 * 3 - 60
                anchors.right: parent.right
                anchors.rightMargin: 20
                anchors.bottom: parent.bottom
                id: line
                color: "gray"
            }
            Text {
                id: valueTex
                text: itemValue
                anchors.horizontalCenter: line.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                color: "black"
                font.pixelSize: 20
                font.bold: true
            }
        }
    }
}
