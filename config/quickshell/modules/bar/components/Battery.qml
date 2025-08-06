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
    implicitWidth: icon.active ? 30 : 25
    implicitHeight: parent.height - 8

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
        width: Math.floor(root.batteryLevel * parent.width)
        height: parent.height
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
        spacing: 0
        Loader {
            id: icon
            active: root.isCharging || root.batteryLevel <= 0.2
            sourceComponent: StyledMaterialSymbol {
                text: root.isCharging ? "bolt" : "exclamation"
                size: 14
                color: Appearance.colors.colbackground
                fill: root.materialIconFill ? 1 : 0
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        StyledText {
            id: textItem
            font.weight: Font.Bold
            color: Appearance.colors.colbackground 
            anchors.left: icon.right
            anchors.leftMargin: icon.active ? -root.implicitWidth / 6 + 1 : -6
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