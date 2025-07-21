import "root:/"
import "root:/modules/common/"
import "root:/modules/bar/components/"
import "root:/modules/drawers/"
import "root:/modules/sidebar/"
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
            id: hack
            required property ShellScreen screen

            visible: GlobalStates.hackOpen
            screen: screen
            name: "hack"
            color: "transparent"
            exclusiveZone: 0
            anchors {
                top: true
            }
            
            function hide() {
                GlobalStates.hackOpen = false
            }
            //implicitWidth: Appearance.sizes.notchHackWidth
            //implicitHeight: Appearance.sizes.notchHackHeight
            implicitWidth: GlobalStates.hackOpen ? Appearance.sizes.notchHackWidth : Appearance.sizes.notchWidth
            implicitHeight: GlobalStates.hackOpen ? Appearance.sizes.notchHackHeight + 10 : 0
            property string pathIcons: "root:/assets/icons/"
            property string pathScripts: "~/.config/quickshell/scripts/"

            HyprlandFocusGrab {
                id: grab
                windows: [ hack ]
                active: GlobalStates.hackOpen
                onCleared: () => {
                    if (!active) hack.hide()
                }
            }

            Loader {
                id: sidebarLoader
                active: GlobalStates.hackOpen
                anchors.fill: parent
                anchors.topMargin: Appearance.margins.panelMargin
                focus: GlobalStates.hackOpen
                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_Escape) {
                        hack.hide();
                    }
                }
                sourceComponent: Rectangle {
                    color: "transparent" 
                    anchors.fill: parent
                    radius: Appearance.rounding.normal
                    ColumnLayout {
                        anchors.fill: parent 
                        spacing: 0
                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 10
                            StyledText {
                                text: "My IP host: "
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            ActionButton {
                                colBackground: "transparent"
                                colBackgroundHover: Appearance.colors.colprimary_hover
                                buttonText: "Volume"
                                implicitHeight: parent.height 
                                releaseAction: () => {
                                    GlobalStates.onScreenVolumeOpen = true
                                }
                            }

                            StyledText {
                                text: "Target: "
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            ActionButton {
                                colBackground: "transparent"
                                colBackgroundHover: Appearance.colors.colprimary_hover
                                buttonText: "Hola"
                                implicitHeight: parent.height 
                                releaseAction: () => {
                                    GlobalStates.onScreenVolumeOpen = true
                                }
                            }
                        }
                        StyledText {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "modifica el archivo ~/Machines/target para cambiar la ip objetivo"
                        }
                    }
                }
            }          
        }
    }
}