/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   objectrecognition
* @brief         main.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-29
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlComponent>

#include "objectrecognitionitem.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<ObjectRecognitionItem>("objectrecognitionitem", 1, 0, "ObjectRecognitionItem");

    engine.load(QUrl(QStringLiteral("qrc:/ObjectRecognition_Window.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
