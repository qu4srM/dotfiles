import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

QtObject {
    id: root

    property string currentAppClass: "desktop"

    Process {
        id: getAppClassProcess
        command: [
            "bash", "-c",
            "ws_id=$(hyprctl monitors -j | jq -r '.[0].activeWorkspace.id'); " +
            "hyprctl clients -j | jq -r --argjson ws \"$ws_id\" '.[] | select(.workspace.id == $ws) | .class' | head -n1"
        ]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                currentAppClass.text = this.text.trim()
            }
        }
    }
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: getAppClassProcess.running = true
    }
}
