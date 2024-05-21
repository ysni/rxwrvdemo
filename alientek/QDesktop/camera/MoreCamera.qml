import QtQuick 2.0
import QtQuick.Controls 2.5

Item {
    id: more
    anchors.fill: parent

    Timer {
        id: choseCameraTimer
        function setTimeout(cb, delayTime) {
            choseCameraTimer.interval = delayTime;
            choseCameraTimer.repeat = false
            choseCameraTimer.triggered.connect(cb);
            choseCameraTimer.triggered.connect(function release () {
                choseCameraTimer.triggered.disconnect(cb)
                choseCameraTimer.triggered.disconnect(release)
            })
            choseCameraTimer.start()
        }
    }

    Column {
        id: column1
        width: parent.width - 20
        //height: parent.height / 3 * 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 80
        spacing: 10
        Rectangle {
            id: rectBg1
            color: "#f0f0f0"
            radius: more.height / 36
            width: parent.width
            height: more.height / 10 * 2
            Column {
                id: app_fileView_row1
                anchors.centerIn: parent
                spacing: 0
                RadioButton {
                    id: camera1
                    checked: true
                    height: rectBg1.height / 2
                    width: rectBg1.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    indicator: Rectangle {
                        anchors.fill: parent
                        radius: rectBg1.radius
                        color: parent.pressed ? "#dddddd" : "transparent"
                        Rectangle {
                            width: parent.width
                            height: parent.height / 2
                            anchors.bottom: parent.bottom
                            color: camera1.pressed ? "#dddddd" : "transparent"
                        }
                        Text {
                            font.pixelSize: 30
                            text: qsTr("摄像头0(CSI0)")
                            font.family: "Montserrat Light"
                            anchors.centerIn: parent
                            color: camera1.checked? "#007aff" : "#8e8e93"
                        }
                    }
                    onCheckedChanged: {
                        camera_dawer_bottom.close()
                        if (camera1.checked) {
                            cameraInfoText.text = "正在切换摄像头0";
                            cameraInfo.visible = true;
                            choseCameraTimer.setTimeout(function() { cameraItem.choseCamera(0)}, 300)
                        }
                    }
                }

                Rectangle {
                    width: column1.width
                    height: 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#d2d3d5"
                }

                //                RadioButton {
                //                    id: camera2
                //                    checked: false
                //                    width: rectBg1.width
                //                    anchors.horizontalCenter: parent.horizontalCenter
                //                    height: rectBg1.height / 3
                //                    indicator: Rectangle {
                //                        anchors.fill: parent
                //                        color: parent.pressed ? "#dddddd" : "transparent"
                //                        Text {
                //                            font.pixelSize: 30
                //                            text: qsTr("摄像头2")
                //                            font.family: "Montserrat Light"
                //                            anchors.centerIn: parent
                //                            color: camera2.checked? "#007aff" : "#8e8e93"
                //                        }
                //                    }
                //                    onCheckedChanged: {
                //                        if (camera2.checked)
                //                            cameraItem.choseCamera(1)
                //                    }
                //                }

                Rectangle {
                    width: column1.width
                    height: 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#d2d3d5"
                }

                RadioButton {
                    id: camera3
                    checked: false
                    width: rectBg1.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: rectBg1.height / 2
                    indicator: Rectangle {
                        anchors.fill: parent
                        radius: rectBg1.radius
                        color: parent.pressed ? "#dddddd" : "transparent"
                        Rectangle {
                            width: parent.width
                            height: parent.height / 2
                            anchors.top: parent.top
                            color: camera3.pressed ? "#dddddd" : "transparent"
                        }
                        Text {
                            font.pixelSize: 30
                            text: qsTr("摄像头1(CSI1)")
                            font.family: "Montserrat Light"
                            anchors.centerIn: parent
                            color: camera3.checked? "#007aff" : "#8e8e93"
                        }
                    }
                    onCheckedChanged: {
                        camera_dawer_bottom.close()
                        cameraInfoText.text = "正在切换摄像头1";
                        cameraInfo.visible = true;
                        if (camera3.checked)
                            choseCameraTimer.setTimeout(function() { cameraItem.choseCamera(1) }, 300)
                    }
                }
            }
        }
        Item  {
            width: parent.width
            height: more.height / 10
            Button {
                anchors.fill: parent
                background: Rectangle {
                    anchors.fill: parent
                    color: parent.pressed ? "#dddddd" : "white"
                    radius: height / 5
                    Text {
                        text: qsTr("完成")
                        font.family: "Montserrat Light"
                        anchors.centerIn: parent
                        color: "#007aff"
                        font.pixelSize: 30
                        font.bold: true
                    }
                }
                onClicked: {
                    camera_dawer_bottom.close()
                }
            }
        }
    }
}
