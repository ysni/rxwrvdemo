/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   weather
* @brief         WeatherPage2.qml
* @author        Deng Zhimao
* @email         1252699831@qq.com
* @date          2020-07-31
*******************************************************************/
import QtQuick 2.7
import QtQuick.Controls 2.2
import QtCharts 2.2
Item{
    id: w2

    Connections{
        target: weatherModel
        onReadyChanged:{
            if (weatherModel.ready){
                refreshAnimation.restart();
                maxSeries.clear()
                minSeries.clear()
                for (var i = 0; i <= 4; i++){
                    maxSeries.append(i + 1, weatherModel.weatherData[i].maxTemperature)
                    minSeries.append(i + 1, weatherModel.weatherData[i].minTemperature)
                }
            }
        }
    }

    NumberAnimation{
        id: refreshAnimation
        target: wpage2
        property: "y"
        duration: 200
        from: wpage2.pullHeight
        to: 0
        easing.type: Easing.Linear
    }

    Flickable {
        id: wpage2
        anchors.fill: parent
        interactive: true
        contentWidth: parent.width
        contentHeight: parent.height + 1
        property int pullHeight: 20

        states: [
            State {
                id: downRefreshState
                name: "downRefresh"
                when: wpage2.contentY < -wpage2.pullHeight
                StateChangeScript{
                    script:{
                        //print("下拉刷新")
                        wpage2.y = wpage2.pullHeight
                        weatherModel.downRefresh();
                    }
                }
            },
            State {
                when: wpage2.contentX < -40
                StateChangeScript{
                    script:{
                        weatherSwipeView.setCurrentIndex(0)
                        print("返回页面一")
                        WeatherPage1.visible = true
                        WeatherPage2.visible = false
                    }
                }
            }
        ]

        ChartView {
            id: futureChart
            anchors.fill: parent
            title: qsTr("未来温度走势")
            titleFont.family: "Montserrat Light"
            titleFont.bold: true
            titleFont.pixelSize: 20
            titleColor: "white"
            // Set the header to be invisible
            legend.visible: false
            antialiasing: true
            //backgroundColor: dayOrNight ? "#666666" : "#1498e8"
            backgroundColor: "transparent"
            margins.bottom: 50
            margins.top: 50
            margins.left: 50
            margins.right: 50
            //plotAreaColor: "#44aaff"
            plotAreaColor: "transparent"
            Component.onCompleted:{
                futureChart.axisX().visible = false
                futureChart.axisY().visible = false
            }
            ValueAxis{
                id: axisX
                min: 0
                max: 6
            }
            ValueAxis{
                id: axisY
                min: -20
                max: 80
            }

            LineSeries {
                id: maxSeries
                //name: "最高温"
                pointLabelsFont.family: "Montserrat Light"
                pointLabelsFont.pointSize: 15
                pointLabelsVisible: true
                //更改label的格式
                pointLabelsFormat: "@yPoint °"
                pointLabelsColor: "white"
                color: "white"
                pointLabelsFont.bold: true
                width: 2
                axisX: axisX
                axisY: axisY
            }

            LineSeries{
                id: minSeries
                //name: "最低温"
                pointLabelsFont.family: "Montserrat Light"
                pointLabelsFont.pointSize: 15
                pointLabelsVisible: true
                pointLabelsFormat: "@yPoint °"
                pointLabelsColor: "white"
                pointLabelsFont.bold: true
                color: "#0d29d7"
                width: 2
                axisX: axisX
                axisY: axisY
            }
        }
    }
}

