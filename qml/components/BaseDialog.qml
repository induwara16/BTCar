import QtQuick
import QtQuick.Controls


Dialog {
    required property string contentText
    property string acceptText
    property string rejectText
    property bool strict: false

    property bool __closed: false

    anchors.centerIn: parent
    modal: true
    margins: 25
    width: appWindow.width * .85
    closePolicy: if (strict) Dialog.NoAutoClose; else Dialog.CloseOnEscape | Dialog.CloseOnPressOutside

    Label {
        anchors.fill: parent
        topPadding: 10
        text: contentText
        wrapMode: Label.WrapAtWordBoundaryOrAnywhere
    }

    footer: DialogButtonBox {
        Button {
            visible: acceptText
            text: acceptText
            DialogButtonBox.buttonRole: Dialog.AcceptRole
        }
        Button {
            visible: rejectText
            text: rejectText
            DialogButtonBox.buttonRole: Dialog.RejectRole
        }
    }

    Component.onCompleted: {
        header.wrapMode = Label.WrapAtWordBoundaryOrAnywhere
        header.elide = Label.ElideNone
        header.font.bold = true
    }

    onClosed: if (!__closed) open()
    onOpened: __closed = false

    onAccepted: if (!strict) closeDialog()
    onRejected: if (!strict) closeDialog()

    function closeDialog() {
        __closed = true
        close()
    }
}
