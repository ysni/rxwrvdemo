/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   factorytest
* @brief         FactoryTest_Window.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-11-09
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5

import factory 1.0

Window {
    visible: true
    width: 800
    height: 480
    id: app_factorytest
    property int timeCnt: 0
    title: qsTr("app_factorytest")
    property bool beepFlag: false

    Rectangle {
        anchors.fill: parent
        color: "#f0f0f0"
    }

    Item {
        anchors.top: parent.top
        anchors.topMargin: 80
        anchors.bottom: startTestBt.top
        anchors.bottomMargin: 20
        width: parent.width - 100
        anchors.horizontalCenter: parent.horizontalCenter
        Flickable {
            id: flickable
            anchors.fill: parent
            contentHeight: textArea.height
            contentWidth: parent.width
            clip: true
            ScrollBar.vertical: ScrollBar {
                id: scrollBar
                width: 20
                background: Rectangle {color: "transparent"}
                onActiveChanged: {
                    active = true;
                }
                Component.onCompleted: {
                    scrollBar.active = true;
                }
                contentItem: Rectangle{
                    implicitWidth: 20
                    implicitHeight: 100
                    radius: 10
                    color: scrollBar.pressed ? "#88101010" : "#30101010"
                }
            }

            TextArea {
                id: textArea
                placeholderText: "这里会打印测试结果"
                anchors.top: parent.top
                height: contentHeight
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                placeholderTextColor: "#88555555"
                font.pixelSize: 25
                onTextChanged: scrollBar.increase()
            }
        }
    }
    Button {
        id: startTestBt
        width: app_factorytest.width - 100
        height: 300
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 100
        anchors.horizontalCenter: parent.horizontalCenter
        checked: false
        checkable: true
        onClicked:  {
            if (startTestBt.checked)
                textArea.text = ""
            factory.setThreadStart(startTestBt.checked)
        }

        background: Rectangle {
            anchors.fill: parent
            color: startTestBt.checked ? "#dddddd" :"white"
            radius: 50
            border.color: startTestBt.checked ? "white" : "#bbbbbb"
            border.width: 2
            Text {
                id: startTestText
                text: startTestBt.checked ? qsTr("停止测试") : qsTr("开始测试")
                font.pixelSize: 50
                color: startTestBt.checked ? "gray" : "#0b62f6"
                anchors.centerIn: parent
            }
        }
    }

    Factory {
        id: factory
        onKeyDown: {
            textArea.text = textArea.text + "keydown" + timeCnt.toString() + "\n"
            timeCnt++
            if (timeCnt > 10)
                timeCnt = 0
        }
        onGetShellTestMessage: textArea.text = textArea.text + message
    }
}
