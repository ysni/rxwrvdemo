/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   desktop
* @brief         Settings_window.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-09-30
*******************************************************************/
import QtQuick 2.12
import QtQuick.Window 2.12

import QtQuick.Controls 2.5

Window {
    visible: true
    id: app_settings
    width: 800
    height: 480
    title: qsTr("settings")
    property string global_system_hostname: "Your System"
    property string global_board_type: "Your Board"
    property string global_linux_version: "Your Version"
    property string global_file_system_version: "Your FileSystem"

    Rectangle {
        anchors.fill: parent
        color: "#eff2f7"
    }

    SwipeView {
        id: settings_swipeView
        visible: true
        anchors.fill: parent
        clip: true
        interactive: false
        MainPage { }
        MyDevice { }
    }
}
