import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../components"


Page {
    id: dp
    title: qsTr("Select a Device")

    header: Header {
        showBusy: true
        rightItem.enabled: !showBusy
        rightItem.onClicked: dp.state = "discovering"
    }

    StackView.onActivated: dp.state = "discovering"
    StackView.onDeactivated: dp.state = "discoveryFinished"

    ListModel {
        id: devicesModel
    }

    ColumnLayout {
        anchors.fill: parent

        List {
            model: devicesModel
            rightMargin: 0
            leftMargin: 0

            delegate: ItemDelegate {
                anchors.right: parent.right
                anchors.left: parent.left

                verticalPadding: 15
                horizontalPadding: 20

                onClicked: stackView.push(controlPage, { name, address })

                contentItem: RowLayout {
                    IconLabel {
                        icon.name: iconName
                        icon.color: Universal.foreground
                        icon.height: 28
                        rightPadding: 10
                    }

                    Column {
                        Layout.fillWidth: true

                        Label {
                            text: name
                            bottomPadding: 5
                        }

                        Label {
                            text: address
                            color: secondaryTextColor
                            font.pixelSize: 12
                        }
                    }

                    IconLabel {
                        icon.name: "chevron-right"
                        icon.color: Universal.foreground
                        icon.height: 24
                    }
                }
            }
        }

        Label {
            Layout.fillHeight: true
            Layout.fillWidth: true

            text: qsTr("No Devices Found")
            color: secondaryTextColor
            visible: devicesModel.count === 0

            wrapMode: Label.WrapAtWordBoundaryOrAnywhere
            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter

            font.pixelSize: 30
        }

        Label {
            Layout.fillWidth: true
            Layout.margins: 15

            text: qsTr("Make sure your device has a Serial Port Profile")
            color: secondaryTextColor

            wrapMode: Label.WrapAtWordBoundaryOrAnywhere
            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter

            font.pixelSize: 13
        }
    }

    Connections {
        target: bluetooth

        function onDeviceDiscovered(device) {
            for (let i=0; i < devicesModel.count; i++)
                if (devicesModel.get(i).address === device.address)
                    return devicesModel.set(i, device)

            devicesModel.append(device)
        }

        function onDiscoveryFinished() {
            dp.state = "discoveryFinished"
        }
    }

    states: [
        State {
            name: "discovering"

            PropertyChanges {
                target: header

                showBusy: true
                rightItem.icon.name: ""
            }

            StateChangeScript {
                script: {
                    devicesModel.clear()
                    bluetooth.startDiscovery()
                }
            }
        },
        State {
            name: "discoveryFinished"

            PropertyChanges {
                target: header

                showBusy: false
                rightItem.icon.name: "refresh"
            }

            StateChangeScript {
                script: toast.show(qsTr("Device discovery finished"))
            }
        }
    ]
}
