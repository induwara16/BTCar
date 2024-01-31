#include <QClipboard>
#include <QFontDatabase>
#include <QGuiApplication>
#include <QIcon>
#include <QLocale>
#include <QTranslator>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "bluetooth.h"
#include "platformutil.h"

static Bluetooth *bt;
static QtMessageHandler messageHandler;

static void handleMessage(QtMsgType type, const QMessageLogContext &context, const QString &message)
{
    // NOTE org.bluez.Error.AuthenticationCanceled does not trigger QBluetoothLocalDevice::errorOccurred

    messageHandler(type, context, message);

    if (
        context.category == QStringLiteral("qt.bluetooth.bluez") &&
        message == "Failed to create pairing \"org.bluez.Error.AuthenticationCanceled\""
        ) emit bt->connectionError(QObject::tr("Pairing rejected"));
}


int main(int argc, char *argv[])
{
    messageHandler = qInstallMessageHandler(handleMessage);

    const QGuiApplication app(argc, argv);
    const QIcon appIcon(":/BTCar/images/favicon.ico");

    app.setOrganizationName("Induwara");
    app.setOrganizationDomain("com.rccsonline.induwara");
    app.setApplicationName("BTCar");
    app.setApplicationVersion("0.0.1");

#ifdef Q_OS_WINDOWS
    app.setWindowIcon(appIcon);
#else
    app.setWindowIcon(appIcon.pixmap(qRound(32 * app.devicePixelRatio())));
#endif

    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();

    for (const QString &locale : uiLanguages) {
        const QString baseName = "BTCar_" + QLocale(locale).name();
        if (translator.load(":/i18n/" + baseName)) {
            app.installTranslator(&translator);
            break;
        }
    }

    QIcon::setThemeSearchPaths({ ":/BTCar/icons" });
    QIcon::setThemeName("BTCar");

    QFontDatabase::addApplicationFont(":/BTCar/fonts/Oswald-Regular.ttf");

    const QUrl url("qrc:/BTCar/qml/Main.qml");
    QQmlApplicationEngine engine;

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app, [url](const QObject *obj, const QUrl &objUrl) {
        if (url == objUrl) {
            if (obj != nullptr) bt = obj->findChild<Bluetooth*>();
            else qApp->exit(-1);
        }
    }, Qt::QueuedConnection);

    qmlRegisterType<Bluetooth>("induwara.BTCar", 1, 0, "Bluetooth");
    qmlRegisterSingletonInstance("induwara.BTCar", 1, 0, "PlatformUtil", new PlatformUtil());

    engine.load(url);

    return app.exec();
}
