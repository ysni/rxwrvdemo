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

Item {
    id: app_photoview
    y: app_photoview.height
    x: 0
    opacity: 0
    property string currtenPhotoPath
    property string currtenPhotoName
    property real showPropertyChangeOpacity: 1
    property real showPropertyChangeX: 0
    property real showPropertyChangeY: 0
    property bool show: false

    state: ""
    states:[
        State {
            name: "show"
            PropertyChanges {
                target: app_photoview
                opacity: showPropertyChangeOpacity
                x: showPropertyChangeX
                y: showPropertyChangeY
            }
            when: !show
        }
    ]

    transitions: Transition {
        NumberAnimation{properties: "x,y"; easing.type: Easing.InOutQuad; duration: 0}
        NumberAnimation{properties: "opacity"; easing.type: Easing.InOutQuad; duration: 0}
    }

    PhotoListModel {
        id: photoListModel
        Component.onCompleted:  {
            //photoListModel.add(appCurrtentDir + "/src/images/");
        }
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        color: "#eff2f7"
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
            DisplayPhoto {visible: false}
            onCurrentIndexChanged : {
                photoSwipeView.currentItem.visible = true
                for (var i = 0; i < photoSwipeView.count; i++){
                    if (i !== photoSwipeView.currentIndex)
                        photoSwipeView.itemAt(i).visible = false
                }
            }
        }
    }

    Button {
        id: app_back_button
        anchors.top: parent.top
        anchors.topMargin: 40
        width: 80
        opacity: app_back_button.pressed ? 0.5 : 1.0
        visible: !global_photo_Check && photoSwipeView.currentIndex !== 1
        background: Image {
            id: back_image
            source: "qrc:/icons/back.png"
            width: 40
            fillMode: Image.PreserveAspectCrop
        }
        onClicked: {
            global_photo_Check = true
            global_appIndex = 1
        }

        Text {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("相机")
            font.family: "Montserrat Light"
            color: "#0b62f6"
            font.pixelSize: 20
            font.underline: true
        }
    }
}
