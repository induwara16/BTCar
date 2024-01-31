#include "bluetooth.h"

#ifdef Q_OS_ANDROID
using namespace QtAndroidPrivate;
#endif


void Bluetooth::componentComplete()
{
#ifdef Q_OS_ANDROID
    QBluetoothPermission btPerms;
    btPerms.setCommunicationModes(QBluetoothPermission::CommunicationMode::Access);

    switch (qApp->checkPermission(btPerms)) {
    case Qt::PermissionStatus::Denied:
        return emit permissionsDenied();
    case Qt::PermissionStatus::Undetermined:
        return qApp->requestPermission(btPerms, [=](){
            componentComplete();
        });
    case Qt::PermissionStatus::Granted:
        emit permissionsGranted();
    }
#endif

    localDevice = new QBluetoothLocalDevice(this);
    discoveryAgent = new QBluetoothDeviceDiscoveryAgent(this);
    socket = new QBluetoothSocket(QBluetoothServiceInfo::Protocol::RfcommProtocol, this);

    if (!localDevice->isValid()) emit adapterInvalid();
    else if (localDevice->hostMode() == QBluetoothLocalDevice::HostMode::HostPoweredOff) emit adapterStateChanged(false);

    connect(localDevice, &QBluetoothLocalDevice::errorOccurred, this, [=](QBluetoothLocalDevice::Error error) {
        emit connectionError(tr("Could not pair device"));
    });

    connect(localDevice, &QBluetoothLocalDevice::hostModeStateChanged, this, [=](const QBluetoothLocalDevice::HostMode hostMode) {
        emit adapterStateChanged(hostMode != QBluetoothLocalDevice::HostMode::HostPoweredOff);
    });

    connect(discoveryAgent, &QBluetoothDeviceDiscoveryAgent::finished, this, &Bluetooth::discoveryFinished);

    connect(discoveryAgent, &QBluetoothDeviceDiscoveryAgent::deviceDiscovered, this, [=](const QBluetoothDeviceInfo info){
        QString iconName;

        switch (info.majorDeviceClass()) {
        case QBluetoothDeviceInfo::MajorDeviceClass::PhoneDevice:
            iconName = "cellphone";
            break;
        case QBluetoothDeviceInfo::MajorDeviceClass::ComputerDevice:
            iconName = "monitor";
            break;
        case QBluetoothDeviceInfo::MajorDeviceClass::ToyDevice:
            iconName = "robot";
            break;
        case QBluetoothDeviceInfo::MajorDeviceClass::NetworkDevice:
            iconName = "web";
            break;
        default:
            iconName = "devices";
        }

        QVariantMap device;
        device["name"] = info.name();
        device["address"] = info.address().toString();
        device["iconName"] = iconName;

        emit deviceDiscovered(device);
    });

    connect(discoveryAgent, &QBluetoothDeviceDiscoveryAgent::errorOccurred, this, [=] {
        emit discoveryError(discoveryAgent->errorString());
    });

    connect(socket, &QBluetoothSocket::connected, this, &Bluetooth::connected);
    connect(socket, &QBluetoothSocket::disconnected, this, &Bluetooth::disconnected);

    connect(socket, &QBluetoothSocket::errorOccurred, this, [=] {
        emit connectionError(socket->errorString());
    });

    connect(socket, &QBluetoothSocket::readyRead, this, [=] {
#ifdef LINUX
        QByteArray line = socket->readLine().trimmed();  // NOTE canReadLine() is false on Linux

        if (line == lastMsg) lastMsg = "";
        else emit recieved(QString::fromUtf8(line.constData(), line.length()));
#endif
        while (socket->canReadLine()) {
            QByteArray line = socket->readLine().trimmed();
            emit recieved(QString::fromUtf8(line.constData(), line.length()));
        }
    });
}


void Bluetooth::powerOn()
{
    if (localDevice->hostMode() != QBluetoothLocalDevice::HostPoweredOff)
        return emit adapterStateChanged(true);

#ifdef LINUX
    QProcess rfkill(this);
    rfkill.start("rfkill", {"unblock", "bluetooth"});
    rfkill.waitForFinished();
#endif

    localDevice->powerOn();
}


void Bluetooth::requestPermissions()
{
#ifdef Q_OS_ANDROID
    const QJniObject action = QJniObject::fromString("android.settings.APPLICATION_DETAILS_SETTINGS");
    const QJniObject uriString = QJniObject::fromString("package:com.rccsonline.induwara.BTCar");

    const QJniObject uri = QJniObject::callStaticObjectMethod("android/net/Uri", "parse", "(Ljava/lang/String;)Landroid/net/Uri;", uriString.object());
    const QJniObject intent("android/content/Intent", "(Ljava/lang/String;Landroid/net/Uri;)V", action.object(), uri.object());

    startActivity(intent, 0, [=](int, int, const QJniObject){
        componentComplete();
    });
#endif
}


void Bluetooth::startDiscovery()
{
    discoveryAgent->start(QBluetoothDeviceDiscoveryAgent::DiscoveryMethod::ClassicMethod);
}


void Bluetooth::stopDiscovery()
{
    discoveryAgent->stop();
}


void Bluetooth::connectToDevice(const QString address)
{
    QBluetoothAddress addr(address);

    if (localDevice->pairingStatus(addr) == QBluetoothLocalDevice::Unpaired) {
        localDevice->requestPairing(addr, QBluetoothLocalDevice::Paired);
        connect(localDevice, &QBluetoothLocalDevice::pairingFinished, this, [=](){
            QTimer::singleShot(0, this, [=]() {
                connectToDevice(address);
            });
        });
        return;
    }

    socket->connectToService(addr, QBluetoothUuid::ServiceClassUuid::SerialPort);
}


void Bluetooth::disconnectFromDevice()
{
    socket->close();
}

void Bluetooth::send(const QString data)
{
    if (data.isEmpty()) return;

#ifdef LINUX
    if (!lastMsg.isEmpty())
        return QTimer::singleShot(200, this, [=]() {
            send(data);
        });

    lastMsg = data; // NOTE readLine returns write data on Linux
#endif

    socket->write(data.toUtf8() + '\n');
    emit written(data);
}
