/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   QDesktop
* @brief         main.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-08-31
*******************************************************************/
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.1
import QtQuick.VirtualKeyboard 2.4
import QtQuick.VirtualKeyboard.Settings 1.2
import QtQuick.Window 2.12

import board 1.0
import QmlEvents 1.0

ApplicationWindow {
    id: root
    visible: true
    x: 0
    y: 0
    minimumHeight: 272
    minimumWidth: 480
    width: !armEnv ? 720 : Screen.desktopAvailableWidth
    height: !armEnv ? 1280 : Screen.desktopAvailableHeight
    //flags: Qt.FramelessWindowHint
    property string time_display_color: "white"
    property string system_time: ""
    property string system_week: ""
    property string system_date1: ""
    property string system_date2: ""
    property int root_width: root.width

    property int appIndex: -1
    property var global_appIndex: -1 // note: must var
    property bool global_photo_Check: true
    property bool global_dayOrNight: false
    property real global_system_volume: 1.0
    property int global_system_brightness
    property string global_system_hostname
    property bool global_board_type
    property string global_linux_version
    property string global_file_system_version

    property bool whiteOrGray: true
    property bool whiteOrBlack: true
    property bool appEnable: true
    property bool appinitFgShow: false
    property int appinit_TimeCount_value: 3
    property bool delayToStartFlag: false

    Rectangle {
        id: appInitTips
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 80
        width: parent.width - 100
        height: 100
        radius: 25
        color: "#88555555"
        visible: false
        z: 100
        Text {
            id: tips
            anchors.centerIn: parent
            font.pixelSize: 30
            font.family: "Montserrat Bold"
            color: "white"
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Timer {
        id: tips_Timer
        interval: 1500
        repeat: false
        running: false
        onTriggered: {
            tips_Timer.stop()
            appInitTips.visible = false
        }
    }

    function appinitFgFunc(src) {
        appinitFgShow = true
        appinitfg.source = src
        appinitFgTimer.start()
    }

    function tipsShow(tipStr) {
        tips.text = qsTr(tipStr)
        appInitTips.visible = true
        tips_Timer.start()
    }

    function closeAppInitFg() {
        appinitFgShow = false
    }

    Timer {
        id: appStarttimer
        function setTimeout(cb, delayTime, tipStr, appName) {
            appStarttimer.interval = delayTime;
            appStarttimer.repeat = false
            appStarttimer.triggered.connect(cb);
            tipsShow(tipStr)
            appStarttimer.triggered.connect(function release () {
                appStarttimer.triggered.disconnect(cb)
                appStarttimer.triggered.disconnect(release)
                appIsReadyTimer.appName = appName
                appIsReadyTimer.start()
            })
            appStarttimer.start()
        }
    }

    Timer {
        id: appIsReadyTimer
        interval: 200
        repeat: true
        running: false
        property string appName
        onAppNameChanged: {
            appNameTryCount = 0
        }
        property int appNameTryCount: 0
        onTriggered: {
            appNameTryCount++
            if (appNameTryCount > 10) {
                appIsReadyTimer.stop()
                appNameTryCount = 0
                console.log(appName + "start timeout!")
                return
            }
            appIndex = appIsRunning(appName)
            if (appIndex === -1 )
                return
            appIsReadyTimer.stop()
            appNameTryCount = 0
            app_swipeView.currentIndex = appIndex
            main_swipeView.visible = false
            app_swipeView.itemAt(appIndex).visible = true
            console.log(appName + " is ready!")
        }
    }

    function destoryAppFirst(appName) {
        if (appName !== "") {
            var value = appIsRunning(appName)
            if (value !== -1) {
                var object = app_swipeView.itemAt(value)
                object.destroy()
                console.log("destory " + appName + " App first")
                return 1
            }
            return 0
        }
    }

    function delayStartApp(appName, destroyApp1, destroyApp2, destroyApp3, destroyApp4, tipsStr, color, flag1, flag2, flag3) {
        if (appIsRunning(appName) < 0) {
            delayToStartFlag = true
            if (flag3)
                appinitFgFunc("qrc:/images/appinit_images/camera.jpeg")
            else
                appinitFgFunc("qrc:/images/appinit_images/vdecplayer.jpeg")
            var value = 0
            value = destoryAppFirst(destroyApp1) | destoryAppFirst(destroyApp2) | destoryAppFirst(destroyApp3) | destoryAppFirst(destroyApp4)
            if (value !== 0) {
                // delay time to start app!
                appStarttimer.stop()
                appStarttimer.setTimeout(function() { addPage(createPage(appName +".qml"))}, 2000, tipsStr, appName)
            } else {
                addPage(createPage(appName + ".qml"))
                appIndex = appIsRunning(appName)
            }
        } else {
            delayToStartFlag = false
            console.log(appName + "is already running")
            appIndex = appIsRunning(appName)
        }
        time_display_color = color
        whiteOrGray = flag1
        whiteOrBlack = flag2
    }


    function normalStartApp(appName, destroyApp1, tipStr, flag1, srcStr, color, flag2, flag3) {
        delayToStartFlag = false
        if (appIsRunning(appName) < 0) {
            if (destroyApp1 !== "") {
                var value = appIsRunning(destroyApp1)
                if (value !== -1) {
                    tipsShow(tipStr)
                    var object = app_swipeView.itemAt(value)
                    object.destroy()
                    console.log("destory " + destroyApp1 + " App first")
                }
            }
            addPage(createPage(appName + ".qml"))
            if (flag1) {
                appinitFgShow = flag1
                appinitfg.source = srcStr
                appinitFgTimer.start()
            }
        } else {
            console.log(appName + " is already running")
        }
        appIndex = appIsRunning(appName)
        time_display_color = color
        whiteOrGray = flag2
        whiteOrBlack = flag3
    }

    onGlobal_appIndexChanged: {
        app_swipeView.visible = false
        if (!appEnable)
            return
        if (delayToStartFlag)
            return
        switch (global_appIndex) {
        case 0:
            normalStartApp("Music", "Recorder", "正在关闭录音应用", true, "qrc:/images/appinit_images/music.jpeg", "black", false, true)
            break;

        case 1 :
            delayStartApp("ATKCamera", "VdecPlayer", "Cardvr", "ObjectRecognition", "FaceDetection", "正在关闭其它摄像头或解码应用", "gray", false, false, true)
            break;

        case 2 :
            normalStartApp("PhotoView", "", "", false, "", "black", false, true)
            break;

        case 3:
            normalStartApp("Recorder", "Music", "正在关闭音乐应用", false, "", "black", false, true)
            break;

        case 4 :
            normalStartApp("Settings", "", "", false, "", "black", false, true)
            break;

        case 5 :
            delayStartApp("VdecPlayer", "ObjectRecognition", "Cardvr", "ATKCamera", "FaceDetection", "正在关闭其它摄像头或解码应用", "gray", false, false, false)
            break;
        case 6 :
            delayStartApp("Cardvr", "VdecPlayer", "ATKCamera", "ObjectRecognition", "FaceDetection", "正在关闭其它摄像头或解码应用", "white", false, false, true)
            break;

        case 7 :
            normalStartApp("Live555", "", "", false, "", "white", false, false)
            break;

        case 8 :
            delayStartApp("ObjectRecognition", "VdecPlayer", "ATKCamera", "Cardvr", "FaceDetection", "正在关闭其它摄像头或解码应用", "white", false, false, true)
            break;

        case 9 :
            delayStartApp("FaceDetection", "VdecPlayer", "ATKCamera", "Cardvr", "ObjectRecognition", "正在关闭其它摄像头或解码应用", "white", false, false, true)
            break;

        case 10 :
            normalStartApp("FactoryTest", "", "", false, "", "black", false, true)
            break;

        case 11 :
            normalStartApp("FileView", "", "", false, "", "black", false, true)
            break;

        case 12 :
            normalStartApp("Notepad", "", "", false, "", "black", false, true)
            break;

        case 13 :
            normalStartApp("Calculator", "", "", false, "", "black", false, false)
            break;

        default:
            break;
        }
        if (appIndex !== -1) {
            app_swipeView.currentIndex = appIndex
            main_swipeView.visible = false
            app_swipeView.itemAt(appIndex).visible = true
        }
        appEnable = false
        app_control.start()
        //bt_three.enabled = false
    }

    //title: qsTr("Qt Desktop Power By 正点原子")

    Image {
        id: desktop_bg
        source: "qrc:/images/desktop_bg.jpeg"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
    }

    Board {
        id: board
        onSysVolumeChanged: {
            global_system_volume = Number(sysVolume)
        }

        onCpuTempChanged: {
            cpuTemp_text.text = "CPU:" + cpuTemp + "℃"
        }

        onSysBrightnessChanged: {
            global_system_brightness = Number(sysBrightness);
        }
        Component.onCompleted: {
            global_system_hostname =  board.sysHostname
            global_board_type = board.getCoreBoardInfo()
            global_linux_version = board.linuxVersion
            global_file_system_version = board.fileSystemVersion
        }
    }


    function addPage(page) {
        app_swipeView.addItem(page)
    }
    function createPage(object){
        var component = Qt.createComponent(object);
        var page = component.createObject(app_swipeView, {})
        return page
    }

    function appIsRunning(appName) {
        for (var i = 0; i < app_swipeView.count; i++) {
            var app = app_swipeView.itemAt(i)
            var StrArr = app.toString().split("_QMLTYPE")
            //            console.log(StrArr[0])
            if (StrArr[0] === appName)
                return i
        }
        return -1
    }

    Row {
        z: 99
        anchors.top: parent.top
        anchors.topMargin: 15
        spacing: 10
        anchors.left: parent.left
        anchors.leftMargin: 15
        Text {
            id: time_text
            text: system_time
            color: time_display_color
            font.family: "Montserrat Light"
            font.pixelSize:  20
            font.bold: true
        }

        Text {
            id: date_text
            text: system_date1
            color: time_display_color
            font.family: "Montserrat Light"
            font.pixelSize:  15
            font.bold: true
            visible: false
        }

        Text {
            id: cpuTemp_text
            color: time_display_color
            font.family: "Montserrat Light"
            font.pixelSize:  15
            font.bold: true
            visible: false
        }
    }

    Row {
        z: 99
        anchors.top: parent.top
        anchors.topMargin: 15
        spacing: 2
        anchors.right: parent.right
        anchors.rightMargin: 15

        Text {
            id: kwh_text
            color: time_display_color
            font.family: "Montserrat Light"
            font.pixelSize:  15
            font.bold: true
            text: qsTr("100%")
            visible: false
        }

        Image {
            visible: false
            source: time_display_color == "white" ? "qrc:/icons/bat_white.png" : "qrc:/icons/bat_black.png"
        }
    }

    function currentTime(){
        return Qt.formatDateTime(new Date(), "hh:mm" )
    }

    function currentDate1(){
        return Qt.formatDateTime(new Date(), "ddd MM,dd" )
    }

    function currentWeek(){
        return Qt.formatDateTime(new Date(), "ddd" )
    }

    function currentDate2(){
        return Qt.formatDateTime(new Date(), "MM/dd" )
    }


    Timer{
        id: timer
        interval: 1000
        repeat: true
        running: true
        onTriggered:{
            system_time = currentTime()
            system_date1 = currentDate1()
            system_date2 = currentDate2()
            system_week = currentWeek()
        }
    }

    SwipeView {
        id: main_swipeView
        visible: true
        anchors.fill: parent
        clip: true
        Page1 { }
        Page2 { }
        onVisibleChanged: {
            if (app_swipeView.visible == false) {
                app_swipeView.visible = true
            } else {
                main_swipeView.visible = false
                for (var i = 0; i < app_swipeView.count; i++){
                    app_swipeView.itemAt(i).visible = false
                }
            }
        }
    }

    SwipeView {
        id: app_swipeView
        visible: false
        interactive: false
        anchors.fill: parent
        Component.onCompleted: {
            contentItem.highlightMoveDuration = 0
        }
        onVisibleChanged: {
            if (main_swipeView.visible == false) {
                main_swipeView.visible = true
            } else {
                app_swipeView.visible = false
                time_display_color = "white"
                whiteOrGray = true
            }
        }
        onCurrentIndexChanged: {
            //console.log("当前item是" + currentIndex)
        }
    }

    Component.onCompleted: {
        main_swipeView.visible =  true
    }

    Timer {
        id: app_control
        repeat: false
        // full time to start delay app
        interval: delayToStartFlag ? 4000 : 50
        onTriggered: {
            appEnable = true
            delayToStartFlag = false
            //bt_three.enabled = true
        }
    }

    PageIndicator {
        id: indicator
        visible: main_swipeView.visible

        count: main_swipeView.count
        currentIndex: main_swipeView.currentIndex

        anchors.bottom: main_swipeView.bottom
        anchors.bottomMargin: root_width / 800 * 200
        anchors.horizontalCenter: parent.horizontalCenter
    }
    /*
    Timer {
        id: control_opacity_timer
        interval: 3000
        repeat: false
        onTriggered: {
            back_button.opacity = 0.4
        }
    }

    function expand_func() {
        back_button.visible = false
        home_menu.width = 266
        home_menu.height = 266
        home_menu.x = (root.width  - 266) / 2
        home_menu.y = (root.height  - 266) / 2
        home_menu.opacity = 1.0
        model_MouseArea.enabled = true
    }

    function shrink_func() {
        home_menu.width = back_button.width
        home_menu.height = back_button.height
        home_menu.x = back_button.x
        home_menu.y = back_button.y
        home_menu.opacity = 0.0
        model_MouseArea.enabled = false
    }

    Button {
        id: back_button
        z: 99
        x: parent.x + parent.width - 90
        y: parent.y + parent.height / 2 - 50
        width: 80
        height: 80
        opacity: 0.5
        background: Image{
            anchors.fill: parent
            source: "qrc:/images/back_bg.png"
        }
        onXChanged: home_menu.x = back_button.x
        onYChanged: home_menu.y = back_button.y
        MouseArea {
            hoverEnabled: true
            anchors.fill: parent
            drag.target: back_button
            drag.minimumX: 0
            drag.minimumY: 0
            drag.maximumX: root.width - 80
            drag.maximumY: root.height - 80
            onEntered: {
                control_opacity_timer.stop()
                back_button.opacity = 0.8
            }
            onExited: control_opacity_timer.start()
            onClicked: {
                expand_func()
            }

            onPressAndHold: {
                app_swipeView.visible = false
            }
        }
        Rectangle {
            width: 60
            height: 60
            radius: 30
            color: "#55ffffff"
            anchors.centerIn: parent
        }
        Rectangle {
            width: 50
            height: 50
            radius: 25
            color: "#aaffffff"
            anchors.centerIn: parent
        }
        Rectangle {
            width: 40
            height: 40
            radius: 20
            color: "#ffffff"
            anchors.centerIn: parent
        }
    }

    MouseArea {
        id: model_MouseArea
        anchors.fill: parent
        enabled: false
        onClicked: {
            shrink_func()
        }
    }

    Rectangle {
        id: home_menu
        x: back_button.x
        y: back_button.y
        height: back_button.height
        width: back_button.width
        color: "#101010"
        opacity: 0.0
        z: 98
        radius: 25
        Behavior on width { PropertyAnimation { duration: 200; easing.type: Easing.Linear } }
        Behavior on height { PropertyAnimation { duration: 200; easing.type: Easing.Linear } }
        Behavior on x { PropertyAnimation { duration: 200; easing.type: Easing.Linear } }
        Behavior on y { PropertyAnimation { duration: 200; easing.type: Easing.Linear } }
        Behavior on opacity { PropertyAnimation { duration: 200; easing.type: Easing.Linear } }

        onOpacityChanged: {
            if (opacity === 0.0)
                // 这里可能有个bug，小圆点会不见！各单位注意
                back_button.visible = true
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                shrink_func()
            }
        }

        RoundButton {
            id: home_button
            width: 80
            height: 80
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            background: Item {
            }
            Rectangle {
                width: 60
                height: 60
                radius: 30
                color:  home_button.pressed ? "#5510bfe4" :  "#55ffffff"
                anchors.centerIn: parent
            }
            Rectangle {
                width: 50
                height: 50
                radius: 25
                color:  home_button.pressed ? "#aa10bfe4" : "#aaffffff"
                anchors.centerIn: parent
            }
            Rectangle {
                width: 40
                height: 40
                radius: 20
                color: home_button.pressed ? "#10bfe4" : "#ffffff"
                anchors.centerIn: parent
            }
            onClicked: {
                shrink_func()
                global_photo_Check = true
                app_swipeView.visible = false
            }
        }

        Text {
            id: home_text
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("主屏幕")
            font.pixelSize: 15
            color: "white"
            font.family: "Montserrat Light"
        }

        RoundButton {
            id: clear_button
            width: 80
            height: 80
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            background: Item {
            }
            Rectangle {
                width: 60
                height: 60
                radius: 30
                color: "transparent"
                border.width: 5
                border.color:  clear_button.pressed ? "#10bfe4" : "white"
                anchors.centerIn: parent
                Text {
                    id: app_count_text
                    text: app_swipeView.count
                    font.pixelSize: 20
                    color: "#e1b844"
                    font.family: "Montserrat Light"
                    anchors.centerIn: parent
                }
            }
            onClicked: {
                shrink_func()
                for (var i = 0; i < app_swipeView.count; i++) {
                    var object = app_swipeView.itemAt(i)
                    object.destroy()
                }

                for (var j = 0; j < app_swipeView.count; j++) {
                    app_swipeView.removeItem(j)
                }
                app_swipeView.visible = false
            }
        }
        Text {
            id: clear_text
            anchors.top: clear_button.bottom
            anchors.topMargin: -5
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("清理应用")
            font.pixelSize: 15
            color: "white"
            font.family: "Montserrat Light"
        }
    }
*/

    Rectangle {
        visible: !main_swipeView.visible
        width: parent.width
        height: 80
        color: whiteOrBlack ? "white" : "black"
        anchors.bottom: parent.bottom
        Rectangle {
            height: 1
            visible: whiteOrBlack
            color: "#337f7f7f"
            width: parent.width
        }
    }


    Image {
        id: appinitfg
        visible: appinitFgShow
        anchors.fill: parent
        MouseArea {
            anchors.fill: parent
            onClicked: {
                closeAppInitFg()
            }
        }
    }

    Rectangle {
        id: appinit_TimeCount
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.right: parent.right
        anchors.rightMargin: 30
        color: "#44555555"
        visible: appinitFgShow
        width: 120
        height: 50
        radius: 25
        Text {
            anchors.centerIn: parent
            text: qsTr("还剩" + appinit_TimeCount_value.toString() + "秒")
            font.pixelSize: 20
            color: "white"
            font.family: "Montserrat Regular"
        }
    }

    Timer {
        id: appinitFgTimer
        interval: 1000
        repeat: true
        running: false
        onTriggered: {
            appinit_TimeCount_value--
            if (appinit_TimeCount_value === 0) {
                appinitFgShow = false
                appinitFgTimer.stop()
                appinit_TimeCount_value = 3
                delayToStartFlag = false
            }
        }
    }

    Button {
        id: bt_home
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: 140
        height: 80
        background: Image {
            source: whiteOrGray ? "qrc:/icons/btn_icons/btn_home_white.png" : "qrc:/icons/btn_icons/btn_home_gray.png"
            anchors.centerIn: parent
            width: 32
            height: 32
        }

        onClicked: {
            if (appinitFgShow)
                closeAppInitFg()
            app_swipeView.visible = false
            board.playSound()
        }

        Rectangle {
            id: bt_homebg
            height: parent.height
            width: parent.width / 2
            opacity: 0
            anchors.centerIn: parent
            radius: 40
            color: whiteOrGray ? "white" : "#7f7f7f"
        }

        states: State {
            name: "show"; when: bt_home.pressed
            PropertyChanges { target: bt_homebg; opacity: 0.3; width: parent.width}
        }

        transitions: Transition {
            NumberAnimation { properties: "opacity"; easing.type: Easing.OutCubic; duration: 300 }
            NumberAnimation { properties: "width"; easing.type: Easing.OutCubic; duration: 300 }
        }
    }

    Button {
        id: bt_back
        anchors.bottom: parent.bottom
        anchors.left: bt_home.right
        anchors.leftMargin: 50
        width: 140
        height: 80
        background: Image {
            source: whiteOrGray ? "qrc:/icons/btn_icons/btn_back_white.png" : "qrc:/icons/btn_icons/btn_back_gray.png"
            anchors.centerIn: parent
            width: 32
            height: 32
        }

        onClicked: {
            if (appinitFgShow)
                closeAppInitFg()
            app_swipeView.visible = false
            board.playSound()
        }

        Rectangle {
            id: bt_backbg
            height: parent.height
            width: parent.width / 2
            opacity: 0
            anchors.centerIn: parent
            radius: 40
            color: whiteOrGray ? "white" : "#7f7f7f"
        }

        states: State {
            name: "show"; when: bt_back.pressed
            PropertyChanges { target: bt_backbg; opacity: 0.3; width: parent.width}
        }

        transitions: Transition {
            NumberAnimation { properties: "opacity"; easing.type: Easing.OutCubic; duration: 300 }
            NumberAnimation { properties: "width"; easing.type: Easing.OutCubic; duration: 300 }
        }
    }

    Button {
        id: bt_three
        anchors.bottom: parent.bottom
        anchors.right: bt_home.left
        anchors.rightMargin: 50
        width: 140
        height: 80
        background: Image {
            source: whiteOrGray ? "qrc:/icons/btn_icons/btn_threeh_white.png" : "qrc:/icons/btn_icons/btn_threeh_gray.png"
            anchors.centerIn: parent
            width: 32
            height: 32
        }

        onClicked: {
            app_swipeView.visible = false
            clearAppRect.visible = true
            QmlEvents.startClearApp()
            if (appinitFgShow)
                closeAppInitFg()
            bt_three.enabled = false
            if (delayToStartFlag)
                return
            // full to destory app
            delayToStartFlag = false
            board.killLive555()
            board.playSound()
            for (var i = 0; i < app_swipeView.count; i++) {
                var object = app_swipeView.itemAt(i)
                object.destroy()
            }

            for (var j = 0; j < app_swipeView.count; j++) {
                app_swipeView.removeItem(j)
            }
            //app_swipeView.visible = false
        }

        Rectangle {
            id: bt_threebg
            height: parent.height
            width: parent.width / 2
            opacity: 0
            anchors.centerIn: parent
            radius: 40
            color: whiteOrGray ? "white" : "#7f7f7f"
        }

        states: State {
            name: "show"; when: bt_three.pressed
            PropertyChanges { target: bt_threebg; opacity: 0.3; width: parent.width}
        }

        transitions: Transition {
            NumberAnimation { properties: "opacity"; easing.type: Easing.OutCubic; duration: 300 }
            NumberAnimation { properties: "width"; easing.type: Easing.OutCubic; duration: 300 }
        }
    }

    InputPanel {
        id: inputPanel
        z: 88
        x: 0
        y: root.height
        width: root.width

        states: State {
            name: "visible"
            when: inputPanel.active
            PropertyChanges {
                target: inputPanel
                y: root.height - inputPanel.height
            }
        }
        transitions: Transition {
            from: ""
            to: "visible"
            reversible: true
            ParallelAnimation {
                NumberAnimation {
                    properties: "y"
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }
        onYChanged: {
            if (inputPanel.y == root.height)
                inputPanel.visible = false
            else if (root.height - inputPanel.height)
                inputPanel.visible = true
        }
    }

    Binding {
        target: VirtualKeyboardSettings
        property: "activeLocales"
        value: ["zh_CN","en_US"]
    }

    Rectangle {
        z: 100
        id: clearAppRect
        anchors.fill: parent
        visible: false
        color: "#55555555"
        CircleProcBar {
            id: circleProcBar
            anchors.centerIn: parent
        }
    }

    Connections{
        target: QmlEvents
        onClearAppFinished: {
            clearAppRect.visible = false
        }
    }
}
