/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   notepad
* @brief         main.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-10-25
*******************************************************************/
#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QQmlContext>
#include <QDir>
#include <QApplication>
#include <QTextCodec>

#include "notepadListModel.h"
#include "filereadwrite.h"

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    engine.addImportPath(":/CustomStyle");
    qputenv("QT_VIRTUALKEYBOARD_STYLE", "greywhite");

    qmlRegisterType<NotepadListModel>("notepadModel", 1, 0, "NotepadListModel");

    qmlRegisterType<FileReadWrite>("fileReadWrite", 1, 0, "FileReadWrite");

    engine.rootContext()->setContextProperty("appCurrtentDir", QCoreApplication::applicationDirPath());

    QDir::setCurrent(QCoreApplication::applicationDirPath());

    QTextCodec::setCodecForLocale(QTextCodec::codecForName("UTF-8"));

    const QUrl url(QStringLiteral("qrc:/Notepad_Window.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
