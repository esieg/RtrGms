#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include "labyrinth.h"

int main(int argc, char *argv[])
{
    //add specific buildvariables
    qputenv("QML_XHR_ALLOW_FILE_READ", QByteArray("1"));

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // add and register custom Objects to QML
    Labyrinth labyrinth;
    engine.rootContext()->setContextProperty("labyrinth", &labyrinth);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("RtrGms", "Main");

    return app.exec();
}
