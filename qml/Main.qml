import QtCore
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Universal

import induwara.BTCar

import "components"
import "pages"

ApplicationWindow {
    id: appWindow

    Universal.theme: Universal.System

    readonly property bool isDesktop: ["windows", "linux"].indexOf(Qt.platform.os) !== -1
    readonly property string secondaryTextColor: Universal.theme === Universal.Dark ? "#8F8F8F":"#525252"

    width: 640
    height: 560
    visible: true
    title: isDesktop ? `BTCar (${Application.version})` : "BTCar"

    Component {
        id: homePage
        HomePage {}
    }

    Component {
        id: settingsPage
        SettingsPage {}
    }

    Component {
        id: helpPage
        HelpPage {}
    }

    Component {
        id: devicesPage
        DevicesPage {}
    }

    Component {
        id: controlPage
        ControlPage {}
    }

    Component {
        id: scrollIndicator
        ScrollIndicator {}
    }

    Bluetooth {
        id: bluetooth
    }

    Settings {
        id: settings

        Component.onCompleted: {
            settings.setValue("hornOn", settings.value("hornOn", "H1"))
            settings.setValue("hornOff", settings.value("hornOff", "H0"))

            settings.setValue("lightsOn", settings.value("lightsOn", "L1"))
            settings.setValue("lightsOff", settings.value("lightsOff", "L0"))

            settings.setValue("forward", settings.value("forward", "F"))
            settings.setValue("backward", settings.value("backward", "B"))
            settings.setValue("forwardRight", settings.value("forwardRight", "FR"))
            settings.setValue("forwardLeft", settings.value("forwardLeft", "FL"))
            settings.setValue("backwardRight", settings.value("backwardRight", "BR"))
            settings.setValue("backwardLeft", settings.value("backwardLeft", "BL"))
            settings.setValue("stop", settings.value("stop", "S"))
        }
    }

    BaseDialog {
        title: qsTr("OS Not Supported")
        visible: ["linux", "windows", "android"].indexOf(Qt.platform.os) === -1
        contentText: qsTr("BTCar does not work in your operating system.<br><br>Press 'Ok' to quit.")
        strict: true
        acceptText: qsTr("Ok")
        onAccepted: Qt.exit(-1)
    }

    BaseDialog {
        id: btAdapterInvalidDialog
        title: qsTr("Bluetooth Not Supported")
        contentText: qsTr("Bluetooth is not supported on this device. BTCar needs Bluetooth in order to work.<br><br>Press 'Ok' to quit.")
        strict: true
        acceptText: qsTr("Ok")
        onAccepted: Qt.exit(-1)

        Connections {
            target: bluetooth

            function onAdapterInvalid() {
                btAdapterInvalidDialog.open()
            }
        }
    }

    BaseDialog {
        id: turnOnBtDialog
        title: qsTr("Turn On Bluetooth")
        contentText: qsTr("BTCar needs Bluetooth turned on to work.<br><br>Press 'Ok' to power on Bluetooth.<br>Press 'Quit' to quit.")
        strict: true
        acceptText: qsTr("Ok")
        rejectText: qsTr("Quit")
        onAccepted: bluetooth.powerOn()
        onRejected: Qt.exit(-1)

        Connections {
            target: bluetooth

            function onAdapterStateChanged(powered) {
                if (powered) turnOnBtDialog.closeDialog()
                else turnOnBtDialog.open()
            }
        }
    }

    BaseDialog {
        id: permissionDeniedDialog

        title: qsTr("Permission Denied")
        contentText: qsTr("BTCar needs Bluetooth permissions in order to work, but they were not granted. <br><br>Press 'Ok' to allow permissions.<br>Press 'Quit' to quit.")

        strict: true
        acceptText: qsTr("Ok")
        rejectText: qsTr("Quit")
        onRejected: Qt.exit(-1)
        onAccepted: {
            bluetooth.requestPermissions()
            stackView.pop(null)
        }

        Connections {
            target: bluetooth

            function onPermissionsDenied() {
                permissionDeniedDialog.open()
            }

            function onPermissionsGranted() {
                permissionDeniedDialog.closeDialog()
            }
        }
    }

    BaseDialog {
        id: btErrorDialog

        property string errorMessage
        property bool discovery

        title: discovery ? qsTr("Device Scan Error") : qsTr("Device Connection Error")
        contentText: (
                discovery ?
                qsTr("An error occured while discovering devices:") :
                qsTr("An error occured while establishing a connection with the device:")
            ) + `<br><pre>${errorMessage}</pre>`

        acceptText: qsTr("Copy to clipboard")
        rejectText: qsTr("Close")
        onRejected: stackView.pop(stackView.get(discovery ? 0 : 1))
        onAccepted: {
            PlatformUtil.copyToClipboard(`BTCar ${discovery ? "discovery" : "connection"} error: ${errorMessage}`)
            toast.show(qsTr("Copied to clipboard"))
            rejected()
        }

        Connections {
            target: bluetooth

            function onConnectionError(message) {
                btErrorDialog.discovery = false
                btErrorDialog.errorMessage = message
                btErrorDialog.open()
            }

            function onDiscoveryError(message) {
                btErrorDialog.discovery = true
                btErrorDialog.errorMessage = message
                btErrorDialog.open()
            }
        }
    }

    ToolTip {
        id: toast

        timeout: 2000
        rightMargin: appWindow.width / (appWindow.width < 340 ? 5 : 4)
        leftMargin: rightMargin

        closePolicy: Popup.NoAutoClose
        y: appWindow.height - height - 40

        enter: Transition {
            NumberAnimation {
                property: "opacity"
                from: 0
                to: 0.9
            }
        }

        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 0.9
                to: 0
            }
        }

        contentItem: Label {
            topPadding: 5
            bottomPadding: 5
            rightPadding: 8
            leftPadding: 8

            color: Universal.background
            horizontalAlignment: Label.AlignHCenter
            wrapMode: Label.WrapAtWordBoundaryOrAnywhere
        }

        background: Rectangle {
            radius: 20
            color: Universal.foreground
        }

        MouseArea {
            anchors.fill: parent
            onClicked: toast.hide()
        }

        function show(str) {
            if (!isDesktop)
                PlatformUtil.toast(str)
            else  {
                contentItem.text = str
                open()
            }
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: homePage
        focus: true

        Keys.onBackPressed:
            if (currentItem.title === "BTCar") Qt.exit(0)
            else stackView.pop()
    }
}
