/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtQuick.Window 2.12
import "content/calculator.js" as CalcEngine

Window {
    visible: true
    width: 800
    height: 480

    Rectangle {
        anchors.fill: parent
        color: "#010101"
    }

    id: calculator
    function operatorPressed(operator) {
        CalcEngine.operatorPressed(operator)
        numPad.buttonPressed()
    }
    function digitPressed(digit) {
        CalcEngine.digitPressed(digit)
        numPad.buttonPressed()
    }
    function isButtonDisabled(op) {
        return CalcEngine.disabled(op)
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_0)
            digitPressed("0")
        else if (event.key === Qt.Key_1)
            digitPressed("1")
        else if (event.key === Qt.Key_2)
            digitPressed("2")
        else if (event.key === Qt.Key_3)
            digitPressed("3")
        else if (event.key === Qt.Key_4)
            digitPressed("4")
        else if (event.key === Qt.Key_5)
            digitPressed("5")
        else if (event.key === Qt.Key_6)
            digitPressed("6")
        else if (event.key === Qt.Key_7)
            digitPressed("7")
        else if (event.key === Qt.Key_8)
            digitPressed("8")
        else if (event.key === Qt.Key_9)
            digitPressed("9")
        else if (event.key === Qt.Key_Plus)
            operatorPressed("+")
        else if (event.key === Qt.Key_Minus)
            operatorPressed("−")
        else if (event.key === Qt.Key_Asterisk)
            operatorPressed("×")
        else if (event.key === Qt.Key_Slash)
            operatorPressed("÷")
        else if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return)
            operatorPressed("=")
        else if (event.key === Qt.Key_Comma || event.key === Qt.Key_Period)
            digitPressed(".")
        else if (event.key === Qt.Key_Backspace)
            operatorPressed("backspace")
    }

    Display {
        id: display
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        width: numPad.width
        anchors.bottom: numPad.top
        clip: true
    }

    NumberPad {
        id: numPad
        height: (parent.height - 40) / 6 * 4
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }
}
