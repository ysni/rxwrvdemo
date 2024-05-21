/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   desktop
* @brief         PlayList.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-09-13
*******************************************************************/
import dataModel 1.0
import QtQuick.Controls 2.5
import QtQuick 2.2
import QtMultimedia 5.0
import QtQuick 2.4

Item {
    property int music_currentIndex: -1
    property int musicCount: 0

    onMusic_currentIndexChanged: {
        music_listView.currentIndex = music_currentIndex
    }

    Rectangle {
        anchors.top: parent.top
        anchors.topMargin: 50
        width: parent.width - 100
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 180
        color: "white"
        radius: 20

        Text {
            id: all_songs
            text: qsTr("全部歌曲")
            font.pixelSize: 20
            font.family: "Montserrat Bold"
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 10
            anchors.leftMargin: 10
            color: "black"
        }

        Text {
            id: list_count
            text: qsTr("(0首)")
            font.pixelSize: 15
            font.family: "Montserrat Light"
            anchors.left: all_songs.right
            anchors.verticalCenter: all_songs.verticalCenter
            color: "gray"
        }

        Button {
            id: music_playlist_close_bt
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.right: parent.right
            anchors.rightMargin: 10
            width: 80
            height: 40
            Rectangle {
                anchors.fill: parent
                color: music_playlist_close_bt.pressed ? "#33101010" : "transparent"
                radius: 40
            }
            background: Rectangle{
                color: "transparent"
                BorderImage {
                    source: "qrc:/icons/btn_close.png"
                    anchors.centerIn: parent
                    width: 30
                    height: 30
                }
            }
            onClicked: {
                music_playlist_dawer_bottom.close()
            }
        }

        ListView {
            id: music_listView
            visible: true
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.bottomMargin: 15
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            currentIndex: 0
            //highlightRangeMode: ListView.StrictlyEnforceRange
            clip: true
            spacing: 10

            onCountChanged: {
                list_count.text = "(" + music_listView.count + ")" + "首"
                musicCount = music_listView.count
            }

            ScrollBar.vertical: ScrollBar {
                id: scrollBar
                width: 5
                onActiveChanged: {
                    active = true;
                }
                Component.onCompleted: {
                    scrollBar.active = true;
                }
                contentItem: Rectangle{
                    implicitWidth: 1
                    implicitHeight: 100
                    radius: 1
                    color: scrollBar.hovered ? "#88101010" : "#30101010"
                }
            }

            model: music_playlistModel
            delegate: Rectangle {
                id: itembg
                width: parent.width -10
                height: music_listView.currentIndex === index && musicPlayer.playbackState === Audio.PlayingState ? 80 : 60
                color: music_listView.currentIndex === index && musicPlayer.playbackState
                       === Audio.PlayingState ? "#dddddd" : "transparent"

                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    width: itembg.height
                    height: itembg.height
                    id: album
                    source: musicPlayer.playbackState == Audio.PlayingState && parent.ListView.isCurrentItem  ?
                                "file:///" + appCurrtentDir + "/src/artist/" +index +".jpg" : ""
                }

                Text {
                    id: songsname
                    width: itembg.width - 50
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: album.right
                    verticalAlignment: Text.AlignVCenter
                    text:  "  " + (index + 1 )+ " " + title
                    elide: Text.ElideRight
                    color: parent.ListView.isCurrentItem && musicPlayer.playbackState == Audio.PlayingState ? "red" : "black"
                    font.pixelSize: 25
                    font.bold: parent.ListView.isCurrentItem && musicPlayer.playbackState == Audio.PlayingState
                    font.family: "Montserrat Light"
                }

                Text {
                    id: songsauthor
                    visible: true
                    width: 200
                    height: 15
                    anchors.bottom: parent.bottom
                    anchors.left: album.right
                    verticalAlignment: Text.AlignVCenter;
                    text: "     " + author
                    elide: Text.ElideRight
                    color: parent.ListView.isCurrentItem && musicPlayer.playbackState == Audio.PlayingState ? "red" : "gray"
                    font.pixelSize: 15
                    font.family: "Montserrat Light"
                    font.bold: parent.ListView.isCurrentItem
                }

                MouseArea {
                    id: mouserArea
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: {
                        music_playlistModel.currentIndex = index
                        music_listView.currentIndex = index
                        if (musicPlayer.playbackState != Audio.PlayingState) {
                            musicPlayer.play()
                        }
                    }
                }

                Button {
                    id: itembtn
                    anchors.right: parent.right
                    anchors.verticalCenter: itembg.verticalCenter
                    width: itembg.height
                    height: itembg.height
                    onClicked: {
                        music_playlistModel.currentIndex = index
                        music_listView.currentIndex = index
                        if (musicPlayer.playbackState != Audio.PlayingState)
                            musicPlayer.play()
                    }
                    background: Rectangle {
                        width: Control.width
                        height: Control.height
                        radius: 3
                        color: Qt.rgba(0,0,0,0)
                        Image {
                            id: itemImage
                            width: parent.height - 20
                            height: parent.height - 20
                            anchors.centerIn: parent
                            source:  music_listView.currentIndex != index || musicPlayer.playbackState != Audio.PlayingState
                                     ? "qrc:/icons/btn_play.png" : "qrc:/icons/btn_pause.png"
                            opacity: 0.8
                        }

                    }
                }
            }
        }
    }
}
