#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "photolistmodel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<PhotoListModel>("photoListModel", 2, 0, "PhotoListModel");
    engine.rootContext()->setContextProperty("appCurrtentDir", QCoreApplication::applicationDirPath());

    const QUrl url(QStringLiteral("qrc:/PhotoView_Window.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
