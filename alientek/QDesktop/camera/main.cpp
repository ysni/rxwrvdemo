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

#include "../camera/capturethread.h"
#include "../camera/cameraitem.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<CameraItem>("cameraItem", 1, 0, "CameraItem");

    engine.load(QUrl(QStringLiteral("qrc:/ATKCamera_Window.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
