/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   recorder
* @brief         RecordDelete.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-19
* @link          www.opendev.com
*******************************************************************/
import QtQuick 2.0
import QtQuick.Controls 2.5

Item {
    id: file

    Column {
        id: column1
        width: parent.width - 20
        //height: parent.height / 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 80
        spacing: 10
        Rectangle {
            id: rectBg1
            color: "#f0f0f0"
            radius: height / 12
            width: parent.width
            height: file.height / 10 * 2
            Column {
                id: app_fileView_row1
                anchors.centerIn: parent
                spacing: 0
                Item {
                    height: rectBg1.height / 2 + 10
                    width: rectBg1.width
                    Text {
                        color: "#8e8e93"
                        font.family: "Montserrat Light"
                        font.pixelSize: 30
                        text: qsTr("您要将此录音移除吗？")
                        anchors.centerIn: parent
                    }
                }
                Rectangle {
                    width: column1.width
                    height: 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#d2d3d5"
                }

                Button {
                    id: delete_bt
                    checked: true
                    height: rectBg1.height / 2 - 11
                    width: rectBg1.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    background: Rectangle {
                        anchors.fill: parent
                        radius: rectBg1.radius
                        color: parent.pressed ? "#dddddd" : "transparent"
                        Rectangle {
                            width: parent.width
                            height: parent.height / 2
                            anchors.top: parent.top
                            color: delete_bt.pressed ? "#dddddd" : "transparent"
                        }
                        Text {
                            font.pixelSize: 30
                            text: qsTr("删除")
                            font.family: "Montserrat Light"
                            anchors.centerIn: parent
                            color: "#ff3b30"
                        }
                    }
                    onClicked: {
                        musicPlayer.stop()
                        recordModel.removeOne(recordModel.currentIndex)
                        removeFile_drawer_bottom.close()
                    }
                }
            }
        }
        Item  {
            width: parent.width
            //height: column1.height - rectBg1.height - 20
            height: file.height / 10
            Button {
                anchors.fill: parent
                background: Rectangle {
                    anchors.fill: parent
                    color: parent.pressed ? "#dddddd" : "white"
                    radius: height / 5
                    Text {
                        text: qsTr("取消")
                        font.family: "Montserrat Light"
                        anchors.centerIn: parent
                        color: "#007aff"
                        font.pixelSize: 30
                        font.bold: true
                    }
                }
                onClicked: {
                    removeFile_drawer_bottom.close()
                }
            }
        }
    }
}
