/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   QDesktop
* @brief         WeatherPage1.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-10-27
*******************************************************************/
import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Window 2.3
import QtCharts 2.2
import QtQuick.Controls 2.5

Item {
    id: w1

    Item {
        anchors.top: parent.top
        anchors.topMargin: refreshButton.y + refreshButton.height + 150
        width: parent.width
        anchors.bottom: parent.bottom

        Flickable {
            id: wpage1
            anchors.fill: parent
            interactive: true
            clip: true
            contentWidth: parent.width
            contentHeight: w1.height < 480 ? parent.height + 160 :  parent.height + 1
            property int pullHeight: 20

            states: [
                State {
                    id: downRefreshState
                    name: "downRefresh"
                    when: wpage1.contentY < -wpage1.pullHeight
                    StateChangeScript{
                        script:{
                            //print("下拉刷新")
                            wpage1.y = wpage1.pullHeight
                            weatherModel.downRefresh()
                        }
                    }
                },
                State {
                    when: wpage1.contentX > 400
                    StateChangeScript{
                        script:{
                            weatherSwipeView.setCurrentIndex(1)
                            print("进入页面二")
                            WeatherPage1.visible = false
                            WeatherPage2.visible = true
                        }
                    }
                }
            ]

            Text {
                id: cTemp
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 60
                font.family: "Montserrat Light"
                color: "white"
                text: weatherModel.ready ? weatherModel.cTemp + "°" : "..."
            }

            Text {
                id: weatherType
                anchors.left: cTemp.right
                anchors.top: cTemp.top
                font.family: "Montserrat Light"
                color: "white"
                font.pointSize: 20
                text: weatherModel.ready ? weatherModel.weatherData[0].weather : "载入中..."
            }

            Rectangle {
                id: tipsRect
                anchors.top: cTemp.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                height: tipsRectText.contentHeight + 10
                width: tipsRectText.contentWidth + 10
                radius: height / 2
                color: "#44aaff"

                Text {
                    id: tipsRectText
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: weatherModel.ready ? "温馨提示：" + weatherModel.indexData[0].descript : ""
                    font.family: "Montserrat Light"
                    color: "white"
                    font.pointSize: 10
                }
            }

            ListView {
                id: futureWeather
                anchors.top: tipsRect.bottom
                anchors.topMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 100
                clip: true
                //width: contentWidth
                visible: true
                orientation: ListView.Vertical
                spacing: 2
                model: weatherModel.weatherData
                delegate: delegate
            }

            Component {
                id: delegate
                Rectangle {
                    width: futureWeather.width
                    height: 80
                    color: "#44aaff"
                    radius: 10

                    Image {
                        id: dayAndNight
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.topMargin: 2
                        height: parent.height  - 20
                        mipmap: true
                        fillMode: Image.PreserveAspectFit
                        source: weatherModel.ready ? (dayOrNight ? nightPicture : dayPicture) : ""
                    }

                    Text{
                        id: dateText
                        anchors.left: dayAndNight.right
                        anchors.leftMargin: 20
                        anchors.verticalCenter: parent.verticalCenter
                        font.family: "Montserrat Light"
                        font.pointSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: (index != 0 ? date : "今日") + "·"
                        color: "white"
                    }

                    Text {
                        id: weatherText
                        font.family: "Montserrat Light"
                        anchors.left: dateText.right
                        anchors.verticalCenter: parent.verticalCenter
                        font.pointSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: weatherModel.ready ? weather : "未知"
                        color: "white"
                    }

                    Rectangle {
                        id: windTextRect
                        anchors.right: parent.right
                        anchors.rightMargin:  20
                        anchors.verticalCenter: parent.verticalCenter
                        width: windText.contentWidth + 30
                        height: windText.contentHeight + 20
                        radius: height / 2
                        color: "#88aaff"
                        Text {
                            anchors.centerIn: parent
                            id: windText
                            font.family: "Montserrat Light"
                            font.pointSize: 10
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: weatherModel.ready ? wind : "未知"
                            color: "white"
                        }
                    }

                    Text {
                        id: temperatureText
                        font.family: "Montserrat Light"
                        font.pointSize: 12
                        anchors.right: windTextRect.left
                        anchors.rightMargin: 20
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: weatherModel.ready ? weatherModel.weatherData[index].minTemperature + " / " +
                                                   weatherModel.weatherData[index].maxTemperature + "℃" : "未知"
                        color: "white"
                    }
                }
            }
        }
    }

    Text {
        id: city
        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 20
        font.family: "Montserrat Light"
        font.bold: true
        text:  weatherModel.ready ? "当前城市：" + weatherModel.city : "载入中..."
        color: "white"
    }

    Button {
        id: refreshButton
        width: refreshButtonText.contentWidth + 10
        height: refreshButtonText.contentHeight + 10
        anchors.top: city.bottom
        anchors.topMargin: 50
        anchors.right: parent.horizontalCenter
        anchors.rightMargin: 20
        background: Rectangle {
            anchors.fill: parent
            color: refreshButton.pressed ? "#10dddddd" : "#44aaff"
            radius: parent.height / 2
            Text {
                id: refreshButtonText
                text: qsTr("点击获取当前城市天气")
                anchors.centerIn: parent
                color: "white"
                font.pointSize: 12
                font.family: "Montserrat Light"
            }
        }
        onClicked: {
            weatherModel.downRefresh()
        }
    }

    Button {
        id: check_futrueWeather_chart_button
        width: check_futrueWeather_chart_buttonText.contentWidth + 10
        height: check_futrueWeather_chart_buttonText.contentHeight + 10
        anchors.top: city.bottom
        anchors.topMargin: 50
        anchors.left: parent.horizontalCenter
        anchors.leftMargin: 20
        background: Rectangle {
            anchors.fill: parent
            color: check_futrueWeather_chart_button.pressed ? "#10dddddd" : "#44aaff"
            radius: parent.height / 2
            Text {
                id: check_futrueWeather_chart_buttonText
                text: qsTr("查看近5日天气温度趋势")
                anchors.centerIn: parent
                color: "white"
                font.pointSize: 12
                font.family: "Montserrat Light"
            }
        }
        onClicked: {
            weatherSwipeView.currentIndex = 1
        }
    }

    Connections{
        target: weatherModel
        onReadyChanged:{
            if (weatherModel.ready)
                refreshAnimation.restart()
        }
    }

    NumberAnimation {
        id: refreshAnimation
        target: wpage1
        property: "y"
        duration: 200
        from: wpage1.pullHeight
        to: 0
        easing.type: Easing.Linear
    }
}
