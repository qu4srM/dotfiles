pragma Singleton

import qs.configs
import qs.utils

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root 

    property real batteryLevel
    property bool isCharging
    property string batteryLevelStr

    Process {
        id: getBatteryLevel
        command: ["bash", "-c", "cat /sys/class/power_supply/BAT*/capacity"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const levelStr = this.text.trim() || "0"
                const levelInt = parseInt(levelStr)
                root.batteryLevelStr = levelStr
                root.batteryLevel = levelInt / 100.0
            }
        }
    }

    Process {
        id: getChargingStatus
        command: ["bash", "-c", "cat /sys/class/power_supply/AC*/online"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const pluggedStr = this.text.trim()
                root.isCharging = pluggedStr === "1"
            }
        }
    }


    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: ()=> { 
            getBatteryLevel.running = true
            getChargingStatus.running = true
        }
    }
}
