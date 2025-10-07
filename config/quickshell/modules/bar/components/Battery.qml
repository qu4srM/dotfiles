import qs 
import qs.configs
import qs.modules.bar.components
import qs.services
import qs.widgets 
import qs.utils

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland

Item {
    id: root 
    Layout.alignment: Qt.AlignVCenter
    implicitWidth: icon.active ? 60 : 50
    implicitHeight: parent.height

    property bool materialIconFill: true
    property real batteryLevel: 0.0
    property bool isCharging
    Behavior on width {
        NumberAnimation { duration: 300; }
    }
    Rectangle {
        id: background
        anchors.fill: parent
        color: Appearance.colors.colsecondary
        radius: 9999
    }
    Rectangle {
        id: fillBar
        anchors.verticalCenter: parent.verticalCenter
        width: Math.floor(root.batteryLevel * parent.width)
        height: parent.height - 2
        color: root.batteryLevel > 0.2 ? Appearance.colors.colprimarytext : "red"
        topLeftRadius: Appearance.rounding.full
        bottomLeftRadius: Appearance.rounding.full
        topRightRadius: Math.max(0, Math.min(1, (root.batteryLevel - 0.88) / (0.99 - 0.88))) * Math.min(fillBar.height / 2, fillBar.width / 2)
        bottomRightRadius: Math.max(0, Math.min(1, (root.batteryLevel - 0.88) / (0.99 - 0.88))) * Math.min(fillBar.height / 2, fillBar.width / 2)

        Behavior on width {
            NumberAnimation { duration: 300; }
        }
        Behavior on topRightRadius {
            NumberAnimation { duration: 300; }
        }
        Behavior on bottomRightRadius {
            NumberAnimation { duration: 300; }
        }

    }

    RowLayout {
        anchors.centerIn: parent
        spacing: icon.active ? -root.implicitWidth / 8 + 1 : -12
        Loader {
            id: icon
            active: root.isCharging || root.batteryLevel <= 0.2
            sourceComponent: StyledMaterialSymbol {
                text: root.isCharging ? "bolt" : "exclamation"
                size: 14
                color: Appearance.colors.colBackground
                fill: root.materialIconFill ? 1 : 0
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        StyledText {
            id: textItem
            font.weight: Font.Bold
            color: Appearance.colors.colBackground
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