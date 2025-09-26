import qs 
import qs.configs
import qs.modules.sidebarright
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


Scope {
    id: root
    Variants {
        model: Quickshell.screens
        StyledWindow {
            id: sidebar
            required property var modelData

            visible: GlobalStates.sidebarRightOpen
            screen: modelData
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
                anchors.topMargin: Appearance.margins.panelMargin
                anchors.bottomMargin: Appearance.margins.panelMargin
                anchors.rightMargin: Appearance.margins.panelMargin
                anchors.leftMargin: Appearance.margins.panelMargin
                focus: GlobalStates.sidebarRightOpen
                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_Escape) {
                        sidebar.hide();
                    }
                }
                sourceComponent: Rectangle {
                    color: Config.options.bar.showBackground ? Appearance.colors.colSurface : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                    implicitWidth: 200
                    radius: Appearance.rounding.normal
                    StyledRectangularShadow {
                        visible: Config.options.bar.showBackground
                        target: content
                        radius: parent.radius
                    }
                    Rectangle {
                        id: content
                        anchors.fill: parent 
                        color: Config.options.bar.showBackground ? Appearance.colors.colSurface : "transparent"
                        radius: parent.radius
                        border.width: Config.options.bar.showBackground ? 0 : 1
                        border.color: Colors.setTransparency(Appearance.colors.colglassmorphism, 0.7)
                        GridLayout {
                            id: grid
                            anchors.fill: parent
                            columns: 1
                            rowSpacing: 0
                            columnSpacing: 0
                            StatusPanel {}
                            PanelButtons {}
                            Rectangle {
                                color: "transparent"
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                        }
                    }
                    
                }
            }

            
        }
    }
}