import QtQuick 2.5
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QmlEvents 1.0

Canvas {
    id: canvas
    width: 200
    height: 200
    antialiasing: true

    property color primaryColor: "#aa00ebe1"
    property color secondaryColor: "#55555555"

    property real centerWidth: width / 2
    property real centerHeight: height / 2
    //property real radius: Math.min(canvas.width, canvas.height) / 2
    property real radius: Math.min(canvas.width-10, canvas.height - 40) / 2

    property real minimumValue: 0
    property real maximumValue: 50
    property real currentValue: 0

    // this is the angle that splits the circle in two arcs
    // first arc is drawn from 0 radians to angle radians
    // second arc is angle radians to 2*PI radians
    property real angle: (currentValue - minimumValue) / (maximumValue - minimumValue) * 2 * Math.PI

    // we want both circle to start / end at 12 o'clock
    // without this offset we would start / end at 9 o'clock
    property real angleOffset: -Math.PI / 2

    signal clicked()
    onPrimaryColorChanged: requestPaint()
    onSecondaryColorChanged: requestPaint()
    onMinimumValueChanged: requestPaint()
    onMaximumValueChanged: requestPaint()
    onCurrentValueChanged: requestPaint()
    onPaint: {
        var ctx = getContext("2d")
        ctx.save()

        ctx.clearRect(0, 0, canvas.width, canvas.height)

        // fills the mouse area when pressed
        // the fill color is a lighter version of the
        // secondary color

        if (mouseArea.pressed) {
            ctx.beginPath()
            ctx.lineWidth = 40
            ctx.fillStyle = Qt.lighter(canvas.secondaryColor, 1.25)
            ctx.arc(canvas.centerWidth,
                    canvas.centerHeight,
                    canvas.radius,
                    0,
                    2 * Math.PI)
            ctx.fill()

            timer.running = true
        }

        // First, thinner arc
        // From angle to 2*PI

        ctx.beginPath()
        ctx.lineWidth = 40
        ctx.strokeStyle = primaryColor
        ctx.arc(canvas.centerWidth,
                canvas.centerHeight,
                canvas.radius,
                angleOffset + canvas.angle,
                angleOffset + 2 * Math.PI)
        ctx.stroke()


        // Second, thicker arc
        // From 0 to angle

        ctx.beginPath()
        ctx.lineWidth = 40
        ctx.strokeStyle = canvas.secondaryColor
        ctx.arc(canvas.centerWidth,
                canvas.centerHeight,
                canvas.radius,
                canvas.angleOffset,
                canvas.angleOffset + canvas.angle)
        ctx.stroke()

        ctx.restore()
    }

    Text {
        id: txt_progress
        anchors.centerIn: parent
        text: "清理应用"
        font.pixelSize: 20
        color: "white"
        font.family: "Montserrat Regular"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: canvas.clicked()
        onPressedChanged: canvas.requestPaint()
    }


    Timer{
        id: timer
        interval: 20
        running: false
        repeat: true
        onTriggered: {
            if(currentValue === 50) {
                currentValue = 50
                timer.stop()
                QmlEvents.clearAppFinished()
                bt_three.enabled = true
                delayToStartFlag = false
                return
            }
            currentValue += 1
        }
    }

    Connections{
        target: QmlEvents
        onStartClearApp: {
            timer.start()
            currentValue = 0
        }
    }
}
