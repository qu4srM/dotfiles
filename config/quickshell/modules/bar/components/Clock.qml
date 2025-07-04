import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root
    anchors.verticalCenter: parent.verticalCenter
    implicitWidth: textItem.implicitWidth
    implicitHeight: textItem.implicitHeight

    Text {
        id: textItem
        color: "white"
        font.family: "Roboto"
        font.pixelSize: 12
        font.weight: Font.Medium
    }
    Process {
        id: process
        command: ["date", "+%a %b %e %l:%M"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: textItem.text = this.text.trim()
        }
    }
    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: process.running = true
    }
}
