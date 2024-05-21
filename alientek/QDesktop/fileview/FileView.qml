/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   QDesktop
* @brief         FileView.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-09-18
*******************************************************************/
import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick 2.3
import Qt.labs.folderlistmodel 2.1
import QtQuick.Controls.Styles 1.2
import QtQuick.Controls 1.2
import QtQuick.Controls 2.5
import fileIO 1.0
Item {
    id : app_fileView
    y: app_fileView.height
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
                target: app_fileView
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

    FileIO {
        id: myFile
        onError: console.log(msg)
    }

    Rectangle {
        anchors.fill: parent
        color: "#eff2f7"
    }

    Row {
        id: app_fileView_row1
        anchors.top: parent.top
        anchors.topMargin: 30
        height: 40
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10

        RadioButton {
            id: local_bt
            checked: true
            width: 100
            height: 40
            contentItem:Text {
                font.pixelSize: 25
                text: qsTr("存储")
                font.family: "Montserrat Light"
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: local_bt.checked ? "#0b86fd" : "88101010"
                font.underline: true
            }
            indicator: Rectangle {
                width: 0
                height: 0
                color: "transparent"
            }
        }

        RadioButton {
            id: sd_bt
            checked: false
            width: 100
            height: 40
            contentItem:Text {
                font.pixelSize: 25
                text: qsTr("SD")
                font.family: "Montserrat Light"
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: sd_bt.checked ? "#0b86fd" : "88101010"
            }
            indicator: Rectangle {
                width: 0
                height: 0
                color: "transparent"
            }
        }
    }

    Rectangle {
        anchors.top: app_fileView_row1.bottom
        anchors.topMargin: -35
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 80

        id: myFileView
        color: "transparent"

        property string folderPathName: !linuxEnv ? "file:///C:/Users/Administrator/Desktop/" : "file:/"
        property bool myFileViewPath: false
        property string currtentPathName
        property int pathIndexCount: 0
        Component.onCompleted: {
            pathIndex.model.insert(pathIndex.model.count, {"myPathName": !linuxEnv ? "C:/Users/Administrator/Desktop" : " / ",
                                       "myPath": !linuxEnv ? "file:///C:/Users/Administrator/Desktop/" : "file:/"})
            myFileView.pathIndexCount = pathIndex.count
            pathIndex.currentIndex = pathIndex.count -1
        }

        ListView {
            id: pathIndex
            anchors.top: parent.top
            anchors.topMargin: 30
            anchors.left: parent.left
            anchors.leftMargin: 0
            width: myFileView.width
            height: 40
            clip: true
            spacing: 2
            orientation : ListView.Horizontal
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                z: -1
            }
            delegate:Rectangle{
                width: pathText.contentWidth
                height: 40
                color: "transparent"
                radius: 1
                Text{
                    id: pathText
                    color: parent.ListView.isCurrentItem ? "black": "#88101010"
                    text: myPathName
                    font.pixelSize: 20
                    anchors.centerIn: parent
                    font.bold: true
                }
                Text {
                    id: textMyPath
                    visible: false
                    text: myPath
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        myFileView.folderPathName = pathIndex.model.get(index).myPath
                        if (index < pathIndex.count - 1)
                            for(var i = index;  i < myFileView.pathIndexCount -1 ; i++ ){
                                listmodel.remove(index+1)
                            }
                        myFileView.pathIndexCount = pathIndex.count
                    }
                }
            }
            model:ListModel{
                id:listmodel
            }
        }

        function insertItem(){
            pathIndex.model.insert(pathIndex.model.count, {"myPathName":"> " + myFileView.currtentPathName, "myPath": myFileView.folderPathName})
            myFileView.pathIndexCount = pathIndex.count
            pathIndex.currentIndex = pathIndex.count -1
        }

        ListView {
            id: listFileView
            spacing: 2
            ScrollBar.vertical: ScrollBar {
                id: scrollBar
                z: 20
                width: 5
                hoverEnabled: true
                background: Rectangle {color: "#33bbbbbb"}
                onActiveChanged: {
                    active = true;
                }
                Component.onCompleted: {
                    scrollBar.active = true;
                }
                contentItem: Rectangle{
                    implicitWidth: 5
                    implicitHeight: 100
                    radius: 2
                    color: scrollBar.hovered ? "black" : "#88101010"
                }
            }
            anchors{
                bottom: parent.bottom
                bottomMargin: 4
                right: myFileView.right
                left: myFileView.left
                top: pathIndex.bottom
            }
            clip: true
            delegate:Rectangle{
                height: 60
                width: myFileView.width
                color: "transparent"
                Image {
                    id: folderIcon
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                    width: 60
                    height: 60
                    opacity: 1
                    source: folderModel.get(index, "fileIsDir") ? "qrc:/icons/folder.png"  : "qrc:/icons/other_file.png"
                }
                Text {
                    id: textfileName
                    text: fileName
                    width: parent.width - 40
                    color: "black"
                    font.pixelSize: 18
                    font.bold: true
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    anchors.left: folderIcon.right
                    anchors.leftMargin: 10
                }
                Text {
                    id: textModify
                    text: fileModified
                    anchors.top: textfileName.bottom
                    anchors.topMargin: 10
                    anchors.left: textfileName.left
                    color: "#88101010"
                    font.bold: true
                    font.pixelSize: 13
                }
                Rectangle{
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    anchors.right: parent.right
                    anchors.rightMargin: 15
                    height: 1
                    z: -1
                    color: "#88101010"
                }
                Image {
                    id: next
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.rightMargin: 15
                    anchors.topMargin: 30
                    source: folderModel.get(index, "fileIsDir") ? "qrc:/icons/next.png" : ""
                    width: 20
                    height: 20
                    opacity: 0.6
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(folderModel.isFolder(index)){
                            myFileView.folderPathName = folderModel.get(index, "fileURL")
                            myFileView.currtentPathName=folderModel.get(index, "fileName")
                            myFileView.insertItem()
                        } else {
                            var size = folderModel.get(index, "fileSize")
                            if (size < 10000) {
                                switch (folderModel.get(index, "fileSuffix")) {
                                case "txt":
                                case "sh":
                                case "conf":
                                case "cpp":
                                case "c":
                                case "h":
                                case "sh":
                                case "local":
                                case "lrc":
                                case "blacklist":
                                case "py":
                                    break
                                default:
                                    warningDialog.open()
                                    return;
                                }
                                file_open_dialog.open()
                                myFile.source = folderModel.get(index, "filePath")
                                myText.text = myFile.read()
                            } else {
                                warningDialog.open()
                            }
                        }

                    }
                }
            }
            model: FolderListModel{
                id:folderModel
                objectName: "folderModel"
                showDirs: true
                showFiles: true
                showDirsFirst: true
                showDotAndDotDot :false
                nameFilters: ["*"]
                folder:myFileView.folderPathName
                onFolderChanged: {

                }
            }
        }
    }

    Rectangle {
        id: warningDialog
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        visible: false
        color: "#55101010"

        function close() {
            warningDialog.visible = false
        }

        function open() {
            warningDialog.visible = true
        }

        MouseArea {
            anchors.fill: parent
            onClicked: warningDialog.close()
        }
        Rectangle {
            id: center_Rect
            width: parent.width - 100
            height: 300
            color: "#f0f0f0"
            radius: 20
            anchors.centerIn: parent
            Text {
                anchors.top: parent.top
                height: parent.height / 3
                width: parent.width
                color: "black"
                font.pixelSize: 30
                font.family: "Montserrat Light"
                text: "警告"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
                wrapMode: Text.WordWrap
            }
            Text {
                anchors.centerIn: parent
                width: parent.width
                color: "black"
                font.pixelSize: 25
                font.family: "Montserrat Light"
                text: "文件太大或未知类型！"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }
            Rectangle {
                width: parent.width
                height: 1
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#d2d3d5"
                anchors.bottom: finish_button.top
            }
            Rectangle {
                width: parent.width
                height: 20
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: finish_button.top
                color: finish_button.pressed ?  "#dddddd" : "transparent"
            }
            Button {
                id: finish_button
                anchors.bottom: parent.bottom
                width: parent.width
                height: center_Rect.height / 3
                background: Rectangle {
                    anchors.fill: parent
                    radius: center_Rect.radius
                    color: finish_button.pressed ?  "#dddddd" : "transparent"
                }

                Text {
                    id: finish_bt
                    font.pixelSize: 30
                    text: qsTr("完成")
                    font.family: "Montserrat Light"
                    anchors.centerIn: parent
                    color: "#007aff"
                }
                onClicked: warningDialog.close()
            }
        }
    }

    Rectangle {
        id: file_open_dialog
        width: parent.width
        height: parent.height
        visible: false
        anchors.centerIn: parent
        color: "white"
        function close() {
            file_open_dialog.visible = false
        }

        function open() {
            file_open_dialog.visible = true
        }
        Rectangle {
            id: top_Rect
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 80
            color: "#eff2f7"

            Button {
                id: back_bt
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                width: 80
                background: Image {
                    width: 40
                    source: "qrc:/icons/back.png"
                }
                onClicked: {
                    myText.text = ""
                    file_open_dialog.close()
                }
                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("文件")
                    font.family: "Montserrat Light"
                    color: "#0b62f6"
                    font.pixelSize: 20
                    font.underline: true
                }
            }

        }

        Rectangle {
            id: bottom_Rect
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 60
            color: "#eff2f7"

        }

        Flickable {
            anchors.top: top_Rect.bottom
            anchors.bottom: bottom_Rect.top
            width: parent.width
            height: parent.height
            contentWidth: parent.width
            contentHeight: myText.height
            clip: true
            Text {
                id: myText
                width: parent.width
                wrapMode: Text.WrapAnywhere
                color: "black"
                font.bold: true
                font.pixelSize: 15
                font.family: "Montserrat Light"
            }
            ScrollBar.vertical: ScrollBar {
                id: scrollBar2
                z: 20
                hoverEnabled: true
                anchors.right: parent.right
                anchors.rightMargin: -20
                width: 5
                background: Rectangle {
                    color: "#33bbbbbb"
                }
                onActiveChanged: {
                    active = true
                }
                Component.onCompleted: {
                    scrollBar.active = true
                }
                contentItem: Rectangle{
                    implicitWidth: 1
                    implicitHeight: 100
                    radius: 1
                    color: scrollBar.hovered ? "black" : "88101010"
                }
            }
        }
    }
}

