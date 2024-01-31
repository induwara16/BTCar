#include "platformutil.h"


PlatformUtil::PlatformUtil(QObject *parent) : QObject{parent}
{
    clipboard = QGuiApplication::clipboard();
}

void PlatformUtil::copyToClipboard(QString text)
{
    clipboard->setText(text);
}

void PlatformUtil::toast(QString text)
{
#ifdef Q_OS_ANDROID
    QAndroidApplication::runOnAndroidMainThread([text] {
        QJniObject::callStaticObjectMethod(
            "android/widget/Toast", "makeText", "(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;",
            QAndroidApplication::context(), QJniObject::fromString(text).object(), 0
        ).callMethod<void>("show");
    }).waitForFinished();

#else
    Q_UNUSED(text)
#endif
}
