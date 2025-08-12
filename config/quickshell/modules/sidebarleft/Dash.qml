import qs
import qs.configs
import qs.modules.sidebarleft 
import qs.widgets 


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

Item {
    id: root
    anchors.fill: parent
    Item {
        id: start 
        anchors.top: parent.top
        implicitHeight: 240
        implicitWidth: root.implicitWidth
        
        RowLayout {
            spacing: 10

            Rect {
                width: 3 + columnSliders.implicitWidth * 3
                height: columnSliders.implicitHeight
                color: Appearance.colors.colsecondary
                radius: Appearance.rounding.small

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2
                    StyledText { text: "OS: Arch Linux"; font.pixelSize: 12 }
                    StyledText { text: "Terminal: Kitty"; font.pixelSize: 12 }
                    StyledText { text: "Uptime: 120 min"; font.pixelSize: 12 }
                }
            }
            ColumnLayout {
                id: columnSliders
                spacing: 10
                Rect {
                    width: root.implicitWidth / 4
                    height: 60
                    color: Appearance.colors.colsecondary
                    radius: Appearance.rounding.small

                    StyledText {
                        anchors.centerIn: parent
                        text: "10°"
                        font.pixelSize: 40
                    }
                }
                Rect {
                    width: root.implicitWidth / 4
                    height: 140
                    color: Appearance.colors.colsecondary
                    radius: Appearance.rounding.small

                    Row {
                        anchors.centerIn: parent 
                        spacing: 10 
                        ProgressBarV { implicitHeight: 100 }
                        ProgressBarV { implicitHeight: 100 }
                        ProgressBarV { implicitHeight: 100 }
                    }
                }
            }
            
        }
    }
    Rect {
        id: center
        anchors.top: start.bottom
        implicitHeight: 300
        implicitWidth: root.implicitWidth
        color: "black"
    }

    Rect {
        id: end
        anchors.top: center.bottom
        implicitWidth: root.implicitWidth
        implicitHeight: phrase.implicitHeight + phrase.anchors.margins * 2
        color: Appearance.colors.colsecondary
        radius: Appearance.rounding.small

        StyledText {
            id: phrase
            anchors.fill: parent
            anchors.margins: 8
            wrapMode: Text.Wrap
            text: "No permitas que tus miedos y debilidades te alejen de tus objetivos. Mantén tu corazón ardiendo. Recuerda que el tiempo no espera a nadie, no te hará compañía."
            color: "#ffffff"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
    }
    



    component Rect: Rectangle {
        radius: Appearance.rounding.small
    }
}
