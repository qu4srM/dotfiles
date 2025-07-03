import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root
    implicitWidth: textItem.implicitWidth
    implicitHeight: textItem.implicitHeight

    Text {
        id: textItem
        anchors.centerIn: parent
        color: "white"
        font.family: "Roboto"
        font.pixelSize: 12
        font.weight: Font.Medium

        Process {
            command: ["date", "+%a %b %e %l:%M"]
            running: true

            stdout: StdioCollector {
                onStreamFinished: textItem.text = this.text.trim()
            }
        }
    }
}
