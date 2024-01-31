#ifndef BLUETOOTH_H
#define BLUETOOTH_H

#include <QBluetoothDeviceDiscoveryAgent>
#include <QBluetoothLocalDevice>
#include <QBluetoothSocket>
#include <QObject>
#include <QPermissions>
#include <QTimer>
#include <QVariantMap>
#include <QQmlParserStatus>

#if defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID)
#define LINUX
#include <QProcess>
#elif defined(Q_OS_ANDROID)
#include <QtCore/private/qandroidextras_p.h>
#include <QJniObject>
#endif


class Bluetooth : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)

public:
    void classBegin() override {};
    void componentComplete() override;

public slots:
    void powerOn();
    void requestPermissions();
    void startDiscovery();
    void stopDiscovery();
    void connectToDevice(const QString address);
    void disconnectFromDevice();
    void send(const QString data);

private:
    QBluetoothLocalDevice *localDevice;
    QBluetoothDeviceDiscoveryAgent *discoveryAgent;
    QBluetoothSocket *socket;

#ifdef LINUX
    QString lastMsg = "";
#endif

signals:
    void adapterInvalid();
    void adapterStateChanged(const bool powered);
    void permissionsDenied();
    void permissionsGranted();
    void deviceDiscovered(const QVariantMap device);
    void discoveryFinished();
    void discoveryError(const QString message);
    void connectionError(const QString message);
    void connected();
    void disconnected();
    void recieved(const QString data);
    void written(const QString written);
};

#endif // BLUETOOTH_H
