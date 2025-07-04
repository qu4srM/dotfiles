import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

Rectangle {
    id: root
    color: mouseArea.containsMouse ? "#000000" : "transparent"
    height: 24
    width: textItem.implicitWidth + 20
    implicitWidth: textItem.implicitWidth
    implicitHeight: textItem.implicitHeight

    // Si estás usando un RowLayout afuera:
    Layout.alignment: Qt.AlignVCenter

    property string text: "Screenshot"
    property string command: "whoami"

    Process {
        id: runCommand
        command: ["bash", "-c", root.command]
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: runCommand.startDetached()
    }

    Text {
        id: textItem
        anchors.centerIn: parent
        text: root.text
        color: "white"
        font.family: "Roboto"
        font.pixelSize: 12
        font.weight: Font.Medium
    }
    Behavior on color {
        ColorAnimation {
            duration: 150
            easing.type: Easing.InOutQuad
        }
    }
}
