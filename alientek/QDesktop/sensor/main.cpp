#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "ap3216c.h"
#include "icm20608.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<Ap3216c>("ap3216c", 1, 0, "Ap3216c");
    qmlRegisterType<Icm20608>("icm20608", 1, 0, "Icm20608");

    bool armEnv;
#if __arm__
    armEnv = true;
#else
    armEnv = false;
#endif
    engine.rootContext()->setContextProperty("armEnv", armEnv);

    const QUrl url(QStringLiteral("qrc:/Sensor_Window.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
