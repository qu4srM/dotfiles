import qs 
import qs.modules.sidebarright.components
import qs.widgets 
import qs.utils

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
    width: parent.width
    height: 180

    GridLayout {
        id: grid
        columns: 2
        rowSpacing: 6
        columnSpacing: 6
        anchors.fill: parent
        anchors.margins: 10

        QuickMultiButton {
            id: wifi
            icon: Icons.getNetworkIcon(50)
            commandToggle: "whoami"
            cmd: "hyprpicker"
            text: Translation.tr("Network")
        }
        QuickMultiButton {
            id: bluetooth
            icon: Icons.getBluetoothIcon(true)
            commandToggle: "whoami"
            cmd: "hyprpicker"
            text: Translation.tr("Bluetooth")
        }
        QuickButton {
            id: darkmode 
            icon: "dark_mode"
            text: Translation.tr("Dark mode")
        }
        QuickButton {
            id: dnd
            icon: "do_not_disturb_on"
            text: Translation.tr("Do not disturb")
        }
        QuickButton {
            id: airplane
            icon: "gamepad"
            text: Translation.tr("Game mode")
        }
        QuickButton {
            id: nightLight
            icon: "night_sight_auto"
            text: Translation.tr("Night Light")
        }
    }
}
