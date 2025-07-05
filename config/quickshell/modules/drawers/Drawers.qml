import "root:/modules/drawers/"
import "root:/modules/bar/"
import "root:/modules/dock/"
import "root:/widgets/"

import QtQuick
import QtQuick.Layouts
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
                y: bar.implicitHeight
                width: win.width
                height: win.height
                intersection: Intersection.Xor

                Region {
                    x: 0
                    y: dock.implicitHeight
                    width: win.width
                    height: win.height
                intersection: Intersection.Xor
                }
                Region {
                    x: 0
                    y: bar.implicitHeight
                    width: win.width
                    height: win.height - bar.implicitHeight - dock.implicitHeight
                    intersection: Intersection.Xor
                }
            }

            


            
            Item {
                anchors.fill: parent
                layer.enabled: true
                Border {
                    marginTop: 0
                    colorMain: "#111111"
                    margin: 2
                    radius: 10
                }
            }
            
            Notch {
                themeColorRect: "#000000"
                themeColorMain: "#000000"
                implicitWidthRect: 200
                implicitHeightRect: 24
                widthRect: 40
                heightRect: 10
                margin: 5
            }
            
            Bar {
                id: bar
                screen: scope.modelData
                barHeight: 24
                colorMain: "transparent"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
            }
            Dock {
                id: dock
                screen: scope.modelData
                h: 35
                colorDock: "#b6111111"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
            }
        }
    }
}

