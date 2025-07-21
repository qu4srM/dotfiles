import "root:/utils/"
import "root:/widgets/"
import "root:/modules/common/"
import "root:/modules/sidebar/components/"

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

Item {
    id: root
    width: parent.width
    height: 60

    RowLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        Row {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 6
            StyledIcon {
                anchors.verticalCenter: parent.verticalCenter
                iconSystem: "redhat"
                size: 20
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "Uptime: 27 min"
                color: "white"
                font.pixelSize: 12
            }
        }
        Row {
            spacing: 6
            Layout.alignment: Qt.AlignRight 
            Layout.fillWidth: false
            Layout.fillHeight: true
            ActionButtonIcon {
                anchors.verticalCenter: parent.verticalCenter
                colBackground: Appearance.colors.colsecondary
                colBackgroundHover: Appearance.colors.colsecondary_hover
                iconMaterial: "restart_alt"
                iconSize: 20
                implicitWidth: 40
                implicitHeight: parent.height - 2
                buttonRadiusTopLeft: 30
                buttonRadiusTopRight: 30
                buttonRadiusBottomLeft: 30
                buttonRadiusBottomRight: 30
                onPressed: {
                    Quickshell.execDetached(["bash", "-c", "~/.config/quickshell/scripts/screenshot.sh"])
                }
            }
            ActionButtonIcon {
                anchors.verticalCenter: parent.verticalCenter
                colBackground: Appearance.colors.colsecondary
                colBackgroundHover: Appearance.colors.colsecondary_hover
                iconMaterial: "settings"
                iconSize: 16
                implicitWidth: 40
                implicitHeight: parent.height - 2
                buttonRadiusTopLeft: 30
                buttonRadiusTopRight: 30
                buttonRadiusBottomLeft: 30
                buttonRadiusBottomRight: 30
                onPressed: {
                    Quickshell.execDetached(["bash", "-c", "~/.config/quickshell/scripts/screenshot.sh"])
                }
            }
            ActionButtonIcon {
                anchors.verticalCenter: parent.verticalCenter
                colBackground: Appearance.colors.colsecondary
                colBackgroundHover: Appearance.colors.colsecondary_hover
                iconMaterial: "power_settings_new"
                iconSize: 16
                implicitWidth: 40
                implicitHeight: parent.height - 2
                buttonRadiusTopLeft: 30
                buttonRadiusTopRight: 30
                buttonRadiusBottomLeft: 30
                buttonRadiusBottomRight: 30
                onPressed: {
                    Quickshell.execDetached(["bash", "-c", "~/.config/quickshell/scripts/screenshot.sh"])
                }
            }

        }     
    } 
}
