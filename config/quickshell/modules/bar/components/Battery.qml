import "root:/"
import "root:/modules/common/"
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
    Layout.alignment: Qt.AlignVCenter
    implicitWidth: row.width
    implicitHeight: icon.size

    property bool materialIconFill: true
    property real batteryLevel: 0.0
    
    Row {
        id: row
        anchors.centerIn: parent
        spacing: 6
        Text {
            visible: true
            id: textItem
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            font.family: "Roboto"
            font.pixelSize: 12
            font.weight: Font.Medium
        }
        
        CircularProgress {
            value: root.batteryLevel
            strokeWidth: 2
            StyledMaterialSymbol {
                id: icon
                text: Icons.getBatteryIcon(parseInt(textItem.text))
                size: 10
                color: Appearance.colors.colMSymbol
                fill: root.materialIconFill ? 1 : 0
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
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
                const levelStr = parts[0] || "0"
                const levelInt = parseInt(levelStr)
                root.batteryLevel = levelInt / 100.0
                textItem.text = levelStr
                root.isCharging = parts[1]?.trim() === "1"
            }
        }
    }


    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: multiProcess.running = true
    }
}