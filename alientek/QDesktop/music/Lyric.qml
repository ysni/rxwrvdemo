/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   desktop
* @brief         Lyric.qml
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
    property int currentIndex: -1
    onCurrentIndexChanged: {
        music_lyric.currentIndex = currentIndex
    }
    ListView {
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50
        width: parent.width
        id: music_lyric
        spacing: 35
        highlightRangeMode: ListView.StrictlyEnforceRange

        preferredHighlightBegin: (parent.height - 100) / 2
        preferredHighlightEnd: (parent.height - 100) / 2 + 1
        highlight: Rectangle {
            color: Qt.rgba(0, 0, 0, 0)
            Behavior on y {
                SmoothedAnimation {
                    duration: 300
                }
            }
        }
        model: music_lyricModel
        delegate: Rectangle {
            width: parent.width
            height: 13
            color: Qt.rgba(0,0,0,0)
            Text {
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                text: "   " + textLine
                color: parent.ListView.isCurrentItem ? "white" : "#dddddddd"
                font.pixelSize: parent.ListView.isCurrentItem ? 35 : 30
                font.bold: parent.ListView.isCurrentItem
                font.family: "Montserrat Light"
            }
        }
    }
}
