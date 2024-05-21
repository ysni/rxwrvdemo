/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   QDesktop
* @brief         MainPage.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-10-27
*******************************************************************/
import QtQuick 2.12
import QtQuick.Controls 2.5

Item {

    property int item_height: other_Rect.height / 6

    Text {
        id: setting_Top_center_Text
        text: qsTr("设置")
        color: "black"
        font.pixelSize: 30
        anchors.top: parent.top
        anchors.topMargin: 40
        opacity: 0.0
        font.family: "Montserrat Light"
        anchors.horizontalCenter: parent.horizontalCenter
        Behavior on opacity { PropertyAnimation { duration: 1000; easing.type: Easing.InOutBack } }
    }

    Rectangle {
        anchors.bottom: item1.top
        width: app_settings.width
        height: 1
        color: "#c6c6c8"
        z: 5
        visible: setting_Top_center_Text.opacity == 1.0
    }

    Item {
        id: item1
        anchors.top: parent.top
        anchors.topMargin: 80
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Flickable {
            id: settings_flickable
            anchors.fill: parent
            contentHeight: app_settings.height >= 480 ? parent.height + 100 : parent.height + 200
            contentWidth: parent.width
            clip: true

            onFlickEnded:  {
                if (contentY >= setting_Text.height / 2) {
                    setting_Top_center_Text.opacity = 1.0
                    setting_Text.opacity = 0.0
                } else if (contentY <= 20) {
                    setting_Top_center_Text.opacity = 0.0
                    setting_Text.opacity = 1.0
                }
            }
            Text {
                id: setting_Text
                text: qsTr("设置")
                color: "black"
                font.pixelSize: 50
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: 20
                opacity: 1.0
                font.family: "Montserrat Light"
                Behavior on opacity { PropertyAnimation { duration: 1000; easing.type: Easing.InOutBack } }
            }
            Column {
                anchors.top: setting_Text.bottom
                spacing: 10
                Rectangle {
                    id: user_Rect
                    width: app_settings.width
                    height: 200
                    color: "white"
                    //radius: height / 5
                    Column {
                        Item {
                            width: user_Rect.width
                            height: user_Rect.height / 2
                            Image {
                                id: user_icon
                                width: 50
                                height: 50
                                source: "qrc:/icons/user_icon.png"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                            }
                            Text {
                                id: user_text
                                text: qsTr("用户")
                                color: "black"
                                font.pixelSize: 30
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: user_icon.right
                                anchors.leftMargin: 20
                                font.family: "Montserrat Light"
                            }
                        }
                        Rectangle {
                            width: parent.width - 40
                            anchors.horizontalCenter: parent.horizontalCenter
                            height: 1
                            color: "#c6c6c8"
                        }
                        Item {
                            width: user_Rect.width
                            height: user_Rect.height / 2
                            Image {
                                id: device_icon
                                width: 50
                                height: 50
                                source: "qrc:/icons/device_icon.png"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                            }
                            Text {
                                id: device_text
                                text: qsTr("关于本机")
                                color: "black"
                                font.pixelSize: 30
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: device_icon.right
                                anchors.leftMargin: 20
                                font.family: "Montserrat Light"
                            }

                            Text {
                                id: version_text
                                text: qsTr("ATKOS 4.0.0")
                                color: "#8a8a8d"
                                font.pixelSize: 25
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: next1.left
                                anchors.rightMargin: 20
                                font.family: "Montserrat Light"
                            }

                            Image {
                                id: next1
                                source: "qrc:/icons/item_next.png"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: 10
                                opacity: device_mouseArea.pressed ? 0.8 : 1
                            }

                            MouseArea {
                                id: device_mouseArea
                                anchors.fill: parent
                                onClicked: settings_swipeView.currentIndex = 1
                            }
                        }
                    }
                }

                Rectangle {
                    id: other_Rect
                    width: app_settings.width
                    height: 600
                    color: "white"
                    Column {
                        Item {
                            width: other_Rect.width
                            height: item_height
                            Image {
                                id: wifi_icon
                                width: 50
                                height: 50
                                source: "qrc:/icons/wifi_icon.png"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                            }

                            Text {
                                id: wlan_text
                                text: qsTr("无线局域网")
                                color: "black"
                                font.pixelSize: 30
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: wifi_icon.right
                                anchors.leftMargin: 20
                                font.family: "Montserrat Light"
                            }
                        }
                        Rectangle {
                            width: parent.width - 40
                            anchors.horizontalCenter: parent.horizontalCenter
                            height: 1
                            color: "#c6c6c8"
                        }
                        Item {
                            width: other_Rect.width
                            height: item_height
                            Image {
                                id: bluetooth_icon
                                width: 50
                                height: 50
                                source: "qrc:/icons/bluetooth_icon.png"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                            }

                            Text {
                                id: bluetooth_text
                                text: qsTr("蓝牙")
                                color: "black"
                                font.pixelSize: 30
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: bluetooth_icon.right
                                anchors.leftMargin: 20
                                font.family: "Montserrat Light"
                            }
                        }
                        Rectangle {
                            width: parent.width - 40
                            anchors.horizontalCenter: parent.horizontalCenter
                            height: 1
                            color: "#c6c6c8"
                        }
                        Item {
                            width: other_Rect.width
                            height: item_height

                            Image {
                                id: connet_icon
                                width: 50
                                height: 50
                                source: "qrc:/icons/connet_icon.png"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                            }

                            Text {
                                id: connet_text
                                text: qsTr("个人热点")
                                color: "black"
                                font.pixelSize: 30
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: connet_icon.right
                                anchors.leftMargin: 20
                                font.family: "Montserrat Light"
                            }
                        }


                        Rectangle {
                            width: parent.width - 40
                            anchors.horizontalCenter: parent.horizontalCenter
                            height: 1
                            color: "#c6c6c8"
                        }
                        Item {
                            width: other_Rect.width
                            height: other_Rect.height / 4

                            Image {
                                id: brightness_icon
                                width: 50
                                height: 50
                                source: "qrc:/icons/brightness_icon.png"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                            }

                            Text {
                                id: brightness_text
                                text: qsTr("显示与音量")
                                color: "black"
                                font.pixelSize: 30
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: brightness_icon.right
                                anchors.leftMargin: 20
                                font.family: "Montserrat Light"
                            }

                            MouseArea {
                                id: brightnessVolume_mouseArea
                                anchors.fill: parent
                                onClicked: settings_swipeView.currentIndex = 2
                            }

                            Text {
                                id: brightnessVolume_text
                                text: qsTr("亮度与音量")
                                color: "#8a8a8d"
                                font.pixelSize: 25
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: next2.left
                                anchors.rightMargin: 20
                                font.family: "Montserrat Light"
                            }

                            Image {
                                id: next2
                                source: "qrc:/icons/item_next.png"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: 10
                                opacity: brightnessVolume_mouseArea.pressed ? 0.8 : 1
                            }
                        }

                        Rectangle {
                            width: parent.width - 40
                            anchors.horizontalCenter: parent.horizontalCenter
                            height: 1
                            color: "#c6c6c8"
                        }
                        Item {
                            width: other_Rect.width
                            height: item_height

                            Rectangle {
                                anchors.fill: parent
                                color: reboot_mouseAra.pressed ? "#f0f0f0" : "white"
                            }

                            Text {
                                id: reboot_text
                                text: qsTr("重启")
                                color: "black"
                                font.pixelSize: 30
                                anchors.centerIn: parent
                                font.family: "Montserrat Light"
                            }

                            MouseArea {
                                id: reboot_mouseAra
                                anchors.fill: parent
                                onClicked: {
                                    bye.visible = true
                                    byeText.text = "Reboot!"
                                    exittimer.setTimeout(function() { board.systemReboot() }, 1000)
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width - 40
                            anchors.horizontalCenter: parent.horizontalCenter
                            height: 1
                            color: "#c6c6c8"
                        }
                        Item {
                            width: other_Rect.width
                            height: item_height

                            Rectangle {
                                anchors.fill: parent
                                color: exit_mouseAra.pressed ? "#f0f0f0" : "white"
                            }

                            Text {
                                id: exit_text
                                text: qsTr("退出")
                                color: "black"
                                font.pixelSize: 30
                                anchors.centerIn: parent
                                font.family: "Montserrat Light"
                            }

                            MouseArea {
                                id: exit_mouseAra
                                anchors.fill: parent
                                onClicked: {
                                    bye.visible = true
                                    exittimer.setTimeout(function() { Qt.quit() }, 1000)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Timer {
        id: exittimer
        function setTimeout(cb, delayTime) {
            exittimer.interval = delayTime;
            exittimer.repeat = false
            exittimer.triggered.connect(cb);
            exittimer.triggered.connect(function release () {
                exittimer.triggered.disconnect(cb)
                exittimer.triggered.disconnect(release)
            })
            exittimer.start()
        }
    }

    Rectangle {
        id: bye
        anchors.fill: parent
        color: "black"
        visible: false
        z: 200
        Text {
            id: byeText
            text: qsTr("GoodBye!")
            color: "white"
            font.pixelSize: 100
            anchors.centerIn: parent
            font.family: "Montserrat Bold"
        }
    }
}
