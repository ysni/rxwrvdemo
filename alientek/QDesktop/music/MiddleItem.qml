/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   desktop
* @brief         Middle_Item.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-09-13
*******************************************************************/

import QtQuick 2.0

Item {
    Text {
        id: music_list_text
        text: qsTr("推荐歌单")
        font.pixelSize: 20
        font.family: "Montserrat Bold"
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: parent.top
        color: "black"
    }
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
        function getIcon(index, id) {
            var data = [
                        ["qrc:/images/music_album_1.png"],
                        ["qrc:/images/music_album_2.png"],
                        ["qrc:/images/music_album_3.png"],
                        ["qrc:/images/music_album_4.png"],
                        ["qrc:/images/music_album_5.png"],
                        ["qrc:/images/music_album_6.png"],
                        ["qrc:/images/music_album_7.png"],
                        ["qrc:/images/music_album_8.png"],
                    ]
            return data[index][0];
        }

        function getAppName(index, id) {
            var data = [
                        ["Kiss the rain"],
                        ["DJ Music"],
                        ["Hot Music"],
                        ["Light Music"],
                        ["Vibrate MC"],
                        ["Cover Music"],
                        ["90 Music"],
                        ["80 Music"],
                    ]
            return data[index][0];
        }

        function getUnderAppName(index, id) {
            var data = [
                        ["Loc Music"],
                        ["FM Music"],
                        ["Love Music"],
                        ["BGM Music"],
                        ["EDM Music"],
                        ["DJ Music"],
                        ["FASHION Music"],
                        ["CLASSICAL Music"],
                    ]
            return data[index][0];
        }

        function getVieCounts(index, id) {
            var data = [
                        ["11w"],
                        ["15w"],
                        ["20w"],
                        ["9w"],
                        ["30w"],
                        ["100w"],
                        ["8000w"],
                        ["500w"],
                    ]
            return data[index][0];
        }
    }

    GridView {
        id: item_listView
        visible: true
        //orientation: ListView.Horizontal
        anchors.top: music_list_text.bottom
        width: parent.width
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        interactive: true
        clip: true
        model: model1
        cellWidth: item_listView.width / 4
        cellHeight: item_listView.height / 2
        delegate: Rectangle {
            id: listView_delegate
            width: item_listView.cellWidth
            height: item_listView.cellHeight
            color: "transparent"
            Image {
                id: image1
                source: item_listView.model.getIcon(index, 0)
                anchors.centerIn: parent
                width: parent.width - 10
                height: parent.height - 10
                fillMode: Image.PreserveAspectFit
                Rectangle {
                    anchors.bottom: image1.bottom
                    anchors.right: image1.right
                    anchors.bottomMargin: 3
                    anchors.rightMargin: 25
                    color: "#55101010"
                    radius: 7.5
                    width: view_Counts.contentWidth
                    height: 15
                    Text {
                        id: view_Counts
                        anchors.centerIn: parent
                        text: qsTr(item_listView.model.getVieCounts(index, 0))
                        color: "white"
                        font.family: "Montserrat Light"
                        font.pixelSize: 12
                        font.bold: true
                    }
                }
                Image {
                    anchors.fill: parent
                    source: "qrc:/images/music_album_mask.png"
                }
            }

            Text {
                id: appName1
                anchors.top: listView_delegate.top
                anchors.topMargin: 2
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr(item_listView.model.getAppName(index, 0))
                color: "white"
                font.family: "Montserrat Light"
                font.pixelSize: 18
                font.bold: true
            }

            Text {
                id: underAppName1
                anchors.top: appName1.bottom
                anchors.topMargin: -5
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr(item_listView.model.getUnderAppName(index, 0))
                color: "#dddddd"
                font.family: "Montserrat Light"
                font.pixelSize: 12
            }


            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    image1.opacity = 1
                }

                onEntered: {
                    image1.opacity = 0.8
                }

                onPressed:{
                    image1.opacity = 0.8
                }

                onReleased:{
                    image1.opacity = 1
                }

                onExited: {
                    image1.opacity = 1
                }
            }
        }
    }

}
