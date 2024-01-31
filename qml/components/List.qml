import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ListView {
    Layout.fillWidth: true
    Layout.fillHeight: true

    Keys.onUpPressed: scrollBar.decrease()
    Keys.onDownPressed: scrollBar.increase()

    ScrollBar.vertical: ScrollBar {
        id: scrollBar
        interactive: isDesktop
        onPressedChanged: if (pressed) parent.focus = true
    }

    clip: true
    topMargin: 10
    bottomMargin: 20
    leftMargin: 10
    rightMargin: 10

    section.delegate: Label {
        required property string section

        text: section
        font.bold: true
        padding: 10
        topPadding: 20
        Universal.foreground: Universal.accent
    }
}
