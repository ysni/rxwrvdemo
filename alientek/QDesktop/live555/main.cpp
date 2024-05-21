#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "live555thread.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    qmlRegisterType<Live555Thread>("live555Thread", 1, 0, "Live555Thread");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/Live555_Windows.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
