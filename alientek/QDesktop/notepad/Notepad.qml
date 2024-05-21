/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   notepad
* @brief         Notepad_Window.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-10-25
*******************************************************************/
import QtQuick 2.12
import QtQuick.VirtualKeyboard 2.4
import QtQuick.VirtualKeyboard.Settings 1.2
import QtQuick.Controls 2.5

import notepadModel 1.0
import fileReadWrite 1.0

Item {
    id: app_Notepad
    property string fileTextContent
    y: app_Notepad.height
    x: 0
    opacity: 0
    property real showPropertyChangeOpacity: 1
    property real showPropertyChangeX: 0
    property real showPropertyChangeY: 0
    property bool show: false

    state: ""
    states:[
        State {
            name: "show"
            PropertyChanges {
                target: app_Notepad
                opacity: showPropertyChangeOpacity
                x: showPropertyChangeX
                y: showPropertyChangeY
            }
            when: !show
        }
    ]

    transitions: Transition {
        NumberAnimation{properties: "x,y"; easing.type: Easing.InOutQuad; duration: 0}
        NumberAnimation{properties: "opacity"; easing.type: Easing.InOutQuad; duration: 0}
    }

    NotepadListModel {
        id: notepadModel
    }

    FileReadWrite {
        id: fileReadWrite
    }

    Component.onCompleted: {
        notepadModel.add(appCurrtentDir +  "/src/txt")
    }

    Rectangle {
        anchors.fill: parent
        color: "#f7f7f7"
    }

    SwipeView {
        id: notepad_swipeView
        visible: true
        anchors.fill: parent
        clip: true
        interactive: false
        FileListView { }
        TextEditor { }
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

        FileDelete {
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

    /*InputPanel {
        id: inputPanel
        z: 99
        x: 0
        y: app_Notepad.height
        width: app_Notepad.width

        states: State {
            name: "visible"
            when: inputPanel.active
            PropertyChanges {
                target: inputPanel
                y: app_Notepad.height - inputPanel.height
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
        onYChanged: console.log(y)
    }

    Binding {
        target: VirtualKeyboardSettings
        property: "activeLocales"
        value: ["zh_CN","en_US"]
    }*/
}
