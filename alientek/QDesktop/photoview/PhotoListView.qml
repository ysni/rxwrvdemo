/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   photoview
* @brief         PhotoListView.qml
* @author        Deng Zhimao
* @email         1252699831@qq.com
* @date          2020-07-16
*******************************************************************/
import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.3

Item {
    Rectangle {
        id: photoListView_drawer_bottom
        width: parent.width
        height: parent.height - 80
        z: 10
        color: "#55101010"
        x: 0
        y: height
        Behavior on y { PropertyAnimation { duration: 250; easing.type: Easing.OutQuad } }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                photoListView_drawer_bottom.close()
            }
        }

        PhotoInfo {
            id: photoInfo
            z: 0
            anchors.fill: parent
        }

        function open() {
            photoListView_drawer_bottom.y = 0
        }

        function close() {
            photoListView_drawer_bottom.y = height

        }
    }

    Row {
        id: photoListView_row1
        anchors.top: parent.top
        anchors.topMargin: 40
        height: 40
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10

        RadioButton {
            id: local_album_bt
            checked: global_photo_Check
            width: 100
            height: 40
            opacity: local_album_bt.pressed ? 0.5 : 1.0
            contentItem:Text {
                font.pixelSize: 25
                text: qsTr("相册")
                font.family: "Montserrat Light"
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: local_album_bt.checked ? "#0b86fd" : "#101010"
                font.underline: true
            }
            indicator: Rectangle {
                width: 0
                height: 0
                color: "transparent"
            }

            function refresh() {
                photoListModel.add(appCurrtentDir + "/src/images/");
                if (photoListModel.dataCout() !== 0)
                    photoList.model = photoListModel
            }
            onClicked: {
                refresh()
            }

            onCheckedChanged: {
                if (checked)
                    refresh()
            }
        }

        RadioButton {
            id: camera_album_bt
            checked: !global_photo_Check
            width: 100
            height: 40
            opacity: camera_album_bt.pressed ? 0.5 : 1.0
            contentItem:Text {
                font.pixelSize: 25
                text: qsTr("照片")
                font.family: "Montserrat Light"
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: camera_album_bt.checked ? "#0b86fd" : "#101010"
                font.underline: true
            }
            indicator: Rectangle {
                width: 0
                height: 0
                color: "transparent"
            }

            function refresh() {
                photoListModel.add(appCurrtentDir + "/src/photos/");
                if (photoListModel.dataCout() !== 0)
                    photoList.model = photoListModel
            }
            onClicked: {
                refresh()
            }

            onCheckedChanged: {
                if (checked)
                    refresh()
            }
        }
    }

    GridView  {
        id: photoList
        anchors.top: photoListView_row1.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
        focus: true
        clip: true
        interactive: true
        cellWidth: photoList.width / 4
        cellHeight: photoList.width / 4
        snapMode: GridView.SnapOneRow
        model: photoListModel
        delegate: Rectangle {
            id: itembg
            width: photoList.cellWidth
            height: photoList.cellWidth
            color: "transparent"
            Image {
                id: photo
                source: path
                anchors.centerIn: parent
                width: parent.height - 10
                height: parent.height - 20
                smooth: true
                fillMode: Image.PreserveAspectCrop
                anchors.verticalCenter: parent.verticalCenter

                MouseArea {
                    id:mouserArea
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: {
                        photoListModel.currentIndex = index
                        photoSwipeView.currentIndex = 1
                        currtenPhotoPath = photoListModel.getcurrentPath()
                    }
                }
            }

            RoundButton {
                id: more_info_bt
                width: 40
                height: 40
                anchors.bottom: photo.bottom
                anchors.bottomMargin: 5
                anchors.right: photo.right
                anchors.rightMargin: 5
                background: Rectangle {
                    color: more_info_bt.pressed ? "#55101010" : "#88101010"
                    anchors.fill: parent
                    radius: 20
                    Text {
                        id: more_info_text
                        text: qsTr("...")
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: -6
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 25
                        color: "white"
                    }
                }

                onClicked: {
                    photoListModel .currentIndex = index
                    currtenPhotoName = title
                    currtenPhotoPath = photoListModel.getcurrentPath()
                    currtenPhotoPath = currtenPhotoPath.substring(8)
                    photoListView_drawer_bottom.open()
                }
            }
        }
    }
}
