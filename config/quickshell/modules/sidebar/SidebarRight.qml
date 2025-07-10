import "root:/"
import "root:/modules/common/"
import "root:/modules/bar/components/"
import "root:/modules/drawers/"
import "root:/widgets/"
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
            id: sidebar
            required property ShellScreen screen

            visible: GlobalStates.sidebarRightOpen
            screen: screen
            name: "sidebarRight"
            color: "transparent"
            exclusiveZone: 0
            anchors {
                top: true
                bottom: true
                right: true
            }
            
            function hide() {
                GlobalStates.sidebarRightOpen = false
            }
            implicitWidth: Appearance.sizes.sidebarWidth
            property string pathIcons: "root:/assets/icons/"
            property string colorMain: "transparent"
            property string pathScripts: "~/.config/quickshell/scripts/"

            HyprlandFocusGrab {
                id: grab
                windows: [ sidebar ]
                active: GlobalStates.sidebarRightOpen
                onCleared: () => {
                    if (!active) sidebar.hide()
                }
            }

            Loader {
                id: sidebarLoader
                active: GlobalStates.sidebarRightOpen
                anchors.fill: parent
                anchors.topMargin: 14
                anchors.bottomMargin: 14
                anchors.rightMargin: 14
                focus: GlobalStates.sidebarRightOpen
                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_Escape) {
                        sidebar.hide();
                    }
                }
                sourceComponent: Rectangle {  
                    implicitWidth: 200
                    radius: 10


                    Text {
                        text: sidebar.sidebarWidth
                    }
                }
            }

            
        }
    }
}