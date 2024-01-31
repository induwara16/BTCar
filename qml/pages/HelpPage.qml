import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../components"

Page {
    header: Header {
        rightItem.icon.name: "web"
        rightItem.onClicked: Qt.openUrlExternally("https://btcar.rf.gd")
    }

    title: qsTr("Help")

    List {
        anchors.fill: parent

        model: ListModel {
            ListElement {title: qsTr("Connecting a car/device"); content: qsTr("Your device must support the Serial Port Profile (SPP)."); i: 1}
            ListElement {title: qsTr("Connecting a car/device"); content: qsTr("Turn on Bluetooth (through the system settings or click 'Ok' when BTCar prompts you)."); i: 2}
            ListElement {title: qsTr("Connecting a car/device"); content: qsTr("Click 'Connect' on the home screen."); i: 3}
            ListElement {title: qsTr("Connecting a car/device"); content: qsTr("Make sure the device is turned on, and select it when it appears on the list."); i: 4}
            ListElement {title: qsTr("Connecting a car/device"); content: qsTr("Wait till the connection is obtained."); i: 5}
            ListElement {title: qsTr("Controlling a car"); content: qsTr("Click the respective buttons to send commands to the device over Bluetooth."); i: 1}
            ListElement {title: qsTr("Controlling a car"); content: qsTr("Use the text bar to send custom commands."); i: 2}
            ListElement {title: qsTr("Controlling a car"); content: qsTr("You can customize the commands in Settings."); i: 3}
            ListElement {title: qsTr("Configuring BTCar"); content: qsTr("Open the drawer, and click 'Settings'."); i: 1}
            ListElement {title: qsTr("Configuring BTCar"); content: qsTr("Edit the fields."); i: 2}
        }

        section.property: "title"

        delegate: RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10

            Label {
                Layout.leftMargin: 10
                Layout.topMargin: 5
                Layout.alignment: Qt.AlignTop
                text: i + "."
            }

            Label {
                Layout.fillWidth: true
                wrapMode: Label.WrapAtWordBoundaryOrAnywhere
                text: content
                padding: 5
            }
        }
    }
}
