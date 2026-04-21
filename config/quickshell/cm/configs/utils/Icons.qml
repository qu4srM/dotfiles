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



    function getBatteryIcon(level: int): string {
        if (level >= 90)
            return "battery_android_full";
        if (level >= 80)
            return "battery_android_6";
        if (level >= 70)
            return "battery_android_5";
        if (level >= 60)
            return "battery_android_4";
        if (level >= 50)
            return "battery_android_3";
        if (level >= 40)
            return "battery_android_2";
        if (level >= 30)
            return "battery_android_1";
        if (level >= 20)
            return "battery_android_0";
        return "battery_android_alert";
    }

    function getNetworkIcon(strength: int): string {
        if (strength >= 80)
            return "android_wifi_4_bar";
        if (strength >= 50)
            return "wifi";
        if (strength >= 25)
            return "wifi_2_bar";
        if (strength >= 0)
            return "wifi_1_bar";
        return "android_wifi_3_bar_off";
    }

    function getBluetoothIcon(connected: bool): string {
        return connected ? "bluetooth" : "bluetooth_disabled";
    }

    function getWeatherIcon(cond) {
        cond = cond.toLowerCase();
        if (cond.indexOf("sunny") !== -1) return "weather-clear";
        if (cond.indexOf("clear") !== -1) return "weather-clear-night";
        if (cond.indexOf("partly cloudy") !== -1) return "weather-few-clouds";
        if (cond.indexOf("cloud") !== -1) return "weather-clouds";
        if (cond.indexOf("rain") !== -1) return "weather-showers";
        if (cond.indexOf("storm") !== -1) return "weather-storm";
        if (cond.indexOf("snow") !== -1) return "weather-snow";
        if (cond.indexOf("fog") !== -1) return "weather-fog";
        return "weather-severe-alert"; // fallback
    }

}
