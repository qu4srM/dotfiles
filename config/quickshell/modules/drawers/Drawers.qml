import "root:/"
import "root:/modules/common/"
import "root:/modules/sidebar/"
import "root:/modules/bar/components/"
import "root:/modules/bar/popups/"
import "root:/modules/drawers/"
import "root:/modules/dashboard/"
import "root:/widgets/"
import "root:/utils/"

import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

Variants {
    model: Quickshell.screens
    Scope {
        id: scope
        required property ShellScreen modelData
        
        /*Exclusions {
            screen: scope.modelData
            bar: bar
            dock: dock
        }*/
        StyledWindow {
            id: drawers
            screen: scope.modelData
            name: "drawers"
            color: "transparent"
            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }
            margins.top: Appearance.sizes.barHeight
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

            mask: Region {
                x: 0
                y: 0
                width: drawers.width
                height: drawers.height
                intersection: Intersection.Xor
                regions: regions.instances
            }
            Variants {
                id: regions

                model: panels.children

                Region {
                    required property Item modelData

                    x: modelData.x
                    y: modelData.y
                    width: modelData.width
                    height: modelData.height
                    intersection: Intersection.Subtract
                }
            }
            function hide() {
                GlobalStates.dashboardOpen = false
                GlobalStates.wallSelectorOpen = false
            }
            HyprlandFocusGrab {
                active: GlobalStates.dashboardOpen || GlobalStates.wallSelectorOpen
                windows: [drawers]
                onCleared: () => {
                    if (!active) drawers.hide()
                }
            }

            Item {
                anchors.fill: parent
                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: false
                    blurMax: 0
                    shadowColor: "#111111"
                }
                Border {
                    id: border
                    margin: 0
                }
                
                Backgrounds {
                    panels: panels
                }
                
            }
            Interactions {
                id: interactions
                screen: scope.modelData
                Panels {
                    id: panels
                }
            }
            
        }
    }
}

