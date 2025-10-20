import qs 
import qs.configs
import qs.modules.drawers
import qs.widgets 
import qs.utils

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
Scope {
    id: root 
    Variants {
        model: Quickshell.screens
        StyledWindow {
            id: drawers
            required property var modelData
            screen: modelData
            name: "drawers"
            color: "transparent"
            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }
            function topMargin() {
                if (Config.options.bar.floating || GlobalStates.screenLock)
                    return 0;
                if (Config.options.bar.showBackground)
                    return Appearance.sizes.barHeight;
                return 0;
            }

            margins.top: drawers.topMargin()

            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            WlrLayershell.keyboardFocus: (GlobalStates.launcherOpen || GlobalStates.overviewOpen || GlobalStates.wallSelectorOpen)
                ? WlrKeyboardFocus.OnDemand
                : WlrKeyboardFocus.None


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
                GlobalStates.overviewOpen = false
                GlobalStates.wallSelectorOpen = false
                GlobalStates.launcherOpen = false
            }
            HyprlandFocusGrab {
                active: GlobalStates.overviewOpen || GlobalStates.wallSelectorOpen || GlobalStates.launcherOpen
                windows: [drawers]
                onCleared: () => {
                    drawers.hide()
                }
            }
            Item {
                anchors.fill: parent
                
                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    blurMax: 15
                    shadowColor: "#eb000000"
                }
                Border {
                    id: border
                }   
                
                Backgrounds {
                    anchors.topMargin: Config.options.bar.floating ? Appearance.sizes.barHeight + Appearance.margins.panelMargin : 0
                    panels: panels
                }
            }
            Interactions {
                id: interactions
                screen: modelData
                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_Escape) {
                        drawers.hide();
                    }
                }
                Panels {
                    id: panels
                    styledWindow: drawers
                }
            }
        }
    }
}

