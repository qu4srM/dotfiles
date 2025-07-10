import "root:/modules/drawers/"
import "root:/modules/bar/"
import "root:/modules/dock/"
import "root:/widgets/"

import QtQuick
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
        
        Exclusions {
            screen: scope.modelData
            bar: bar
            dock: dock
        }
        StyledWindow {
            id: win 
            screen: scope.modelData
            name: "drawers"
            color: "transparent"
            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

            mask: Region {
                x: 0
                y: 0
                width: win.width
                height: win.height
                intersection: Intersection.Xor
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
                    visible: false
                    id: border
                    marginTop: 0
                    colorMain: "#111111"
                    margin: 3
                    radius: 10
                }
                
                Backgrounds {
                    marginBorder: border.margin
                }

            }
            Notch {
                visible: false
                themeColorRect: "#000000"
                themeColorMain: "#000000"
                implicitWidthRect: 200
                implicitHeightRect: 24
                widthRect: 40
                heightRect: 10
                margin: 5
            }
            
        }
    }
}

