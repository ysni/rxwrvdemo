/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   recorder
* @brief         RecordListView.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-19
* @link          www.opendev.com
*******************************************************************/
import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
    property int timeCnt: 0
    Text {
        id: appTitle
        text: qsTr("录音机")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 40
        font.pixelSize: 30
        font.family: "Montserrat Regular"
    }

    ListView  {
        id: fileListView
        visible: true
        anchors.top: appTitle.bottom
        anchors.topMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 220
        width: parent.width
        orientation:ListView.Vertical
        clip: true
        model: recordModel

        onCurrentIndexChanged: {
            recordModel.currentIndex = currentIndex
        }

        onCountChanged: {
            //musicPlayer.stop()
            fileListView.currentIndex = -1
        }

        Component.onCompleted:  fileListView.currentIndex = -1

        ScrollBar.vertical: ScrollBar {
            id: scrollBar
            width: 20
            background: Rectangle {color: "transparent"}
            onActiveChanged: {
                active = true;
            }
            Component.onCompleted: {
                scrollBar.active = true;
            }
            contentItem: Rectangle{
                implicitWidth: 20
                implicitHeight: 100
                radius: 10
                //color: scrollBar.hovered ? "#88101010" : "#30101010"
                color: scrollBar.pressed ? "#88101010" : "#30101010"
            }
        }

        delegate: Rectangle {
            id: itembg
            width: parent.width
            height: fileListView.currentIndex === index ?  250 : 120
            color: mouseArea.pressed ? "#88d7c388" : "transparent"
            Behavior on color { PropertyAnimation { duration: 200; easing.type: Easing.Linear } }
            Behavior on height { PropertyAnimation { duration: 200; easing.type: Easing.Linear } }
            MouseArea {
                id: mouseArea
                width: parent.width
                height: 80
                onClicked: {
                    if (fileListView.currentIndex !== index) {
                        fileListView.currentIndex = index
                        if (recordModel.currentIndex !== -1)
                            musicPlayer.source =  recordModel.getcurrentPath()
                        musicPlayer.play()
                    } else {
                        fileListView.currentIndex = -1
                        if (musicPlayer.hasAudio)
                            musicPlayer.stop()
                    }
                }

                onPressAndHold: {
                    fileListView.currentIndex = index
                    removeFile_drawer_bottom.open()
                }
            }

            Rectangle {
                anchors.top: parent.top
                width: parent.width - 20
                anchors.horizontalCenter: parent.horizontalCenter
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
                font.pixelSize: 30
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.top: parent.top
                anchors.topMargin: 10
                color: "black"
                font.family: "Montserrat Regular"
            }

            Text {
                id: lastUpdate_text
                width: parent.width
                text: lastModified
                elide: Text.ElideRight
                font.pixelSize: 20
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.top: content_text.bottom
                anchors.topMargin: 10
                color: "#c6c6c8"
                font.family: "Montserrat Light"
            }

            RecordPlayPanel {
                id: playPanel
                visible: fileListView.currentIndex === index
                anchors.top: parent.verticalCenter
                anchors.topMargin: -10
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.left: parent.left
                height: 120
            }
        }
    }

    Timer {
        id: recordTimer
        repeat: true
        interval: 1000
        running: false
        onTriggered: {
            timeCnt += 1000
        }
    }

    function currentRecordTime(time){
        var sec = Math.floor(time / 1000);
        var hours = Math.floor(sec / 3600);
        var minutes = Math.floor((sec - hours * 3600) / 60);
        var seconds = sec - hours * 3600 - minutes * 60;
        var hh, mm, ss;
        if(hours.toString().length < 2)
            hh = "0" + hours.toString();
        else
            hh = hours.toString();
        if(minutes.toString().length < 2)
            mm="0" + minutes.toString();
        else
            mm = minutes.toString();
        if(seconds.toString().length < 2)
            ss = "0" + seconds.toString();
        else
            ss = seconds.toString();
        return /*hh+":"*/ + mm + ":" + ss
    }

    Rectangle {
        id: panelRect
        height: 140
        width: parent.width
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 80
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#f2f1f6"
        Behavior on height { PropertyAnimation { duration: 300; easing.type: Easing.Linear } }

        Text {
            id: timerCntText
            text: qsTr(currentRecordTime(timeCnt))
            color: "black"
            font.pixelSize: 50
            font.family: "Montserrat Bold"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 30
            opacity: 0
            Behavior on opacity { PropertyAnimation { duration: 300; easing.type: Easing.Linear } }
        }
        Item {
            id: item1
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter

            width: 80
            height: 80
            RoundButton {
                id: roundButton1
                anchors.centerIn: parent
                width:  80
                height: 80
                checkable: true
                checked: false
                background: Rectangle {
                    anchors.fill: parent
                    radius:  40
                    border.color: "#a19ca4"
                    border.width: 6
                    color: "transparent"
                    Rectangle {
                        id: roundRect
                        width: 60
                        height: 60
                        color: "#fd3b31"
                        radius: 30
                        anchors.centerIn: parent
                        Behavior on width { PropertyAnimation { duration: 200; easing.type: Easing.Linear } }
                        Behavior on height { PropertyAnimation { duration: 200; easing.type: Easing.Linear } }
                        Behavior on radius { PropertyAnimation { duration: 200; easing.type: Easing.Linear } }
                    }
                }

                onClicked: {
                    if (roundButton1.checked) {
                        musicPlayer.stop()
                        recordModel.currentIndex = -1
                        panelRect.height = 250
                        roundRect.width = 30
                        roundRect.height = 30
                        roundRect.radius = 5
                        timerCntText.opacity = 1
                        recordTimer.start()
                    } else {
                        musicPlayer.stop()
                        panelRect.height = 140
                        roundRect.width = 60
                        roundRect.height = 60
                        roundRect.radius = 30
                        timerCntText.opacity = 0
                        recordTimer.stop()
                        timeCnt = 0
                    }
                    recordControl.setRecordStart(roundButton1.checked)
                }
            }
        }
    }
}
