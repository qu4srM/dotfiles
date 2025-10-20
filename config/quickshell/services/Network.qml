pragma Singleton

import qs.utils

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root 

    property string name 
    property real signal
    property string status

    property real batteryLevel
    property bool isCharging
    property string batteryLevelStr

    function updateName () {
        getName.running = true
    }
    function updateSignal () {
        getSignal.running = true
    }
    function updateStatus () {
        getStatus.running = true
    }
    function updateAll() {
        updateName()
        updateSignal()
        updateStatus()
    }
    Process {
        id: getName
        command: ["bash", "-c", `nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2`]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                root.name = this.text.trim() || "Network"
            }
        }
    }

    Process {
        id: getSignal
        command: ["bash", "-c", `nmcli -t -f ACTIVE,SIGNAL dev wifi | grep '^yes' | cut -d: -f2`]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const levelStr = this.text.trim() || "0"
                root.signal = parseInt(levelStr)
            }
        }
    }
    Process {
        id: getStatus
        command: ["bash", "-c", "nmcli -t -f STATE dev status | head -n 1"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                if (this.text.trim() === "connected") {
                    root.status = "On"
                } else {
                    root.status = "Off"
                }
            }
        }
    }


    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: ()=> { 
            root.updateAll()
        }
    }
}
