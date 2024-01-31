import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../components"


Page {
    header: Header {}
    title: qsTr("Settings")

    List {
        anchors.fill: parent

        model: ListModel {
            ListElement {type: qsTr("Appearance"); name: qsTr("Theme"); key: "theme"}
            ListElement {type: qsTr("Lights"); name: qsTr("Lights On"); key: "lightsOn"}
            ListElement {type: qsTr("Lights"); name: qsTr("Lights Off"); key: "lightsOff"}
            ListElement {type: qsTr("Horn"); name: qsTr("Horn On"); key: "hornOn"}
            ListElement {type: qsTr("Horn"); name: qsTr("Horn Off"); key: "hornOff"}
            ListElement {type: qsTr("Movement"); name: qsTr("Forward"); key: "forward"}
            ListElement {type: qsTr("Movement"); name: qsTr("Stop"); key: "stop"}
            ListElement {type: qsTr("Movement"); name: qsTr("Forward Right"); key: "forwardRight"}
            ListElement {type: qsTr("Movement"); name: qsTr("Forward Left"); key: "forwardLeft"}
            ListElement {type: qsTr("Movement"); name: qsTr("Backward"); key: "backward"}
            ListElement {type: qsTr("Movement"); name: qsTr("Backward Right"); key: "backwardRight"}
            ListElement {type: qsTr("Movement"); name: qsTr("Backward Left"); key: "backwardLeft"}
        }

        delegate: RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            spacing: 20

            Label {
                Layout.fillWidth: true
                text: name
                padding: 10
                leftPadding: 8
            }

            TextField {
                text: settings.value(key)
                onEditingFinished: settings.setValue(key, text)
            }
        }

        section.property: "type"
    }
}
