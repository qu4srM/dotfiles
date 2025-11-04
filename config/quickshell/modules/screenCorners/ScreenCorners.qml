import qs
import qs.configs 
import qs.widgets

import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland

Scope {
    id: root 
    Variants {
        model: Quickshell.screens
        StyledWindow {
            id: corners
            required property var modelData
            property bool fullscreen
            screen: modelData
            visible: true 
            exclusionMode: ExclusionMode.Ignore
            name: "screenCorners"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            color: "transparent"

            mask: Region {
                x: 0
                y: 0
                width: corners.width
                height: corners.height
                intersection: Intersection.Xor
            }

            anchors {
                top: true 
                left: true 
                right: true 
                bottom: true
            }
            
            Item {
                anchors.fill: parent
                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    blurMax: 15
                    shadowColor: "#eb000000"
                }
                ScreenCorner {
                    color: "black"
                    radius: Appearance.rounding.normal
                }
            }
        }
    }
}