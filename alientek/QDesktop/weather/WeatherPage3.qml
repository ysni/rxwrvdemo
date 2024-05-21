/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   QDesktop
* @brief         WeatherPage3.qml
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
    id: w3

    Item {
        anchors.top: parent.top
        width: parent.width
        anchors.bottom: parent.bottom

        Flickable {
            id: wpage1
            anchors.fill: parent
            interactive: true
            clip: true
            contentWidth: parent.width
            contentHeight: w3.height < 480 ? parent.height + 160 :  parent.height + 1
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
                id:  city
                anchors.top: parent.top
                anchors.topMargin: 30
                anchors.left: parent.left
                anchors.leftMargin: 20
                text: weatherModel.ready ?  weatherModel.city : "未知城市"
                color: "white"
                font.family: "Montserrat Light"
                font.pixelSize: 50
                font.bold: true
            }

            Text {
                id:  temp
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.top: city.bottom
                text: weatherModel.ready ? weatherModel.cTemp + "°" : "..."
                color: "white"
                font.family: "Montserrat Light"
                font.pixelSize: 100
            }

            Image {
                id: todayWeather
                width: 100
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.top: parent.top
                anchors.topMargin: 30
                fillMode: Image.PreserveAspectFit
                source: weatherModel.ready ? (dayOrNight ? weatherModel.weatherData[0].nightPicture : weatherModel.weatherData[0].dayPicture) : ""
            }

            Text {
                id: todayWeatherType
                anchors.top: todayWeather.bottom
                anchors.right: parent.right
                anchors.rightMargin: 20
                text: weatherModel.ready ?  weatherModel.weatherData[0].weather : ""
                color: "white"
                font.family: "Montserrat Light"
                font.pixelSize: 20
            }

            Text {
                id: tempRange
                anchors.top: todayWeatherType.bottom
                anchors.right: parent.right
                anchors.rightMargin: 20
                text: weatherModel.ready ? weatherModel.weatherData[0].minTemperature + " / " +
                                           weatherModel.weatherData[0].maxTemperature + "℃" : "未知"
                color: "white"
                font.family: "Montserrat Light"
                font.pixelSize: 20
            }

            Text {
                id: tipsRectText
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.verticalCenter
                text: weatherModel.ready ? "温馨提示：" + weatherModel.indexData[0].descript : ""
                font.family: "Montserrat Light"
                color: "#f0f0f0"
                font.pointSize: 12
                visible: app_weather.width >= 800
            }

            ListView {
                visible: app_weather.width >= 800
                id: futureWeather
                anchors.top: parent.verticalCenter
                anchors.bottom: parent.bottom
                width: parent.width
                clip: true
                orientation: ListView.Horizontal
                model: weatherModel.weatherData
                delegate: delegate
            }

            Component {
                id: delegate
                Rectangle {
                    width: futureWeather.width / 5
                    height: futureWeather.height
                    color: !dayOrNight ? "#4580bb" : "#0b4c8c"

                    Column {
                        anchors.fill: parent
                        spacing: (height - dateText.height - dayAndNight.height - weatherText.height - temperatureText.height - windTextRect.height - 40) / 6
                        Item {
                            height: 20
                            width: parent.width
                        }
                        Text{
                            id: dateText
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.family: "Montserrat Light"
                            font.pointSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: (index != 0 ? date : "今日")
                            color: "white"
                        }

                        Image {
                            id: dayAndNight
                            width: 80
                            anchors.horizontalCenter: parent.horizontalCenter
                            fillMode: Image.PreserveAspectFit
                            source: weatherModel.ready ? (dayOrNight ? nightPicture : dayPicture) : ""
                        }

                        Text {
                            id: weatherText
                            font.family: "Montserrat Light"
                            font.pointSize: 12
                            anchors.horizontalCenter: parent.horizontalCenter
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: weatherModel.ready ? weather : "未知"
                            color: "white"
                        }

                        Text {
                            id: temperatureText
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.family: "Montserrat Light"
                            font.pointSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: weatherModel.ready ? weatherModel.weatherData[index].minTemperature + " / " +
                                                       weatherModel.weatherData[index].maxTemperature + "℃" : "未知"
                            color: "white"
                        }

                        Rectangle {
                            id: windTextRect
                            anchors.horizontalCenter: parent.horizontalCenter
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
                        Item {
                            height: 20
                            width: parent.width
                        }
                    }
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
    }
}
