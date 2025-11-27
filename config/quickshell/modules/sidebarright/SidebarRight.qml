import qs 
import qs.configs
import qs.modules.sidebarright
import qs.modules.sidebarright.notifications
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
                    color: Config.options.bar.showBackground ? Appearance.colors.colBackground : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                    implicitWidth: sidebarLoader.width 
                    implicitHeight: sidebarLoader.height
                    radius: Appearance.rounding.normal
                    /*
                    StyledRectangularShadow {
                        visible: Config.options.bar.showBackground
                        target: content
                        radius: parent.radius
                    }*/
                    ColumnLayout {
                        id: columnLayout
                        anchors.fill: parent
                        anchors.margins: Appearance.margins.panelMargin
                        spacing: Appearance.margins.panelMargin
                        StatusPanel {}
                        PanelButtons {}
                        Rectangle {
                            color: "transparent"
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            NotificationList {
                                anchors.fill: parent
                            }

                        }
                    }
                
                    
                }
            }

            
        }
    }
}