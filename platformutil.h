#ifndef PLATFORMUTIL_H
#define PLATFORMUTIL_H

#include <QClipboard>
#include <QGuiApplication>
#include <QObject>
#include <QSettings>

#ifdef Q_OS_ANDROID
#include <QJniObject>

using namespace QNativeInterface;
#else
#endif


class PlatformUtil : public QObject
{
    Q_OBJECT
    Q_PROPERTY(const QString qtVersion MEMBER qtVersion CONSTANT)

public:
    explicit PlatformUtil(QObject *parent = nullptr);

public slots:
    void copyToClipboard(QString text);
    void toast(QString text);

private:
    QClipboard *clipboard;
    const QString qtVersion = qVersion();
};

#endif // PLATFORMUTIL_H
