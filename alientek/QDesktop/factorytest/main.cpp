#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "factory.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<Factory>("factory", 1, 0, "Factory");
    bool armEnv;
#if __arm__
    armEnv = true;
#else
    armEnv = false;
#endif
    engine.rootContext()->setContextProperty("armEnv", armEnv);

    const QUrl url(QStringLiteral("qrc:/FactoryTest_Window.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
