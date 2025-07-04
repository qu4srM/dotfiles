import "root:/widgets/"
import "root:/utils/"
import "root:/services/"
import "root:/modules/bar/components/"

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland

Item {
    id: root
    anchors.verticalCenter: parent.verticalCenter
    implicitWidth: textItem.implicitWidth + 30
    implicitHeight: textItem.implicitHeight
    property bool isCharging: false
    
    RowLayout {
        anchors.centerIn: parent
        spacing: 0
        Text {
            id: textItem
            color: "white"
            font.family: "Roboto"
            font.pixelSize: 12
            font.weight: Font.Medium
        }
        StyledIcon {
            iconSystem: Icons.getBatteryIcon(parseInt(textItem.text), isCharging)
            size: 14
        }
    }
    Process {
        id: multiProcess
        command: ["bash", "-c",
            "charge=$(cat /sys/class/power_supply/BAT*/capacity); " +
            "plugged=$(cat /sys/class/power_supply/AC*/online); " +
            "echo \"$charge|$plugged\""
        ]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const parts = this.text.trim().split("|")
                textItem.text = parts[0] || ""
                isCharging = parts[1]?.trim() === "1"
            }
        }
    }


    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: multiProcess.running = true
    }
}