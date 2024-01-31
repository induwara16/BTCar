import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ToolBar {
    property alias rightItem: actionButton
    property bool showBusy: false

    RowLayout {
        anchors.fill: parent

        ToolButton {
            icon.name: if (title === "BTCar") "hamburger-menu"; else "arrow-back"
            icon.height: 28
            icon.width: 28
            Layout.alignment: Qt.AlignLeft

            onClicked: if (title === "BTCar") navigationDrawer.open(); else stackView.pop()
        }

        Label {
            text: title
            font.bold: true
            font.pixelSize: 18
            elide: Label.ElideRight
            horizontalAlignment: Qt.AlignHCenter
            Layout.fillWidth: true
        }

        ToolButton {
            id: actionButton
            enabled: icon.name
            Layout.alignment: Qt.AlignRight

            BusyIndicator {
                anchors.fill: parent
                anchors.margins: 12
                running: showBusy
                Universal.accent: Universal.foreground
            }
        }
    }
}
