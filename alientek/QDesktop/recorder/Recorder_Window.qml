/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   recorder
* @brief         Recorder_Window.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-19
* @link          www.opendev.com
*******************************************************************/
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.VirtualKeyboard 2.4
import QtQuick.VirtualKeyboard.Settings 1.2
import QtQuick.Controls 2.5
import QtMultimedia 5.0

import recordListModel 1.0
import recordControl 1.0

Window {
    id: app_Recorder
    visible: true
    width: 720
    height: 1280
    title: qsTr("app_Recorder")

    property bool progress_pressed:  false
    property int progress_maximumValue: 0
    property int progress_value: 0

    RecordListModel {
        id: recordModel
        onCurrentIndexChanged: {
            musicPlayer.source = getcurrentPath()
        }
        Component.onCompleted: recordModel.currentIndex = -1
    }

    Component.onCompleted: {
        recordModel.add(appCurrtentDir +  "/src/record")
    }

    Rectangle {
        anchors.fill: parent
        color: "#f7f7f7"
    }

    RecordListView {
        anchors.fill: parent
    }

    Rectangle {
        id: toste
        opacity: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 330
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - 100
        height: 100
        radius: 10
        //color: "#d7c388"
        color: "transparent"
        Text {
            id: tosteText
            font.pixelSize: 30
            font.family: "Montserrat Bold"
            anchors.centerIn: parent
            //color: "#fd3b31"
            color: "#d7c388"
        }
        Behavior on opacity { PropertyAnimation { duration: 3000; easing.type: Easing.Linear } }
        onOpacityChanged: {
            if (opacity === 1){
                opacity = 0
            }
        }
    }

    RecordControl {
        id: recordControl
        onRecordFinished: {
            if (mp3IsReady) {
                toste.opacity = 1
                tosteText.text = "录音文件:" + mp3FileName
                recordModel.add(appCurrtentDir +  "/src/record")
                console.log("reflash the list!")
            }
        }
    }

    Rectangle {
        id: removeFile_drawer_bottom
        width: parent.width
        height: parent.height
        z: 10
        color: "#55101010"
        x: 0
        y: height
        Behavior on y { PropertyAnimation { duration: 250; easing.type: Easing.OutQuad } }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                removeFile_drawer_bottom.close()
            }
        }

        RecordDelete {
            id: fileDelete
            anchors.fill: parent
        }

        function open() {
            removeFile_drawer_bottom.y = 0
        }

        function close() {
            removeFile_drawer_bottom.y = height

        }
    }

    Audio {
        id: musicPlayer
        source: ""
        volume: 1.0
        autoPlay: false
        onSourceChanged: {
            //console.log( musicPlayer.volume);
        }
        onPositionChanged: {
            progress_maximumValue = duration;
            if(!progress_pressed)
                progress_value = position
        }
        onPlaybackStateChanged: {
            switch (playbackState) {
            case Audio.PlayingState:
                break;
            case Audio.PausedState:
            case Audio.StoppedState:
                break;
            default:
                break;
            }
        }
        onStatusChanged: {
            switch (status) {
            case Audio.NoMedia:
                //console.log("status:nomedia");
                break;
            case Audio.Loading:
                //console.log("status:loading");
                break;
            case Audio.Loaded:
                //console.log("status:loaded");
                //playPanel.progress_maximumValue = duration
                progress_maximumValue = duration
                break;
            case Audio.Buffering:
                //console.log("status:buffering");
                break;
            case Audio.Stalled:
                //console.log("status:stalled");
                break;
            case Audio.Buffered:
                //console.log("status:buffered");
                break;
            case Audio.InvalidMedia:
                //console.log("status:invalid media");
                switch (error) {
                case Audio.FormatError:
                    console.log("需要安装解码器")
                    break;
                case Audio.ResourceError:
                    console.log("文件错误")
                    break;
                case Audio.NetworkError:
                    console.log("网络错误")
                    break;
                case Audio.AccessDenied:
                    console.log("权限不足")
                    break;
                case Audio.ServiceMissing:
                    console.log("无法启用多媒体服务")
                    break;
                }
                break;
            case Audio.EndOfMedia:
                //console.log("status:end of media");
                progress_value = 0
                break;
            }
        }
    }
    Rectangle {
        id: moreInfoDialog
        anchors.fill: parent
        visible: false
        color: "#55101010"

        function close() {
            moreInfoDialog.visible = false
        }

        function open() {
            moreInfoDialog.visible = true
        }

        MouseArea {
            anchors.fill: parent
            onClicked: moreInfoDialog.close()
        }
        Rectangle {
            id: center_Rect
            width: parent.width - 100
            height: 460
            color: "#f0f0f0"
            radius: 20
            anchors.centerIn: parent
            Text {
                anchors.top: parent.top
                height: parent.height / 10
                width: parent.width
                color: "black"
                font.pixelSize: 30
                font.family: "Montserrat Light"
                text: "详细信息"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
                wrapMode: Text.WordWrap
            }
            Text {
                anchors.centerIn: parent
                width: parent.width
                color: "black"
                font.pixelSize: 25
                font.family: "Montserrat Light"
                text: qsTr("采集率：16000\n声道：单声道\n格式：s16_le\n类型：MP3文件\n路径：" + recordModel.getStorepath() + "/src/record")
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }
            Rectangle {
                width: parent.width
                height: 1
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#d2d3d5"
                anchors.bottom: finish_button.top
            }
            Rectangle {
                width: parent.width
                height: 20
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: finish_button.top
                color: finish_button.pressed ?  "#dddddd" : "transparent"
            }
            Button {
                id: finish_button
                anchors.bottom: parent.bottom
                width: parent.width
                height: moreInfoDialog.height / 10
                background: Rectangle {
                    anchors.fill: parent
                    radius: center_Rect.radius
                    color: finish_button.pressed ?  "#dddddd" : "transparent"
                }

                Text {
                    id: finish_bt
                    font.pixelSize: 30
                    text: qsTr("完成")
                    font.family: "Montserrat Light"
                    anchors.centerIn: parent
                    color: "#007aff"
                }
                onClicked: moreInfoDialog.close()
            }
        }
    }
}
