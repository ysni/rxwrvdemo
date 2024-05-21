#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>


#include "../music/lyricmodel.h"
#include "../music/playlistmodel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("appCurrtentDir", QCoreApplication::applicationDirPath());
    qmlRegisterType<lyricModel>("dataModel", 1, 0, "LyricModel");
    qmlRegisterType<playListModel>("dataModel", 1, 0, "PlayListModel");
    const QUrl url(QStringLiteral("qrc:/Music_Window.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
