/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   QDesktop
* @brief         FileListView.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-10-27
*******************************************************************/
import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
    Text {
        id: appTitle
        text: qsTr("备忘录")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 40
        font.pixelSize: 30
    }

    ListView  {
        id: fileListView
        visible: true
        anchors.top: appTitle.bottom
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 130
        width: parent.width
        orientation:ListView.Vertical
        clip: true
        model: notepadModel
        onCurrentIndexChanged: {
            notepadModel.currentIndex = currentIndex
        }
        delegate: Rectangle {
            id: itembg
            width: parent.width
            height: 80
            color: mouseArea.pressed ? "#88d7c388" : "transparent"
            Behavior on color { PropertyAnimation { duration: 200; easing.type: Easing.InOutBack } }
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    fileListView.currentIndex = index
                    fileReadWrite.openFile(path)
                    notepad_swipeView.currentIndex = 1
                }

                onPressAndHold: {
                    fileListView.currentIndex = index
                    removeFile_drawer_bottom.open()
                }
            }

            Rectangle {
                anchors.top: parent.top
                width: parent.width - 20
                anchors.right: parent.right
                height: 1
                color: "#c6c6c8"
                visible: index == 0
            }

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width - 20
                anchors.right: parent.right
                height: 1
                color: "#c6c6c8"
            }

            Text {
                id: content_text
                width: parent.width
                text:  content
                elide: Text.ElideRight
                font.pixelSize: 25
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.bottom: parent.verticalCenter
                color: "black"
            }

            Text {
                id: lastUpdate_text
                width: parent.width
                text: lastModified
                elide: Text.ElideRight
                font.pixelSize: 25
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.top: parent.verticalCenter
                color: "#c6c6c8"
            }
        }
    }

    Button {
        id: editor_bt
        anchors.top: fileListView.bottom
        anchors.right: parent.right
        anchors.rightMargin: 10
        opacity: editor_bt.pressed ? 0.5 : 1.0
        background: Image {
            width: 50
            height: 50
            source: "qrc:/icons/pen_icon.png"
        }
        onClicked:  {
            fileReadWrite.newFile(appCurrtentDir +  "/src/txt/" + Qt.formatDateTime(new Date(), "AP-hh-mm-ss" ) + ".txt")
            notepad_swipeView.currentIndex = 1
        }
    }
}
