/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   desktop
* @brief         PlayPanel.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-09-13
*******************************************************************/
import QtQuick 2.0
import dataModel 1.0
import QtQuick.Controls 2.5
import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Dialogs 1.1

import QtMultimedia 5.0
import QtQuick 2.4

Item {
    property bool btnplayChecked:  false
    property bool progress_pressed:  false
    property int progress_maximumValue: 0
    property int progress_value: 0
    property int music_loopMode: 2

    MouseArea {
        enabled: false
        id: playPanelMouseArea
        anchors.fill: parent
        onClicked: music_cd_dawer_bottom.open()
    }

    onProgress_maximumValueChanged:  {
        musci_play_progress.maximumValue = progress_maximumValue
    }

    onBtnplayCheckedChanged: {
        btnplay.checked = btnplayChecked
    }

    onProgress_valueChanged: {
        musci_play_progress.value = progress_value
    }

    Rectangle {
        anchors.fill: parent
        color: "white"
    }

    Text{
        id: playPanel_play_time
        anchors.right:  btnplay.left
        anchors.rightMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        text: currentMusicTime(progress_value) + "/" + currentMusicTime(progress_maximumValue)
        color: "red"
        font.pixelSize: 25
        font.bold: true
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
        visible: false
        id: btnprevious
        anchors.verticalCenter: btnplay.verticalCenter
        anchors.right: btnplay.left
        anchors.rightMargin: 20
        width: 32
        height: 32
        onClicked: {
            switch (btnloopMode.loopMode) {
            case 0:
            case 1:
            case 2:
                music_playlistModel.currentIndex--
                musicPlayer.play()
                break;
            case 3:
                music_playlistModel.randomIndex();
                musicPlayer.play()
                break;
            }
        }
        style: ButtonStyle {
            background: Image {
                id: imgbackward
                source: "qrc:/icons/btn_previous.png"
                opacity: btnprevious.pressed ? 0.7 : 1.0;
            }
        }
    }


    Button {
        id: btnlove
        width: 40
        height: 40
        visible: false
        anchors.right: btnloopMode.left
        anchors.rightMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        style: ButtonStyle {
            background: Image {
                source: btnlove.checked ? "qrc:/icons/btn_favorite_no.png"
                                        : "qrc:/icons/btn_favorite_yes.png"
            }
        }
        onClicked: btnlove.checked = !btnlove.checked
    }



    Button {
        id: btnplay
        anchors.verticalCenter : parent.verticalCenter
        anchors.right: btnforward.left
        anchors.rightMargin: 20
        width: 60
        height: 60
        checkable: true
        checked: false

        onClicked: {
            if (playList.musicCount === 0)
                return
            if (music_playlistModel.currentIndex !== -1) {
                musicPlayer.source =  music_playlistModel.getcurrentPath()
                playList.music_currentIndex = music_playlistModel.currentIndex
                musicPlayer.playbackState === Audio.PlayingState ? musicPlayer.pause() : musicPlayer.play()
            }
        }

        style: ButtonStyle {
            background: Image {
                id: imgplay
                source: musicPlayer.hasAudio && control.checked ? "qrc:/icons/btn_pause.png"
                                                                : "qrc:/icons/btn_play.png"
                opacity: btnplay.pressed ? 0.7 : 1.0;
            }
        }
    }

    Button {
        id: btnforward
        anchors.right: btnloopMode.left
        anchors.rightMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        width: 60
        height: 60
        onClicked: {
            if (musicPlayer.hasAudio)
                switch (btnloopMode.loopMode) {
                case 0:
                case 1:
                case 2:
                    music_playlistModel.currentIndex ++
                    musicPlayer.play()
                    break;
                case 3:
                    music_playlistModel.randomIndex();
                    musicPlayer.play()
                    break;
                }
            btnplay.checked = true
        }
        style: ButtonStyle {
            background: Image {
                id: imgforward
                source: "qrc:/icons/btn_next.png"
                opacity: btnforward.pressed ? 0.7 : 1.0;
            }
        }
    }


    Button {
        id: btnloopMode
        height: 60
        width: 60
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: btnplayList.left
        anchors.rightMargin: 20
        property int loopMode: 2
        onLoopModeChanged: {
            switch (loopMode) {
            case 0:
                tooltip = qsTr("单曲播放")
                break;
            case 1:
                tooltip = qsTr("单曲循环")
                break;
            case 2:
                tooltip = qsTr("顺序播放");
                break;
            case 3:
                tooltip = qsTr("随机播放");
                break;
            default:
                loopMode = 0;
            }
        }
        onClicked: {
            loopMode++;
            music_loopMode = loopMode
        }
        tooltip: qsTr("单曲播放")
        style: ButtonStyle {
            background: Rectangle {
                width: 60
                height: 60
                radius: 3
                color: Qt.rgba(0,0,0,0)
                Image {
                    id: imgloopMode
                    anchors.fill: parent
                    anchors.centerIn: parent
                    source: {
                        switch (control.loopMode) {
                        case 1:
                            return "qrc:/icons/btn_listscircle_single.png"
                        case 2:
                            return "qrc:/icons/btn_listjump.png"
                        case 3:
                            return "qrc:/icons/btn_listrandom.png"
                        default:
                            return "qrc:/icons/btn_listsingle.png"
                        }
                    }
                }
            }
        }
    }

    Button {
        id: btnplayList
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 10
        width: 60
        height: 60
        onClicked: {
            music_playlist_dawer_bottom.open()
        }
        style: ButtonStyle {
            background: Image {
                source: "qrc:/icons/btn_playlist.png"
                opacity: control.hovered ? 0.7 : 1.0;
            }
        }
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
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: -15
        updateValueWhileDragging: false
        //        maximumValue: progress_maximumValue
        stepSize: 30
        property bool handled: false
        onPressedChanged: {
            handled = true;
            progress_pressed = musci_play_progress.pressed
            if (!pressed)
                musci_play_progress.enabled = false
            silder_enable_timer.start()
        }

        onValueChanged: {
            if (handled && musicPlayer.seekable) {
                music_lyricModel.findIndex(value);
                musicPlayer.seek(value);
                musicPlayer.play();
                handled = false;
            } else {
                music_lyricModel.getIndex(value);
            }
        }
        style: SliderStyle {
            groove: Rectangle {
                width: control.width
                height: 1
                radius: 1
                color: "#50303030"
                Rectangle {
                    width: styleData.handlePosition
                    height: 1
                    color: "red"
                    radius: 1
                }
            }
            handle: Rectangle {
                width: 30
                height: 30
                color: "transparent"
            }
        }
    }


    Image {
        id: playPanel_music_artist
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 5
        width: parent.height - 15
        height: parent.height - 15
        source: musicPlayer.hasAudio ?
                    "file:///" + appCurrtentDir + "/src/artist/" + playList.music_currentIndex +".jpg" : ""
        MouseArea {
            anchors.fill: parent
            onClicked: {
                //music_page1.visible = false
                music_cd_dawer_bottom.open()

            }
        }
    }

    Text {
        anchors.left: playPanel_music_artist.right
        anchors.leftMargin: 10
        anchors.right: playPanel_play_time.left
        anchors.rightMargin: 10

        anchors.verticalCenter: parent.verticalCenter
        verticalAlignment: Text.AlignVCenter
        text: musicPlayer.playbackState === Audio.PlayingState ? music_playlistModel.getcurrentTitle() + " - " + music_playlistModel.getcurrentAuthor() : ""
        elide: Text.ElideRight
        color:"red"
        font.pixelSize: 25
        font.bold: true
        font.family: "Montserrat Light"
    }

    Connections{
        target: app_music
        onPlayBtnSignal:{
            btnplay.clicked()
        }
        onPreviousBtnSignal: {
            btnprevious.clicked()
        }
        onNextBtnSignal: {
            btnforward.clicked()
        }
    }
}
