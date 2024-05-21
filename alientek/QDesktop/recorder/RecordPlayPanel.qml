/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   recorder
* @brief         PlayPanel.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-19
* @link          www.opendev.com
*******************************************************************/
import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Dialogs 1.1

import QtMultimedia 5.0
import QtQuick 2.4

Item {

    Text{
        id: playPanel_start_time
        anchors.left:  musci_play_progress.left
        anchors.top: musci_play_progress.bottom
        anchors.topMargin: -15
        text: currentMusicTime(progress_value)
        color: "#b4b4b4"
        font.pixelSize: 15
        font.family: "Montserrat Light"
    }

    Text{
        id: playPanel_end_time
        anchors.right:  musci_play_progress.right
        anchors.rightMargin: 38
        anchors.top: musci_play_progress.bottom
        anchors.topMargin: -15
        anchors.verticalCenter: parent.verticalCenter
        text: currentMusicTime(progress_maximumValue)
        color: "#b4b4b4"
        font.pixelSize: 15
        font.family: "Montserrat Light"
    }

    function currentMusicTime(time){
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

    Button {
        id: btnplay
        anchors.top: musci_play_progress.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        width: 48
        height: 48
        checkable: true
        checked: musicPlayer.playbackState === Audio.PlayingState

        onClicked: {
            if (recordModel.musicCount === 0)
                return
            if (recordModel.currentIndex !== -1) {
                musicPlayer.source =  recordModel.getcurrentPath()
                musicPlayer.playbackState === Audio.PlayingState ? musicPlayer.pause() : musicPlayer.play()
            }
        }

        style: ButtonStyle {
            background: Image {
                id: imgplay
                source: musicPlayer.playbackState === Audio.PlayingState ? "qrc:/icons/recorder_btn_pause.png"
                                                                         : "qrc:/icons/recorder_btn_play.png"
                opacity: btnplay.pressed ? 0.7 : 1.0;
            }
        }
    }

    Button {
        id: btnbackward
        anchors.right: btnplay.left
        anchors.rightMargin: 64
        anchors.verticalCenter: btnplay.verticalCenter
        width: 40
        height: 40

        style: ButtonStyle {
            background: Image {
                source: "qrc:/icons/recorder_btn_backward.png"
                opacity: btnbackward.pressed ? 0.7 : 1.0;
            }
        }
    }

    Button {
        id: btnforward
        anchors.left: btnplay.right
        anchors.leftMargin: 64
        anchors.verticalCenter: btnplay.verticalCenter
        width: 40
        height: 40

        style: ButtonStyle {
            background: Image {
                source: "qrc:/icons/recorder_btn_forward.png"
                opacity: btnforward.pressed ? 0.7 : 1.0;
            }
        }
    }

    Button {
        id: btndelete
        anchors.right: musci_play_progress.right
        anchors.rightMargin: 40
        anchors.verticalCenter: btnplay.verticalCenter
        width: 40
        height: 40

        style: ButtonStyle {
            background: Image {
                source: "qrc:/icons/recorder_btn_delete.png"
                opacity: btndelete.pressed ? 0.7 : 1.0;
            }
        }

        onClicked: removeFile_drawer_bottom.open()
    }

    Button {
        id: btn_moreinfore
        width: 40
        height: 40
        anchors.left: musci_play_progress.left
        anchors.verticalCenter: btnplay.verticalCenter

        style: ButtonStyle {
            background: Image {
                source: "qrc:/icons/recorder_btn_items.png"
                opacity: btn_moreinfore.pressed ? 0.7 : 1.0;
            }
        }
        onClicked: moreInfoDialog.open()
    }

    Timer {
        interval: 2000
        id: silder_enable_timer
        repeat: false
        onTriggered: {
            musci_play_progress.enabled = true
        }
    }

    Slider {
        id: musci_play_progress
        anchors.left: parent.left
        anchors.leftMargin: 50
        anchors.right: parent.right
        anchors.rightMargin: 20 //
        anchors.top: parent.top
        updateValueWhileDragging: false
        maximumValue: musicPlayer.hasAudio ? progress_maximumValue : 0
        stepSize: 30
        property bool handled: false
        value: progress_value
        onPressedChanged: {
            handled = true;
            progress_pressed = musci_play_progress.pressed
            if (!pressed)
                musci_play_progress.enabled = false
            silder_enable_timer.start()
        }

        onValueChanged: {
            if (handled && musicPlayer.seekable) {
                musicPlayer.seek(value);
                musicPlayer.play();
                handled = false;
            }
        }
        style: SliderStyle {
            groove: Rectangle {
                width: control.width - 40
                height: 5
                radius: 2
                color: "#dddddd"
                Rectangle {
                    width: styleData.handlePosition - 20
                    height: 5
                    color: "#908f96"
                    radius: 2
                }
            }
            handle: Rectangle {
                width: 50
                height: 50
                color: "transparent"
                Rectangle {
                    width: 10
                    height: 10
                    radius: 5
                    color: "#908f96"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                }
            }
        }
    }
}
