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

Item {
    id: root
    Layout.fillWidth: parent
    implicitHeight: columnLayout.implicitHeight
    ColumnLayout {
        id: columnLayout
        anchors.fill: parent
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
                toggled: Notifications.silent
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
                icon: "gamepad"
                text: Translation.tr("Game")
            }
            QuickButton {
                activeText: false
                icon: "night_sight_auto"
                text: Translation.tr("Night")
            }
        }
    }
}
