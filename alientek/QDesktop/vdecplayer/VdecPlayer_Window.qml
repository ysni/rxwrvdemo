/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   QDesktop
* @brief         VdecPlayer_Window.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2022-10-11
*******************************************************************/
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5

import vdecplayer 1.0

Window {
    id: app_VdecPlayer
    visible: true
    width: 800
    height: 480
    title: qsTr("VdecPlaer")

    Rectangle {
        id: cameraBg
        anchors.fill: parent
        color: "black"
    }

    VdecPlayerItem {
        id: player
        anchors.fill: parent
        onVdecStop: {
            console.log("Vdec thread stop!")
        }
    }

    onVisibleChanged: {
        if (visible)
            player.startVdec(true)
        else
            player.startVdec(false)
    }
}
