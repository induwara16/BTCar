import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import induwara.BTCar

import "../components"


Page {
    header: Header {
        rightItem.icon.name: "bluetooth-connect"
        rightItem.onClicked: stackView.push(devicesPage)
    }

    title: qsTr("BTCar")

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 35

        spacing: 40

        Image {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            Layout.fillHeight: true

            source: "../../images/logo.svg"
            mipmap: true
            fillMode: Image.PreserveAspectFit
        }

        Label {
            id: label
            Layout.fillWidth: true

            text: qsTr("BTCar is developed by Induwara Jayaweera.<br><br>Built using <a href=\"https://qt.io\">Qt</a>.")

            font.pixelSize: appWindow.font.pixelSize * 1.4
            font.family: "Oswald"

            horizontalAlignment: Label.AlignHCenter
            wrapMode: Label.WrapAtWordBoundaryOrAnywhere
            onLinkActivated: (link) => !isDesktop || Qt.openUrlExternally(link)

            MouseArea {
                anchors.fill: parent
                enabled: isDesktop
                cursorShape: if (label.hoveredLink) Qt.PointingHandCursor
                onClicked: if (label.hoveredLink) Qt.openUrlExternally(label.hoveredLink)
            }
        }

        Button {
            Layout.alignment: Qt.AlignHCenter

            icon.name: "bluetooth-connect"
            text: qsTr("Connect")
            padding: 15

            onClicked: header.rightItem.clicked()
        }
    }

    Drawer {
        id: navigationDrawer

        width: appWindow.width >= 400 ? 400 : 320
        height: appWindow.height

        dragMargin: isDesktop ? 15:30
        interactive: stackView.currentItem.title === "BTCar"

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Image {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.bottomMargin: 15
                fillMode: Image.PreserveAspectCrop
                mipmap: true
                source: "../../images/drawer.svg"
            }

            Repeater {
                model: [qsTr("Home"), qsTr("Settings"), qsTr("Help")]

                delegate: ItemDelegate {
                    property string iconName: modelData.toLowerCase()

                    text: modelData
                    icon.name: iconName
                    padding: 15

                    onClicked: {
                        navigationDrawer.close()
                        if (iconName == "settings") stackView.push(settingsPage)
                        else if (iconName == "help") stackView.push(helpPage)
                    }

                    Layout.fillWidth: true
                }
            }

            Label {
                text: qsTr("Installed version: %1<br/>Qt version: %2").arg(Application.version).arg(PlatformUtil.qtVersion)
                verticalAlignment: Qt.AlignBottom
                horizontalAlignment: Qt.AlignHCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                color: secondaryTextColor
                lineHeight: 1.15
                font.pixelSize: 13

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 25
            }
        }
    }
}
