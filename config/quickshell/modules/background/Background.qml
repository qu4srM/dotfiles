import "root:/"
import "root:/modules/common/"
import "root:/modules/bar/components/"
import "root:/modules/drawers/"
import "root:/modules/sidebar/"
import "root:/widgets/"
import "root:/services/"
import "root:/utils/"

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
            required property ShellScreen screen
            visible: true
            screen: screen
            name: "background"
            WlrLayershell.layer: WlrLayer.Bottom //GlobalStates.screenLocked ? WlrLayer.Top : WlrLayer.Bottom
            color: "transparent"
            exclusiveZone: 0
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