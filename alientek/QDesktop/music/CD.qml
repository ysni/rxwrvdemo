/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   desktop
* @brief         CD.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-09-13
*******************************************************************/
import QtQuick 2.0
import QtQuick 2.12
import QtMultimedia 5.0
import QtQuick.Controls 2.5

Item {
    id: my_cd
    anchors.fill: parent
    property int music_cd_Image_y: 0
    property bool animator_music_cd_Image_running_flag: false

    onVisibleChanged: {
        if (musicPlayer.playbackState === Audio.PlayingState && my_cd.visible) {
            animator_music_cd_Image_running_flag = true
            // head_start_runing = true
        } else {
            // head_stop_runing = true
            animator_music_cd_Image_running_flag = false
        }
    }

    Lyric {
        width: parent.width
        height: parent.height - 160
        anchors.centerIn: parent
        id: lyric
        visible: false
        currentIndex: lyric_CurrtentIndex
        MouseArea {
            anchors.fill: parent
            onClicked: {
                lyric.visible = false
                cd_listView.visible = true
                cd_bg.visible = true
                music_cd_head_Image.visible = true
            }
        }
    }
    Image {
        id: music_mask
        source: "qrc:/images/music_mask.png"
        anchors.fill: parent
    }

    Rectangle {
        id: down_icon_bg
        anchors.left: parent.left
        anchors.topMargin: 40
        anchors.leftMargin: 30
        anchors.top: parent.top
        width: 60
        height: 60
        radius: 30
        z: 5
        color: down_icon_mouseArea.pressed ? "#55101010" : "transparent"
        Image {
            visible: true
            id: down_icon
            source: "qrc:/icons/down.png"
            width:  30
            height: 30
            anchors.centerIn: parent
            MouseArea {
                id: down_icon_mouseArea
                anchors.fill: parent
                onClicked: {
                    //music_page1.visible = true
                    music_cd_dawer_bottom.close()
                }
            }

        }
    }

    Rectangle {
        id: cd_bg
        width: 400
        height: 400
        radius: 200
        anchors.centerIn: parent
        color: "#55ffffff"
    }

    Text {
        visible: cd_bg.visible
        anchors.top: cd_bg.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        text: musicPlayer.playbackState === Audio.PlayingState ? music_playlistModel.getcurrentTitle() + " - " + music_playlistModel.getcurrentAuthor() : ""
        color: "white"
        font.family: "Montserrat Regular"
        font.pixelSize: 35
    }

    Timer {
        id: cd_timer
        interval: 1000
        onTriggered: {
            animator_music_cd_Image_running_flag = true
            cd_timer.stop()
            music_playlistModel.currentIndex = cd_listView.currentIndex
            if (musicPlayer.playbackState !== Audio.PlayingState)
                musicPlayer.play()
        }
    }

    ListView {
        id: cd_listView
        visible:  music_cd_dawer_bottom.y != app_music.height
        orientation: ListView.Horizontal
        width: parent.width
        //height: parent.height
        height: 400
        anchors.centerIn: parent
        interactive: true
        model: music_playlistModel
        snapMode: ListView.SnapOneItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        currentIndex: music_playlistModel.currentIndex
        onCurrentIndexChanged: {
            animator_music_cd_Image_running_flag = false
            cd_timer.start()
        }

        delegate: Rectangle {
            id: listView_delegate
            // width: cd_listView.width
            height: cd_listView.height
            width:  app_music.width
            color: "transparent"

            Image {
                visible: true
                id: music_cd_Image
                source: "qrc:/images/cd_outside.png"
                width:  420
                height: 420
                antialiasing: true
                anchors.centerIn: parent
                Image {
                    width: 270
                    height: 270
                    anchors.centerIn: parent
                    z: -1
                    id: music_cd_artist_Image
                    source: "file:///" + appCurrtentDir + "/src/artist/" + index +".jpg"
                }
                onYChanged: music_cd_Image_y =  music_cd_Image.y

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        lyric.visible = true
                        cd_listView.visible = false
                        cd_bg.visible = false
                        music_cd_head_Image.visible = false
                    }
                }
            }

            RotationAnimator {
                id: animator_music_cd_Image
                target: music_cd_Image
                from: 0
                to: 360
                duration: 50000
                loops: Animation.Infinite
                running:  cd_listView.currentIndex  === index  && musicPlayer.playbackState === Audio.PlayingState && animator_music_cd_Image_running_flag
                onRunningChanged: {
                    if (running === false) {
                        from = music_cd_Image.rotation
                        to = from + 360
                    }
                }
                onStopped: music_cd_Image.rotation = 0
            }
        }
    }

    Image {
        visible: music_cd_dawer_bottom.y != app_music.height
        id: music_cd_head_Image
        source: "qrc:/images/head_image.png"
        width:  300
        height: 300
        antialiasing: true
        transformOrigin: Item.Center
        rotation: -45
        //y: music_cd_Image_y - 140
        y: cd_listView.y - 230
        anchors.horizontalCenter: parent.horizontalCenter
        Rectangle {
            anchors.centerIn: parent
            width: 26
            height: 26
            anchors.verticalCenterOffset: -1
            anchors.horizontalCenterOffset: 1.5
            radius: 13
            z: -1
            color: "#55ffffff"
        }
    }

    RotationAnimator {
        id: animator_music_cd_head_Image_start
        target: music_cd_head_Image
        from: -45
        to: 0
        duration: 450
        running: head_start_runing && !head_stop_runing
        onRunningChanged: {
            if (running === false)
                head_start_runing = false
        }
        onStopped: {
            head_roation = music_cd_head_Image.rotation
        }
    }

    RotationAnimator {
        id: animator_music_cd_head_Image_stop
        target: music_cd_head_Image
        from: 0
        to: -45
        duration: 450
        running: head_stop_runing
        onRunningChanged: {
            if (running === false)
                head_stop_runing = false
        }
        onStopped: {
            head_roation = music_cd_head_Image.rotation
        }
    }

    Button {
        id: btn_play
        width: 128
        height: 128
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 200
        anchors.horizontalCenter: parent.horizontalCenter
        opacity: btn_play.pressed ? 0.8 : 1.0
        background: Image {
            anchors.fill: parent
            source:musicPlayer.playbackState === Audio.PlayingState ? "qrc:/icons/music_pause_icon.png" : "qrc:/icons/music_play_icon.png"
        }
        onClicked: app_music.playBtnSignal()
    }

    Button {
        id: btn_next
        width: 64
        height: 64
        anchors.verticalCenter: btn_play.verticalCenter
        anchors.left: btn_play.right
        anchors.leftMargin: 64
        opacity: btn_next.pressed ? 0.8 : 1.0
        background: Image {
            anchors.fill: parent
            source: "qrc:/icons/music_next_icon.png"
        }
        onClicked: app_music.nextBtnSignal()
    }

    Button {
        id: btn_previous
        width: 64
        height: 64
        anchors.verticalCenter: btn_play.verticalCenter
        anchors.right: btn_play.left
        anchors.rightMargin: 64
        opacity: btn_previous.pressed ? 0.8 : 1.0
        background: Image {
            anchors.fill: parent
            source: "qrc:/icons/music_previous_icon.png"
        }
        onClicked: app_music.previousBtnSignal()
    }
}
