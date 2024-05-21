/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   QDesktop
* @brief         Page2.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-10-18
*******************************************************************/
import QtQuick 2.0
import QtQuick.Controls 2.5

Item {
    ListModel {
        id: model1
        ListElement {name: ""}
        ListElement {name: ""}
        ListElement {name: ""}
        function getIcon(index, id) {
            var data = [
                        ["qrc:/icons/file_app_icon.png"],
                        ["qrc:/icons/notepad_app_icon.png"],
                        ["qrc:/icons/calculator_app_icon.png"],
                    ]
            return data[index][0];
        }

        function getAppName(index, id) {
            var data = [
                        ["文件"],
                        ["备忘录"],
                        ["计算器"],
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
                id: appName2
                text: qsTr(item_gridView.model.getAppName(index, 0))
                color: "white"
                font.family: "Montserrat Light"
                font.pixelSize: 20
            }
        }
    }

    id: page2
    Item {
        id: app_item_control2
        width: parent.width
        height: parent.height
        x: 0
        y: 0
        opacity: 1
        Behavior on opacity { PropertyAnimation { duration: 0; easing.type: Easing.InOutBack } }
        Behavior on y { PropertyAnimation { duration: 0; easing.type: Easing.InOutBack } }
        //        onVisibleChanged: {
        //            if (main_swipeView.currentIndex === 1) {
        //                if (visible) {
        //                    app_item_control2.y = 0
        //                    app_item_control2.opacity = 1

        //                } else {
        //                    app_item_control2.y = - page2.height
        //                    app_item_control2.opacity = 0
        //                }
        //            }
        //        }
        Item {
            id: item2
            anchors.fill: parent

            GridView {
                id: item_gridView
                visible: true
                anchors.top: parent.top
                anchors.topMargin: 100
                anchors.bottom: parent.bottom
                width: parent.width
                interactive: false
                currentIndex: -1
                clip: true
                snapMode: ListView.SnapOneItem
                cellWidth: item_gridView.width / 4
                cellHeight: item_gridView.height / 6
                model: model1
                delegate: item_gridView_delegate
                onCurrentIndexChanged: {
                    if (currentIndex == -1)
                        return;
                    global_appIndex = currentIndex + 11
                    item_gridView.currentIndex = -1
                }
            }
        }
    }
}
