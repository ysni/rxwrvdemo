/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   myDevices
* @brief         MyDevice.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-10-08
*******************************************************************/
import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
    id: myDevice
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
        }
        onClicked: settings_swipeView.currentIndex = 0

        Text {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("设置")
            font.underline: true
            font.family: "Montserrat Light"
            color: "#0b62f6"
            font.pixelSize: 20
        }
    }


    Item {
        anchors.fill: parent

        Text {
            id: myDevice_Top_center_Text
            text: qsTr("关于本机")
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
            anchors.bottom: item2.top
            width: app_settings.width
            height: 1
            color: "#c6c6c8"
            z: 5
            visible: myDevice_Top_center_Text.opacity === 1.0
        }

        Item {
            id: item2
            anchors.top: parent.top
            anchors.topMargin: 80
            width: parent.width
            anchors.bottom: parent.bottom

            Flickable {
                id: myDevices_flickable
                anchors.fill: parent
                contentHeight: app_settings.height >= 480 ? parent.height + 150 : parent.height + 250
                contentWidth: parent.width
                clip: true

                onFlickEnded:  {
                    if (contentY >= myDevice_Text.height / 2) {
                        myDevice_Top_center_Text.opacity = 1.0
                        myDevice_Text.opacity = 0.0
                    } else if (contentY <= 20) {
                        myDevice_Top_center_Text.opacity = 0.0
                        myDevice_Text.opacity = 1.0
                    }
                }
                Text {
                    id: myDevice_Text
                    text: qsTr("关于本机")
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
                    anchors.top: myDevice_Text.bottom
                    spacing: 40
                    Rectangle {
                        id: soft_Rect
                        clip: true
                        width: myDevice.width
                        height: 325
                        color: "white"
                        Column {
                            Item {
                                width: soft_Rect.width
                                height: soft_Rect.height / 5
                                Text {
                                    text: qsTr("名称")
                                    color: "black"
                                    font.pixelSize: 30
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 20
                                    font.family: "Montserrat Light"
                                }
                                Text {
                                    text: global_system_hostname
                                    color: "#8a8a8d"
                                    font.pixelSize: 25
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.right
                                    anchors.rightMargin: 20
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
                                width: soft_Rect.width
                                height: soft_Rect.height / 5
                                Text {
                                    text: qsTr("软件版本")
                                    color: "black"
                                    font.pixelSize: 30
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 20
                                    font.family: "Montserrat Light"
                                }

                                Text {
                                    text: qsTr("ATKOS 4.0.0 Power by 正点原子")
                                    color: "#8a8a8d"
                                    font.pixelSize: 25
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.right
                                    anchors.rightMargin: 20
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
                                width: soft_Rect.width
                                height: soft_Rect.height / 5
                                Text {
                                    text: qsTr("核心板版本")
                                    color: "black"
                                    font.pixelSize: 30
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 20
                                    font.family: "Montserrat Light"
                                }

                                Text {
                                    text: global_board_type ? "NAND" : "EMMC"
                                    color: "#8a8a8d"
                                    font.pixelSize: 25
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.right
                                    anchors.rightMargin: 20
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
                                width: soft_Rect.width
                                height: soft_Rect.height / 5
                                Text {
                                    text: qsTr("内核版本")
                                    color: "black"
                                    font.pixelSize: 30
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 20
                                    font.family: "Montserrat Light"
                                }

                                Text {
                                    text: global_linux_version
                                    color: "#8a8a8d"
                                    font.pixelSize: 25
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.right
                                    anchors.rightMargin: 20
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
                                width: soft_Rect.width
                                height: soft_Rect.height / 5
                                Text {
                                    text: qsTr("文件系统版本")
                                    color: "black"
                                    font.pixelSize: 30
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 20
                                    font.family: "Montserrat Light"
                                }

                                Text {
                                    text: global_file_system_version
                                    color: "#8a8a8d"
                                    font.pixelSize: 25
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.right
                                    anchors.rightMargin: 20
                                    font.family: "Montserrat Light"
                                }
                            }
                        }
                    }
                    Rectangle {
                        id: flash_Rect
                        clip: true
                        width: myDevice.width
                        height: 130
                        color: "white"
                        Column {
                            Item {
                                width: flash_Rect.width
                                height: flash_Rect.height / 2
                                Text {
                                    text: qsTr("存储容量")
                                    color: "black"
                                    font.pixelSize: 30
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 20
                                    font.family: "Montserrat Light"
                                }

                                Text {
                                    //text: global_board_type ? "512MB" : "8GB"
                                    text: "8GB"
                                    color: "#8a8a8d"
                                    font.pixelSize: 25
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.right
                                    anchors.rightMargin: 20
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
                                width: flash_Rect.width
                                height: flash_Rect.height / 2
                                Text {
                                    text: qsTr("运行内存")
                                    color: "black"
                                    font.pixelSize: 30
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 20
                                    font.family: "Montserrat Light"
                                }

                                Text {
                                    text: "2GB"
                                    color: "#8a8a8d"
                                    font.pixelSize: 25
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.right
                                    anchors.rightMargin: 20
                                    font.family: "Montserrat Light"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
