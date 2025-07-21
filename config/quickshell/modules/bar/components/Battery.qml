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
    implicitWidth: icon.size + textItem.implicitWidth + Appearance.margins.itemBarMargin
    implicitHeight: parent.height

    property bool materialIconFill: true
    property real batteryLevel: 0.0
    Row {
        anchors.fill: parent
        spacing: 4
        StyledText {
            id: textItem
            font.pixelSize: 10
            font.weight: Font.Bold
            color: "white"
            anchors.verticalCenter: parent.verticalCenter
        }
        StyledMaterialSymbol {
            id: icon
            text: Icons.getBatteryIcon(parseInt(textItem.text))
            size: 16
            color: Appearance.colors.colMSymbol
            fill: root.materialIconFill ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
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