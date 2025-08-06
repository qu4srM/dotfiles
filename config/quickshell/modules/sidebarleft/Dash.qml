import "root:/"
import "root:/modules/common/"
import "root:/modules/sidebar/"
import "root:/modules/bar/components/"
import "root:/modules/bar/popups/"
import "root:/modules/drawers/"
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

Item {
    id: root
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight
    Row {
        id: row
        spacing: 8
        ColumnLayout {
            spacing: 8
            
            Row {
                spacing: 8
                Rect {
                    width: 200
                    height: 80
                    color: Appearance.colors.colsecondary
                    radius: Appearance.rounding.small

                    StyledText {
                        anchors.centerIn: parent
                        text: "10°"
                        font.pixelSize: 40
                    }
                }
                Rect {
                    width: 160
                    height: 80
                    color: Appearance.colors.colsecondary
                    radius: Appearance.rounding.small

                    Row {
                        id: system
                        anchors.centerIn: parent
                        spacing: 8

                        StyledMaterialSymbol {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "settings"
                            size: 30
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 2
                            StyledText { text: "OS: Arch Linux"; font.pixelSize: 12 }
                            StyledText { text: "Terminal: Kitty"; font.pixelSize: 12 }
                            StyledText { text: "Uptime: 120 min"; font.pixelSize: 12 }
                        }
                    }
                }
            }

            Rect {
                width: 360 + 8
                height: phrase.implicitHeight + 16
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
        }
        Rect {
            width: 100
            height: 80 + phrase.implicitHeight + 16 + 8
            color: Appearance.colors.colsecondary
            radius: Appearance.rounding.small

            Row {
                id: sounds
                anchors.centerIn: parent
                spacing: 10

                ProgressBarV { implicitHeight: 50 }
                ProgressBarV { implicitHeight: 50 }
                ProgressBarV { implicitHeight: 50 }
            }
        }
    }
    component Rect: Rectangle {
        radius: Appearance.rounding.small
    }
}
