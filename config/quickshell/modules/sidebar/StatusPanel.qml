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
    height: 60

    GridLayout {
        id: grid
        columns: 5
        rowSpacing: 6
        columnSpacing: 6
        anchors.fill: parent
        anchors.margins: 10
        StyledIcon {
            iconSystem: "redhat"
            size: 20
        }
        Text {
            text: "Uptime: 27 min"
            font.pixelSize: 12
        }
        /*
        StyledButtonIcon {
            iconSystem: "reload"
            background: "white"
            hoverColor: "#1689be"
            size: 20
            rounding: 20
        }
        StyledButtonIcon {
            iconSystem: "settings"
            background: "white"
            hoverColor: "#1689be"
            size: 20
            rounding: 20
        }
        StyledButtonIcon {
            iconSystem: "xfce4-power-manager-settings"
            background: "white"
            hoverColor: "#1689be"
            size: 20
            rounding: 20
        }
        */
    }


   
}
