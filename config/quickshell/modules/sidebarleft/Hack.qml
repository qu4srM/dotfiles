import "root:/"
import "root:/modules/common/"
import "root:/modules/sidebar/"
import "root:/modules/bar/components/"
import "root:/modules/drawers/"
import "root:/widgets/"
import "root:/utils/"

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

Item {
    id: root
    property var onUnhovered
    implicitWidth: 360
    implicitHeight: 160

    property string pathStatus: "~/Machines/target"

    Process {
        id: multiProcess
        command: ["bash", "-c",
            "getTarget=$(cat ~/Machines/target); " +
            "getIp=$(bash ~/.config/quickshell/scripts/htb-status.sh status); " +
            "echo \"$getTarget|$getIp\""
        ]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const parts = this.text.trim().split("|")
                target.buttonText = parts[0]
                ip.buttonText = parts[1]
            }
        }

    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: multiProcess.running = true
    }

    MouseArea {
        id: popupMouseAreaTop
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true

        Column {
            id: column
            spacing: 4

            StyledText {
                text: "My IP host"
            }

            ActionButton {
                id: ip
                colBackground: "transparent"
                colBackgroundHover: "transparent"
                colText: "#9FEF00"
                Layout.fillWidth: true
                releaseAction: () => Qt.callLater(() => Qt.application.clipboard.setText(buttonText))
                onPressed: {
                    const safeText = buttonText.replace(/"/g, '\\"');
                    Quickshell.execDetached(["bash", "-c", `echo \"${safeText}\" | wl-copy -n`]);
                }
            }

            StyledText {
                text: "Target IP Address: Change in ~/Machines/target"
            }

            ActionButton {
                id: target
                colBackground: "transparent"
                colBackgroundHover: "transparent"
                colText: "#9FEF00"
                Layout.fillWidth: true
                onPressed: {
                    const safeText = buttonText.replace(/"/g, '\\"');
                    Quickshell.execDetached(["bash", "-c", `echo \"${safeText}\" | wl-copy -n`]);
                }
            }
        }

        onExited: {
            if (!popupMouseAreaTop.containsMouse) {
                root.onUnhovered()
            }
        }
    }
}
