import qs
import qs.configs
import qs.modules.sidebarleft 
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
                    if (!active) sidebarleft.hide()
                }
            }

            Loader {
                id: sidebarLoader
                active: GlobalStates.sidebarLeftOpen
                anchors.fill: parent
                anchors.topMargin: Appearance.margins.panelMargin
                anchors.bottomMargin: Appearance.margins.panelMargin
                anchors.leftMargin: Appearance.margins.panelMargin
                focus: GlobalStates.sidebarLeftOpen
                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_Escape) {
                        sidebarleft.hide();
                    }
                }
                sourceComponent: Rectangle {
                    color: Appearance?.colors.colbackground ?? "transparent" 
                    implicitWidth: 200
                    implicitHeight: 100
                    radius: Appearance.rounding.normal
                    Content {}
                }
            }

            
        }
    }
}