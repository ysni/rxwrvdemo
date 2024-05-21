/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   recorder
* @brief         main.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-19
* @link          www.opendev.com
*******************************************************************/
#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QQmlContext>
#include <QDir>
#include <QApplication>
#include <QTextCodec>

#include "recordListModel.h"
#include "recordcontrol.h"

int main(int argc, char *argv[])
{

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<RecordListModel>("recordListModel", 1, 0, "RecordListModel");
    qmlRegisterType<RecordControl>("recordControl", 1, 0, "RecordControl");

    engine.rootContext()->setContextProperty("appCurrtentDir", QCoreApplication::applicationDirPath());

    QDir::setCurrent(QCoreApplication::applicationDirPath());

    QTextCodec::setCodecForLocale(QTextCodec::codecForName("UTF-8"));

    const QUrl url(QStringLiteral("qrc:/Recorder_Window.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
