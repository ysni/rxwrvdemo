/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   music
* @brief         Music.qml
* @author        Deng Zhimao
* @email         1252699831@qq.com
* @date          2020-06-05
*******************************************************************/
import dataModel 1.0
import QtQuick.Controls 2.5
import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Dialogs 1.1

import QtMultimedia 5.0
import QtQuick 2.4
import QtQuick 2.0

ApplicationWindow {
    width: 800
    height: 480
    visible: true
    id: app_music
    title: qsTr("app_music")

    property bool head_start_runing: false
    property bool head_stop_runing: false
    property int lyric_CurrtentIndex: -1
    property int head_roation: 0

    function songsInit(){
        music_playlistModel.add(appCurrtentDir)
    }

    Component.onCompleted: {
        songsInit()
    }

    Rectangle {
        anchors.fill: parent
        color: "#eff2f7"
    }

    Audio {
        id: musicPlayer
        source: ""
        //volume: 0.5
        volume: 1.0
        autoPlay: false
        onSourceChanged: {
            music_lyricModel.setPathofSong(source, appCurrtentDir);
            //console.log( musicPlayer.volume);
        }
        onPositionChanged: {
            playPanel.progress_maximumValue = duration;
            if(!playPanel.progress_pressed)
                playPanel.progress_value = position
        }
        onPlaybackStateChanged: {
            switch (playbackState) {
            case Audio.PlayingState:
                playPanel.btnplayChecked = true
                head_start_runing = true
                break;
            case Audio.PausedState:
            case Audio.StoppedState:
                if (head_roation != -45)
                    head_stop_runing = true
                playPanel.btnplayChecked = false
                break;
            default:
                playPanel.btnplayChecked = false
                head_stop_runing = true
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
                console.log("status:loaded");
                playPanel.progress_maximumValue = duration
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
                    ttitle.text = qsTr("需要安装解码器");
                    break;
                case Audio.ResourceError:
                    ttitle.text = qsTr("文件错误");
                    break;
                case Audio.NetworkError:
                    ttitle.text = qsTr("网络错误");
                    break;
                case Audio.AccessDenied:
                    ttitle.text = qsTr("权限不足");
                    break;
                case Audio.ServiceMissing:
                    ttitle.text = qsTr("无法启用多媒体服务");
                    break;
                }
                break;
            case Audio.EndOfMedia:
                //console.log("status:end of media");
                music_lyricModel.currentIndex = 0
                playPanel.progress_maximumValue = 0
                playPanel.progress_value = 0
                if (playPanel.music_loopMode !== 0)
                    musicPlayer.autoPlay = true
                else
                    musicPlayer.autoPlay = false
                switch (playPanel.music_loopMode) {

                case 1:
                    musicPlayer.play()
                    break;
                case 2:
                    music_playlistModel.currentIndex++
                    break;
                case 3:
                    music_playlistModel.randomIndex()
                    break;
                default:
                    break;
                }
                break;
            }
        }
    }

    PlayListModel {
        id: music_playlistModel
        currentIndex: 0
        onCurrentIndexChanged: {
            musicPlayer.source = getcurrentPath()
            playList.music_currentIndex = currentIndex
        }
    }

    LyricModel {
        id: music_lyricModel
        onCurrentIndexChanged: {
            lyric_CurrtentIndex = currentIndex
        }
    }

    Rectangle {
        id: music_playlist_dawer_bottom
        width: parent.width
        height: parent.height
        z: 3
        color: "#55101010"
        MouseArea {anchors.fill: parent}
        x: 0
        y: height
        Behavior on y { PropertyAnimation { duration: 250; easing.type: Easing.OutQuad } }

        MouseArea {
            anchors.fill: parent
            drag.target: parent
            drag.minimumX: 0
            drag.minimumY: 0
            drag.maximumX: 0
            drag.maximumY: parent.height
            property int dragY
            onPressed: {
                dragY = parent.y
            }
            onReleased: {
                if (parent.y - dragY >= 100)
                    music_playlist_dawer_bottom.close()
                else
                    music_playlist_dawer_bottom.open()
            }
        }

        PlayList {
            id: playList
            anchors.fill: parent
        }

        function open() {
            music_playlist_dawer_bottom.y = 0
        }

        function close() {
            music_playlist_dawer_bottom.y = height
        }
    }

    Rectangle {
        id: music_cd_dawer_bottom
        width: parent.width
        height: parent.height
        z: 2
        //        color: "gray"
        Image {
            anchors.fill: parent
            source: "qrc:/images/cd_page_bg.png"
        }
        x: 0
        y: height
        Behavior on y { PropertyAnimation { duration: 250; easing.type: Easing.OutQuad } }

        MouseArea {
            anchors.fill: parent
            drag.target: parent
            drag.minimumX: 0
            drag.minimumY: 0
            drag.maximumX: 0
            drag.maximumY: parent.height
            property int dragY
            onPressed: {
                dragY = parent.y
            }
            onReleased: {
                if (parent.y - dragY >= 100)
                    music_cd_dawer_bottom.close()
                else
                    music_cd_dawer_bottom.open()
            }
        }

        CD {
            id: music_cd
            z: 0
            anchors.fill: parent
        }

        function open() {
            music_cd_dawer_bottom.y = 0
        }

        function close() {
            music_cd_dawer_bottom.y = height
        }
    }

    Item {
        id: music_page1
        anchors.fill: parent

        PlayPanel {
            id: playPanel
            visible: true
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.left: parent.left
            height: parent.height >= 480 ? 100 : 80
        }

        Item {
            id: music_display_images
            anchors.top: parent.top
            anchors.topMargin: 25
            clip: true
            width: parent.width
            anchors.bottom: playPanel.top
            Flickable {
                id : music_flickable
                anchors.fill: parent
                contentWidth: parent.width
                contentHeight: parent.height + 160
                clip: true

                CircleView {
                    id: music_circleView
                    width: parent.width
                    height: 200
                    anchors.top: parent.top
                    anchors.left: parent.left
                }

                MiddleItem {
                    anchors.top: music_circleView.bottom
                    anchors.left: parent.left
                    width: parent.width
                    height: 200
                }
            }
        }
    }
}


