/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   photoview
* @brief         Photoview.qml
* @author        Deng Zhimao
* @email         1252699831@qq.com
* @date          2020-07-16
*******************************************************************/
import QtQuick 2.0
import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.5
import photoListModel 2.0

Window {
    property string currtenPhotoPath
    property string currtenPhotoName
    property bool global_photo_Check: true
    id: photoview
    width: 800
    height:  480
    visible: true

    PhotoListModel {
        id: photoListModel
        Component.onCompleted:  {
            photoListModel.add(appCurrtentDir + "/src/images/");
        }
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        color: "#dddddd"
    }
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        SwipeView {
            id: photoSwipeView
            anchors.fill: parent
            interactive: false
            orientation: ListView.Horizontal
            Component.onCompleted: {
                contentItem.highlightMoveDuration = 500

            }
            PhotoListView {}
            DisplayPhoto {}
            onCurrentIndexChanged : {
                photoSwipeView.currentItem.visible = true
                for (var i = 0; i < photoSwipeView.count; i++){
                    if (i !== photoSwipeView.currentIndex)
                        photoSwipeView.itemAt(i).visible = false
                }
            }
        }
    }
}
