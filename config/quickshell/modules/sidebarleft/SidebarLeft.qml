import qs
import qs.configs
import qs.modules.sidebarleft 
import qs.utils
import qs.widgets 

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
            id: sidebarleft
            required property var modelData
            property bool preventAutoHide: false
            screen: modelData
            visible: GlobalStates.sidebarLeftOpen
            name: "sidebarLeft"
            color: "transparent"
            exclusiveZone: 0
            anchors {
                top: true
                bottom: true
                left: true
            }
            
            function hide() {
                if (!sidebarleft.preventAutoHide)
                    GlobalStates.sidebarLeftOpen = false
            }

            implicitWidth: Appearance.sizes.sidebarLeftWidth
            property string pathIcons: "root:/assets/icons/"
            property string pathScripts: "~/.config/quickshell/scripts/"

            HyprlandFocusGrab {
                id: grab
                windows: [ sidebarleft ]
                active: GlobalStates.sidebarLeftOpen
                onCleared: () => {
                    if (!sidebarleft.preventAutoHide && !active)
                        sidebarleft.hide()
                }
            }

            Loader {
                id: sidebarLoader
                active: GlobalStates.sidebarLeftOpen
                anchors.fill: parent
                anchors.margins: Appearance.margins.panelMargin
                focus: GlobalStates.sidebarLeftOpen
                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_Escape) {
                        sidebarleft.hide();
                    }
                }
                sourceComponent: Rectangle {
                    color: Config.options.bar.showBackground ? Appearance.colors.colSurface : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                    anchors.fill: parent
                    radius: Appearance.rounding.normal
                    Content {}
                }
            }

            Component.onCompleted: {
                GlobalStates.sidebarLeftRef = sidebarleft
            }
            Component.onDestruction: {
                if (GlobalStates.sidebarLeftRef === sidebarleft)
                    GlobalStates.sidebarLeftRef = null
            }
        }
    }
}