import qs 
import qs.configs
import qs.modules.sidebarright.components
import qs.widgets 
import qs.utils
import qs.services

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import Quickshell.Io
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.UPower

Rectangle {
    id: root
    Layout.fillWidth: parent
    implicitHeight: columnLayout.implicitHeight + 10 + 10
    color: Appearance.colors.colSurfaceContainer
    radius: Appearance.rounding.normal - 2
    
    ColumnLayout {
        id: columnLayout
        anchors.fill: parent
        anchors.margins: Appearance.margins.itemPanelMargin
        spacing: 10
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            QuickMultiButton {
                id: wifi2
                icon: Icons.getNetworkIcon(Network.signal)
                commandToggle: `nmcli radio wifi | grep -q enabled && nmcli radio wifi off || nmcli radio wifi on`
                cmd: "hyprpicker"
                text: Translation.tr(Network.name)
            }
            QuickMultiButton {
                id: bluetooth2
                icon: Icons.getBluetoothIcon(true)
                commandToggle: "whoami"
                cmd: "hyprpicker"
                text: Translation.tr("Bluetooth")
            }
        }
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            QuickButton {
                id: darkmode 
                property string mode: Theme.options.darkmode ? "light" : "dark"
                toggled: Theme.options.darkmode
                icon: "dark_mode"
                text: Translation.tr("Dark mode")
                releaseAction: () => {
                    Wallpapers.updateMaterialColor(mode)
                }
            }
            QuickButton {
                id: dnd
                toggled: !Notifications.silent
                icon: "do_not_disturb_on"
                text: Translation.tr("Do not disturb")
                releaseAction: () => {
                    Notifications.silent = !Notifications.silent;
                }
            }
        }
        RowLayout {
            Layout.fillWidth: true 
            spacing: 10 
            QuickButton {
                activeText: false
                icon: "gamepad"
                text: Translation.tr("Game")
            }
            QuickButton {
                activeText: false
                icon: "night_sight_auto"
                text: Translation.tr("Night")
            }
            QuickButton {
                activeText: false
                toggled: PowerProfiles.profile !== PowerProfile.Balanced
                icon: switch(PowerProfiles.profile) {
                    case PowerProfile.PowerSaver: return "energy_savings_leaf"
                    case PowerProfile.Balanced: return "settings_slow_motion"
                    case PowerProfile.Performance: return "local_fire_department"
                }
                text: switch(PowerProfiles.profile) {
                    case PowerProfile.PowerSaver: return "Power Saver"
                    case PowerProfile.Balanced: return "Balanced"
                    case PowerProfile.Performance: return "Performance"
                }
                releaseAction: () => {
                    if (PowerProfiles.hasPerformanceProfile) {
                        switch(PowerProfiles.profile) {
                            case PowerProfile.PowerSaver: PowerProfiles.profile = PowerProfile.Balanced
                            break;
                            case PowerProfile.Balanced: PowerProfiles.profile = PowerProfile.Performance
                            break;
                            case PowerProfile.Performance: PowerProfiles.profile = PowerProfile.PowerSaver
                            break;
                        }
                    } else {
                        PowerProfiles.profile = PowerProfiles.profile == PowerProfile.Balanced ? PowerProfile.PowerSaver : PowerProfile.Balanced
                    }
                }
            }
            QuickButton {
                activeText: false
                icon: "coffee"
                text: Translation.tr("Keep awake")
            }
        }
    }
}
