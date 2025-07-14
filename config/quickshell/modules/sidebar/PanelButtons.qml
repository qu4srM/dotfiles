import "root:/utils/"
import "root:/widgets/"
import "root:/modules/sidebar/components/"

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
    height: 200

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
            colorMain: "#111111"
            colorHover: "transparent"
            rounding: 10
            text: "Network"
            colorToggle: "#1689be"
        }
        QuickMultiButton {
            id: bluetooth
            icon: Icons.getBluetoothIcon(true)
            commandToggle: "whoami"
            cmd: "hyprpicker"
            colorMain: "#111111"
            colorHover: "transparent"
            rounding: 10
            text: "Bluetooth"
            colorToggle: "#1689be"
        }
        QuickButton {
            id: darkmode 
            icon: Icons.getBluetoothIcon(true)
            colorMain: "#111111"
            text: "Dark Mode"
            rounding: 10
        }
        QuickButton {
            id: dnd
            icon: Icons.getBluetoothIcon(true)
            colorMain: "#111111"
            text: "Do not disturb"
            rounding: 10
        }
        QuickButton {
            id: airplane
            icon: Icons.getBluetoothIcon(true)
            colorMain: "#111111"
            text: "Airplane Mode"
            rounding: 10
        }
    }
}
