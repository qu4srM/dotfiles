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
            text: "Network"
        }
        QuickMultiButton {
            id: bluetooth
            icon: Icons.getBluetoothIcon(true)
            commandToggle: "whoami"
            cmd: "hyprpicker"
            text: "Bluetooth"
        }
        QuickButton {
            id: darkmode 
            icon: Icons.getBluetoothIcon(true)
            text: "Dark Mode"
        }
        QuickButton {
            id: dnd
            icon: Icons.getBluetoothIcon(true)
            text: "Do not disturb"
        }
        QuickButton {
            id: airplane
            icon: Icons.getBluetoothIcon(true)
            text: "Airplane Mode"
        }
        QuickButton {
            id: lightNight
            icon: Icons.getBluetoothIcon(true)
            text: "Dark Mode"
        }
    }
}
