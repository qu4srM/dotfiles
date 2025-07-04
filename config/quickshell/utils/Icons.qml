pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

Singleton  {
    id: root
    readonly property var iconMap: ({
        "zen": "zen-browser-symbolic.svg",
        "vscode": "vscode-symbolic.svg",
        "code-oss": "vscode-symbolic.svg",
        "kitty": "kitty-symbolic.svg",
        "org.kde.dolphin": "org.kde.dolphin-symbolic.svg",
        "spotify": "spotify-symbolic.svg",
        "vlc": "vlc-symbolic.svg",
        "lutris": "lutris-symbolic.svg",
        "systemsettings": "settings-symbolic.svg",
        "help": "help-symbolic.svg",
        "desktop": "desktop-symbolic.svg"
    })

    function getIcon(appClass) {
        const key = appClass?.toLowerCase() ?? ""
        return iconMap[key] || "missing-symbolic.svg"
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
}
