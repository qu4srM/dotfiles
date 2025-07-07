pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

Singleton  {
    id: root


    property var iconMap: ({}) 

    readonly property var customOverrides: ({
        "zen": "zen-browser",
        "vscode": "vscode",
        "code-oss": "vscode",
        "spotify": "spotify",
        "anki": "anki",
        "com.obsproject.studio": "obs",
        "net.lutris.lutris": "lutris",
        "org.octave.octave": "octave",
        "org.qbittorrent.qbittorrent": "qbittorrent",
        "burp-startburp": "burpsuite",
        "org.pulseaudio.pavucontrol": "pavucontrol",
        "blueman-manager": "blueman",
        "systemsettings": "settings",
        "help": "help",
    })
    Process {
        id: fetchIcons
        command: [
            "bash", "-c",
            `
            grep -h '^Icon=' /usr/share/applications/*.desktop ~/.local/share/applications/*.desktop 2>/dev/null |
            cut -d= -f2 |
            tr '[:upper:]' '[:lower:]' |
            sort -u |
            paste -sd '|'
            `
        ]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                const rawIcons = this.text.trim().split("|")
                let map = {}
                for (let i = 0; i < rawIcons.length; ++i) {
                    const name = rawIcons[i].trim().toLowerCase()
                    if (name.length > 0) {
                        map[name] = name
                    }
                }
                iconMap = map
            }
        }
    }
    Component.onCompleted: fetchIcons.running = true

    function getIcon(appClass) {
        const key = appClass?.toLowerCase?.() ?? ""
        return customOverrides[key] || iconMap[key] || "missing-symbolic"
    }



    function getBatteryIcon(level: int, isCharging: bool): string {
        if (isCharging) {
            if (level >= 80)
                return "battery-full-charging-symbolic.svg";
            if (level >= 60)
                return "battery-good-charging-symbolic.svg";
            if (level >= 40)
                return "battery-medium-charging-symbolic.svg";
            if (level >= 20)
                return "battery-low-charging-symbolic.svg";
            return "battery-empty-charging-symbolic.svg";
        } else {
            if (level >= 80)
                return "battery-full-symbolic.svg";
            if (level >= 60)
                return "battery-good-symbolic.svg";
            if (level >= 40)
                return "battery-medium-symbolic.svg";
            if (level >= 20)
                return "battery-low-symbolic.svg";
            return "battery-empty-symbolic.svg";
        }
    }

    function getNetworkIcon(strength: int): string {
        if (strength >= 80)
            return "network-wireless-signal-excellent";
        if (strength >= 60)
            return "network-wireless-signal-good";
        if (strength >= 40)
            return "network-wireless-signal-ok";
        if (strength >= 20)
            return "network-wireless-signal-weak";
        return "network-wireless-signal-none";
    }

    function getBluetoothIcon(connected: bool): string {
        return connected ? "bluetooth-active-symbolic" : "bluetooth-disabled-symbolic";
    }
}
