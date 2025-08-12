import qs 
import qs.configs
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


Scope {
    id: root
    Variants {
        model: Quickshell.screens
        StyledWindow {
            id: background
            required property var modelData
            screen: modelData
            name: "background"
            WlrLayershell.layer: WlrLayer.Bottom //GlobalStates.screenLocked ? WlrLayer.Top : WlrLayer.Bottom
            color: "transparent"
            //exclusiveZone: 0
            exclusionMode: ExclusionMode.Ignore
            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }
            property string pathIcons: "root:/assets/icons/"
            property string pathScripts: "~/.config/quickshell/scripts/"

            Wallpaper {
                window: background
                wallpaperPath: Wallpapers.actualCurrent
            }

            
        }
    }
}