import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../components"


Page {
    required property string name
    required property string address

    title: qsTr("Control %1").arg(name)

    header: Header {
        rightItem.icon.name: "bluetooth-off"
        rightItem.onClicked: stackView.pop(stackView.get(1))
    }

    StackView.onActivated: bluetooth.connectToDevice(address)
    StackView.onDeactivated: bluetooth.disconnectFromDevice()

    ColumnLayout {
        id: connecting

        anchors.fill: parent
        spacing: 25

        Item {
            Layout.fillHeight: true
        }

        Label {
            Layout.fillWidth: true

            horizontalAlignment: Label.AlignHCenter
            color: secondaryTextColor
            text: qsTr("Connecting")

            font.pixelSize: 30
        }

        BusyIndicator {
            Layout.alignment: Qt.AlignHCenter
            Universal.accent: secondaryTextColor
        }

        Item {
            Layout.fillHeight: true
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        visible: !connecting.visible

        GridLayout {
            Layout.preferredWidth: height
            Layout.fillHeight: true
            columns: 3
            rows: 3
            columnSpacing: 5
            rowSpacing: 5

            Repeater {
                model: [
                    {press: "forwardLeft", rel: "stop", iconName: "arrow-top-left"},
                    {press: "forward", rel: "stop", iconName: "arrow-up"},
                    {press: "forwardRight", rel: "stop", iconName: "arrow-top-right"},
                    {press: "backwardLeft", rel: "stop", iconName: "arrow-bottom-left"},
                    {press: "backward", rel: "stop", iconName: "arrow-down"},
                    {press: "backwardRight", rel: "stop", iconName: "arrow-bottom-right"},
                    {press: "lightsOn", rel: "lightsOff", iconName: "car-light-high"},
                    {press: "disconnect", rel: "", iconName: "bluetooth-off"},
                    {press: "hornOn", rel: "hornOff", iconName: "bullhorn-outline"},
                ]
                delegate: Button {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    icon.name: modelData.iconName
                    icon.height: height - 20
                    icon.width: height - 20

                    onPressed: if (modelData.press !== "disconnect") bluetooth.send(settings.value(modelData.press))
                    onReleased: if (modelData.press !== "disconnect") bluetooth.send(settings.value(modelData.rel))
                    onClicked: if (modelData.press === "disconnect") header.rightItem.clicked()
                }
            }
        }

        List {
            Layout.preferredHeight: 125
            Layout.fillHeight: false

            model: log
            snapMode: ListView.SnapToItem
            verticalLayoutDirection: ListView.BottomToTop
            topMargin: 0
            bottomMargin: 0
            leftMargin: 0
            rightMargin: 0

            delegate: ItemDelegate {
                anchors.left: parent.left
                anchors.right: parent.right

                horizontalPadding: 5

                contentItem: RowLayout {
                    Label {
                        font.pixelSize: 11
                        rightPadding: -3
                        color: secondaryTextColor
                        text: Qt.formatTime(new Date(), "hh:mm:ss")
                        bottomPadding: -5
                        topPadding: -5
                    }

                    IconLabel {
                        icon.color: com.color
                        icon.name: type === "RX" ? "download" : "upload"
                        icon.height: 16
                        rightPadding: -5
                        bottomPadding: -5
                        topPadding: -5
                    }

                    Label {
                        id: com
                        color: type === "RX" ? Universal.color(Universal.Emerald) : Universal.color(Universal.Cyan)
                        text: type.toUpperCase()
                        rightPadding: 10
                        font.pixelSize: 13
                        bottomPadding: -5
                        topPadding: -5
                    }

                    Label {
                        Layout.fillWidth: true
                        text: content
                        elide: Label.ElideRight
                        bottomPadding: -5
                        topPadding: -5
                    }
                }

                onClicked: {
                    sendField.text = content
                    send.focus = true
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 5

            TextField {
                id: sendField

                Layout.fillWidth: true
                Layout.fillHeight: true

                placeholderText: qsTr("Send to %1").arg(name)
                onAccepted: send.clicked()
            }

            Button {
                id: send
                Layout.fillHeight: true
                icon.name: "send"

                onClicked: {
                    bluetooth.send(sendField.text)
                    sendField.clear()
                }
            }
        }
    }

    ListModel {
        id: log
    }

    Connections {
        target: bluetooth

        function onConnected() {
            connecting.visible = false
            toast.show(qsTr("Connected to \"%1\"").arg(name))
        }

        function onDisconnected() {
            toast.show(qsTr("Disconnected from \"%1\"").arg(name))
            header.rightItem.clicked()
        }

        function onRecieved(data) {
            log.insert(0, {content: data, type: "TX"})
        }

        function onWritten(data) {
            log.insert(0, {content: data, type: "TX"})
        }
    }
}
