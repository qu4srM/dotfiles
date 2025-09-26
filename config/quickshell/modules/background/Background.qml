import qs 
import qs.configs
import qs.widgets 
import qs.utils
import qs.services


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
            id: background
            required property var modelData
            screen: modelData
            name: "background"
            WlrLayershell.layer: WlrLayer.Bottom //GlobalStates.screenLocked ? WlrLayer.Top : WlrLayer.Bottom
            color: "transparent"
            //exclusiveZone: 0
            exclusionMode: ExclusionMode.Ignore
            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }
            property string pathIcons: "root:/assets/icons/"
            property string pathScripts: "~/.config/quickshell/scripts/"

            Wallpaper {
                window: background
                wallpaperPath: Wallpapers.actualCurrent
            }
            Item {
                id: weather
                anchors.top: parent.top 
                anchors.right: parent.right 
                anchors.topMargin: 80
                anchors.rightMargin: 50
                implicitWidth: shape.implicitWidth
                implicitHeight: shape.implicitHeight
                Rectangle {
                    id: shape
                    color: Appearance.colors.colPrimary
                    rotation: -45
                    implicitWidth: 120
                    implicitHeight: shape.implicitWidth - 30
                    radius: Appearance.rounding.full
                }
                StyledText { 
                    anchors.right: parent.right 
                    anchors.rightMargin: 15
                    text: Weather.temperature
                    color: Appearance.colors.colOnPrimary
                    font.pixelSize: 40
                }
                IconImage {
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    anchors.bottom: parent.bottom
                    implicitSize: 50
                    source: Quickshell.iconPath(Icons.getWeatherIcon(Weather.condition))
                }
            }
            Item {
                id: clock 
                anchors.top: parent.top 
                anchors.topMargin: 100
                anchors.horizontalCenter: parent.horizontalCenter 
                implicitWidth: 100
                implicitHeight: 50 
                RowLayout {
                    spacing: 0
                    StyledText {
                        text: "10"
                        font.pixelSize: 40
                    }
                    StyledText {
                        text: ":"
                        font.pixelSize: 40
                    }
                    StyledText {
                        text: "10"
                        font.pixelSize: 40
                    }
                }
            }

            
        }
    }
}