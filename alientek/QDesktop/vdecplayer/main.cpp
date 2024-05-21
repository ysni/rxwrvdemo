/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   camera
* @brief         main.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-09-22
*******************************************************************/
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlComponent>

#include "vdecplayeritem.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<VdecPlayerItem>("vdecplayer", 1, 0, "VdecPlayerItem");

    engine.load(QUrl(QStringLiteral("qrc:/VdecPlayer_Window.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
