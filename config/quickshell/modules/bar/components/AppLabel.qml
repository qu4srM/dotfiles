import QtQuick
import Quickshell
import Quickshell.Io

Text {
    id: root
    anchors.centerIn: parent
    color: "white"
    font.family: "Roboto"
    font.pixelSize: 12
    font.weight: Font.Medium

    Process {
        command: ["date", "+%a %b %e %l:%M"]

        running: true

        stdout: StdioCollector {
            onStreamFinished: root.text = this.text.trim()
        }
    }
}
