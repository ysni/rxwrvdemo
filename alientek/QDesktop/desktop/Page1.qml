/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   QDesktop
* @brief         Page1.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-08-31
*******************************************************************/
import QtQuick 2.0
import QtQuick.Controls 2.5

Item {
    property int rect_width: root_width / 720 * 280
    property int rect_height: root_width / 720 * 120
    property int rect_radius: root_width / 720 * 20
    property int rect_spacing: root_width / 720 * 80

    ListModel {
        id: model1
        ListElement {name: ""}
        ListElement {name: ""}
        ListElement {name: ""}
        ListElement {name: ""}
        ListElement {name: ""}
        ListElement {name: ""}
        ListElement {name: ""}
        ListElement {name: ""}
        ListElement {name: ""}
        ListElement {name: ""}
        ListElement {name: ""}
        function getIcon(index, id) {
            var data = [
                        ["qrc:/icons/music_app_icon.png"],
                        ["qrc:/icons/camera_app_icon.png"],
                        ["qrc:/icons/photos_app_icon.png"],
                        ["qrc:/icons/recorder_app_icon.png"],
                        ["qrc:/icons/settings_app_icon.png"],
                        ["qrc:/icons/player_app_icon.png"],
                        ["qrc:/icons/cardvr_app_icon.png"],
                        ["qrc:/icons/live555_app_icon.png"],
                        ["qrc:/icons/objectrecognition_app_icon.png"],
                        ["qrc:/icons/facedetection_app_icon.png"],
                        ["qrc:/icons/factorytest_app_icon.png"],
                    ]
            return data[index][0];
        }

        function getAppName(index, id) {
            var data = [
                        ["音乐"],
                        ["相机"],
                        ["照片"],
                        ["录音"],
                        ["设置"],
                        ["视频解码"],
                        ["行车记录仪"],
                        ["live555\n推流"],
                        ["物体识别\nSSD"],
                        ["人脸检测"],
                        ["Factory\n测试"],
                    ]
            return data[index][0];
        }

        function geBbgColor(index, id) {
            var data = [
                        ["#13507c"],
                        ["#352867"],
                        ["#009e96"],
                        ["#3994d3"],
                    ]
            return data[index][0];
        }
    }
    Component {
        id: item_gridView_delegate
        Rectangle {
            width: item_gridView.cellWidth
            height: item_gridView.cellHeight
            color: "transparent"
            Rectangle {
                id: app_Rect
                width: 120
                height: 120
                color: "transparent"
                anchors.top: parent.top
                anchors.topMargin: -10
                anchors.horizontalCenter: parent.horizontalCenter
                opacity: mouseArea.pressed ? 0.8 : 1.0
                Image {
                    id: appIcon1
                    source: item_gridView.model.getIcon(index, 0)
                    anchors.fill: parent
                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        onClicked: item_gridView.currentIndex = index
                    }
                }
            }
            Text {
                anchors.top: app_Rect.bottom
                anchors.topMargin: -15
                visible: true
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                id: appName2
                text: qsTr(item_gridView.model.getAppName(index, 0))
                color: "white"
                font.family: "Montserrat Light"
                font.pixelSize: 20
            }
        }
    }

    ListModel {
        id: model2
        ListElement {name: ""}
        ListElement {name: ""}
        ListElement {name: ""}
        ListElement {name: ""}
        function getIcon(index, id) {
            var data = [
                        ["qrc:/icons/music_app_icon.png"],
                        ["qrc:/icons/photos_app_icon.png"],
                        ["qrc:/icons/weather_app_icon.png"],
                        ["qrc:/icons/camera_app_icon.png"],
                    ]
            return data[index][0];
        }

        function getAppName(index, id) {
            var data = [
                        ["音乐"],
                        ["相册"],
                        ["天气"],
                        ["相机"],
                    ]
            return data[index][0];
        }

        function geBbgColor(index, id) {
            var data = [
                        ["#13507c"],
                        ["#352867"],
                        ["#009e96"],
                        ["#3994d3"],
                    ]
            return data[index][0];
        }
    }
    Component {
        id: item_listView_delegate
        Rectangle {
            width: 120
            height: item_listView.height
            color: "transparent"
            opacity: mouseArea.pressed ? 0.8 : 1.0
            Rectangle {
                id: app_Rect
                width: 120
                height: 120
                color: "transparent"
                anchors.centerIn: parent
                Image {
                    id: appIcon1
                    source: item_listView.model.getIcon(index, 0)
                    anchors.fill: parent
                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        onClicked: item_listView.currentIndex = index
                    }
                }
            }
            Text {
                anchors.top: app_Rect.bottom
                anchors.topMargin: - 15
                visible: false
                anchors.horizontalCenter: parent.horizontalCenter
                id: appName2
                text: qsTr(item_listView.model.getAppName(index, 0))
                color: "white"
                font.family: "Montserrat Light"
                font.pixelSize: 20
            }
        }
    }


    id: page1
    Item {
        id: app_item_control1
        width: parent.width
        height: parent.height
        x: 0
        y: 0
        opacity: 1
        Behavior on opacity { PropertyAnimation { duration: 0; easing.type: Easing.InOutBack } }
        Behavior on y { PropertyAnimation { duration: 0; easing.type: Easing.InOutBack } }
        //        onVisibleChanged: {
        //            if (main_swipeView.currentIndex === 0) {
        //                if (visible) {
        //                    app_item_control1.y = 0
        //                    app_item_control1.opacity = 1

        //                } else {
        //                    app_item_control1.y = -page1.height
        //                    app_item_control1.opacity = 0
        //                }
        //            }
        //        }

        Item {
            id: item1
            anchors.fill: parent
            Column {
                id: colum1
                anchors.top: parent.top
                anchors.bottom: botton_app_Item_parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 100
                spacing: 64
                width: parent.width
                Row {
                    id: row1
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: rect_spacing
                    Item {
                        width: rect_width
                        height: rect_width
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                system_time = "00:00"
                                timefromnetwork.updateTime()
                            }
                        }

                        Text {
                            id: time_text
                            text: system_time
                            color: time_display_color
                            font.family: "Montserrat Light"
                            font.pixelSize:  80
                            font.bold: true
                        }

                        Text {
                            id: date_text
                            anchors.top: time_text.bottom
                            text: system_date1
                            color: time_display_color
                            font.family: "Montserrat Light"
                            font.pixelSize:  15
                            font.bold: true
                            visible: true
                        }
                    }
                    Image {
                        width: rect_width
                        height: rect_width
                        source: "qrc:/images/gril.png"
                        Text {
                            text: qsTr("昔年今日")
                            color: "white"
                            font.family: "Montserrat Light"
                            font.pixelSize:  parent.width / 800 * 80
                            font.bold: true
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 40
                        }
                        Text {
                            text: qsTr("2021.05.20")
                            color: "white"
                            font.family: "Montserrat Light"
                            font.pixelSize:  parent.width / 800 * 50
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 20
                        }
                    }
                }
                GridView {
                    id: item_gridView
                    visible: true
                    width: parent.width
                    interactive: false
                    height: colum1.height - row1.height
                    currentIndex: -1
                    clip: true
                    snapMode: ListView.SnapOneItem
                    cellWidth: item_gridView.width / 4
                    cellHeight: item_gridView.height / (item_gridView.height / 180)
                    model: model1
                    delegate: item_gridView_delegate
                    onCurrentIndexChanged: {
                        if (currentIndex == -1)
                            return;
                        global_appIndex = currentIndex
                        item_gridView.currentIndex = -1
                    }
                }
            }

            Rectangle {
                id: botton_app_Item_parent
                width: parent.width - 48
                height: rect_height
                radius: 35
                //color: "#55f0f0f0"
                color: "transparent"
                visible: false
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30
                anchors.horizontalCenter: parent.horizontalCenter

                ListView {
                    id: item_listView
                    visible: true
                    anchors.centerIn: parent
                    height: parent.height
                    width: parent.width - 48
                    interactive: false
                    orientation: ListView.Horizontal
                    currentIndex: -1
                    clip: true
                    snapMode: ListView.SnapOneItem
                    model: model2
                    delegate: item_listView_delegate
                    spacing: 48
                    onCurrentIndexChanged: {
                        if (currentIndex == -1)
                            return;
                        global_appIndex = currentIndex
                        item_listView.currentIndex = -1
                    }
                }
            }
        }
    }
}
