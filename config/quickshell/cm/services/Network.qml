pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    /* ---------------------------
       STATE
    --------------------------- */

    property bool wifiEnabled: false
    property bool ethernetConnected: false
    property bool vpnActive: false

    property string networkName: ""
    property string networkType: "none"   // wifi | ethernet | vpn | none

    property int signalStrength: 0
    property string security: ""

    property real downloadSpeed: 0
    property real uploadSpeed: 0

    property bool wifiScanning: false

    property var wifiNetworks: []

    property int prevRx: 0
    property int prevTx: 0

    /* ---------------------------
       WIFI CONTROL
    --------------------------- */

    function enableWifi(enabled = true) {
        wifiToggle.exec(["nmcli","radio","wifi", enabled ? "on" : "off"])
    }

    function toggleWifi() {
        enableWifi(!wifiEnabled)
    }

    function rescanWifi() {
        wifiScanning = true
        scanProc.exec(["nmcli","device","wifi","list","--rescan","yes"])
    }

    function connect(ssid,password="") {

        if(password === "") {
            connectProc.exec([
                "nmcli","dev","wifi","connect",ssid
            ])
        } else {
            connectProc.exec([
                "nmcli","dev","wifi","connect",ssid,
                "password",password
            ])
        }
    }

    function disconnect() {
        disconnectProc.exec([
            "nmcli","networking","off"
        ])
    }

    /* ---------------------------
       UPDATE
    --------------------------- */

    function updateAll() {
        wifiStateProc.running = true
        activeNetProc.running = true
        signalProc.running = true
        ethernetProc.running = true
        vpnProc.running = true
        networksProc.running = true
    }

    /* ---------------------------
       WIFI ENABLED
    --------------------------- */

    Process {
        id: wifiStateProc
        command: ["nmcli","radio","wifi"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.wifiEnabled = text.trim() === "enabled"
            }
        }
    }

    /* ---------------------------
       ACTIVE NETWORK
    --------------------------- */

    Process {
        id: activeNetProc

        command:[
            "bash","-c",
            "nmcli -t -f ACTIVE,SSID,SIGNAL dev wifi | grep '^yes'"
        ]

        stdout: StdioCollector {
            onStreamFinished: {

                let line = text.trim()

                if(line === "") {
                    root.networkName = ""
                    root.signalStrength = 0
                    return
                }

                let parts = line.split(":")

                root.networkName = parts[1]
                root.signalStrength = parseInt(parts[2])
            }
        }
    }

    /* ---------------------------
       SIGNAL
    --------------------------- */

    Process {
        id: signalProc

        command:[
            "bash","-c",
            "nmcli -t -f TYPE device status | head -n 1"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                root.networkType = text.trim()
            }
        }
    }

    /* ---------------------------
       ETHERNET
    --------------------------- */

    Process {
        id: ethernetProc

        command:[
            "bash","-c",
            "nmcli -t -f TYPE,STATE dev status | grep ethernet"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                root.ethernetConnected = text.includes("connected")
            }
        }
    }

    /* ---------------------------
       VPN
    --------------------------- */

    Process {
        id: vpnProc

        command:[
            "bash","-c",
            "nmcli -t -f TYPE,STATE dev status | grep vpn"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                root.vpnActive = text.includes("connected")
            }
        }
    }

    /* ---------------------------
       NETWORK LIST
    --------------------------- */

    Process {
        id: networksProc

        command:[
            "bash","-c",
            "nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY dev wifi"
        ]

        stdout: StdioCollector {
            onStreamFinished: {

                let nets = []

                text.trim().split("\n").forEach(line => {

                    let p = line.split(":")

                    if(p.length < 4)
                        return

                    let isActive = p[0] === "*"
                    let ssid = p[1]

                    if(ssid === "" || isActive)
                        return

                    nets.push({
                        active: false,
                        ssid: ssid,
                        signal: parseInt(p[2]),
                        security: p[3]
                    })
                })

                nets.sort((a,b) => b.signal - a.signal)

                root.wifiNetworks = nets
            }
        }
    }

    /* ---------------------------
       NETWORK SPEED
    --------------------------- */

    Process {
        id: speedProc

        command:[
            "bash","-c",
            "cat /sys/class/net/*/statistics/rx_bytes"
        ]

        stdout: StdioCollector {
            onStreamFinished: {

                let rx = text.trim()
                    .split("\n")
                    .reduce((a,b)=>a+parseInt(b),0)

                if(root.prevRx !== 0) {
                    root.downloadSpeed =
                        (rx - root.prevRx) / 1024
                }

                root.prevRx = rx
            }
        }
    }

    Process {
        id: speedTxProc

        command:[
            "bash","-c",
            "cat /sys/class/net/*/statistics/tx_bytes"
        ]

        stdout: StdioCollector {
            onStreamFinished: {

                let tx = text.trim()
                    .split("\n")
                    .reduce((a,b)=>a+parseInt(b),0)

                if(root.prevTx !== 0) {
                    root.uploadSpeed =
                        (tx - root.prevTx) / 1024
                }

                root.prevTx = tx
            }
        }
    }

    /* ---------------------------
       WIFI COMMANDS
    --------------------------- */

    Process { id: wifiToggle }
    Process { id: connectProc }
    Process { id: disconnectProc }

    Process {
        id: scanProc
        onExited:{
            wifiScanning = false
            networksProc.running = true
        }
    }

    /* ---------------------------
       TIMERS
    --------------------------- */

    Timer {
        interval: 10000
        running: true
        repeat: true

        onTriggered:{
            root.updateAll()
        }
    }

    Timer {
        interval: 10000
        running: true
        repeat: true

        onTriggered:{
            speedProc.running = true
            speedTxProc.running = true
        }
    }

    Component.onCompleted:{
        root.updateAll()
    }
}