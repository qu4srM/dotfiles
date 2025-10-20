pragma Singleton

import qs.configs
import qs.utils

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root 

    property string targetIp: Config.options.hacking.targetIp
    property string folder: Config.options.hacking.folder
    property string hostIp
    property string vpnIp
    property string os 
    property string platform: Config.options.hacking.platform // Types: hackthebox, hacktheboxacademy and tryhackme
    property string vpn: Config.options.hacking.vpn
    

    function getOs () {
        const cmd = `whichSystem.py ${targetIp} | awk -F'→' '{print $3}' | xargs`
        getOs.command = ["bash", "-c", cmd];
        getOs.running = true
    }
    function startVpn() {
        let cmd = null
        if (platform === "hackthebox") {
            cmd = `kitty --class vpn-window --detach bash -c "sudo openvpn ~/Machines/${vpn}.ovpn"` // --hold if want window persistent
        } else if (platform === "hacktheboxacademy") {
            cmd = `kitty --class vpn-window --detach bash -c "sudo openvpn ~/Machines/${vpn}.ovpn"` // --hold if want window persistent
        } else if (platform === "tryhackme") {
            cmd = `kitty --class vpn-window --detach bash -c "sudo openvpn ~/Machines/${vpn}.ovpn"` // --hold if want window persistent
        } else {
            cmd = `echo "Not Found"`
        }
        startVpn.command = ["bash", "-c", cmd];
        startVpn.startDetached();
    }
    function submitUserFlag(flag) {
        const cmd = `echo "${flag}" > ~/Machines/"${folder}"/user.txt`
        submitUserFlag.command = ["bash", "-c", cmd];
        submitUserFlag.startDetached();
    }
    function submitRootFlag(flag) {
        const cmd = `echo "${flag}" > ~/Machines/"${folder}"/root.txt`
        submitRootFlag.command = ["bash", "-c", cmd];
        submitRootFlag.startDetached();
    }
    function createFolders() {
        const cmd = `kitty --detach --hold bash -c 'mkdir -p ~/Machines/"${folder}"/{nmap,content,exploits} && cd ~/Machines/"${folder}" && exec zsh'`
        createFolders.command = ["bash", "-c", cmd];
        createFolders.startDetached();
    }

    function updateVpn() {
        getVpn.running = true 
    }
    function updateHost() {
        getHost.running = true 
    }
    function updateAll() {
        updateVpn();
        updateHost();
    }
    Component.onCompleted: {
        updateAll();
    }
    Process {
        id: getOs
        stdout: StdioCollector {
            onStreamFinished: {
                root.os = this.text.trim() || "Not Found"
            }
        }
    }
    Process {
        id: getVpn
        command: ["bash", "-c", `~/.config/quickshell/scripts/htb_status.sh status`]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                root.vpnIp = this.text.trim() || "Disconected"
            }
        }
    }
    Process {
        id: getHost
        command: ["bash", "-c", "/usr/sbin/ifconfig wlan0 2>/dev/null | awk '/inet /{print $2}' || echo ''"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                root.hostIp = this.text.trim() || "192.168.1.1"
            }
        }
    }
    Process {
        id: startVpn
    }
    Process {
        id: createFolders
    }
    Process {
        id: submitUserFlag 
    }
    Process {
        id: submitRootFlag 
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
