/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   fileview
* @brief         main.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-09-18
*******************************************************************/

#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QQmlContext>

#include "fileio.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    qmlRegisterType<FileIO, 1>("fileIO", 1, 0, "FileIO");
    bool linuxEnv;
#if linux
    linuxEnv = true;
#else
    linuxEnv = false;
#endif

    engine.rootContext()->setContextProperty("linuxEnv", linuxEnv);
    const QUrl url(QStringLiteral("qrc:/FileView_Window.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
