import qs 
import qs.modules.background
import qs.configs
import qs.widgets 
import qs.services

import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland

Scope {
    id: root
    Variants {
        model: Quickshell.screens
        StyledWindow {
            id: background
            required property var modelData
            screen: modelData
            name: "background"
            WlrLayershell.layer: WlrLayer.Bottom
            color: "transparent"
            //exclusiveZone: 0
            exclusionMode: ExclusionMode.Ignore
            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            Wallpaper {
                window: background
            }
            Item {
                id: weather
                anchors.bottom: clock.top 
                anchors.right: clock.right 
                anchors.bottomMargin: -30
                anchors.rightMargin: 70
                implicitWidth: shape.implicitWidth
                implicitHeight: shape.implicitHeight
                z: 10
                ShapesIcons {
                    id: shape
                    implicitWidth: 120
                    implicitHeight: shape.implicitWidth - 30
                    enable: true
                    useSystemShape: false 
                    shape: "oval"
                    color: Appearance.colors.colPrimary
                }
                StyledText { 
                    anchors.right: parent.right 
                    anchors.rightMargin: 15
                    text: Weather.temperature
                    color: Appearance.colors.colOnPrimary
                    font.family: Appearance.font.family.background
                    font.pixelSize: 40
                }
                /*
                IconImage {
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    anchors.bottom: parent.bottom
                    implicitSize: 50
                    source: Quickshell.iconPath(Icons.getWeatherIcon(Weather.condition))
                }*/
            }
            DesktopClock {
                id: clock
            }


            /*WallpaperOverlay {
                window: background
            }*/
            
        }
    }
}