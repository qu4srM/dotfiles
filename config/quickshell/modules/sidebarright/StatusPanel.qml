import qs 
import qs.configs
import qs.modules.sidebarright.components
import qs.widgets 
import qs.utils

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
    property string settingsQmlPath: Quickshell.shellPath("settings.qml")
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
                colBackground: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colPrimary : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
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
                StyledToolTip {
                    content: Translation.tr("Reboot") + " Hyprland"
                }
            }
            ActionButtonIcon {
                anchors.verticalCenter: parent.verticalCenter
                colBackground: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colPrimary : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                iconMaterial: "settings"
                iconSize: 16
                implicitWidth: 40
                implicitHeight: parent.height - 2
                buttonRadiusTopLeft: 30
                buttonRadiusTopRight: 30
                buttonRadiusBottomLeft: 30
                buttonRadiusBottomRight: 30
                onPressed: {
                    GlobalStates.sidebarRightOpen = false
                    Quickshell.execDetached(["qs", "-p", root.settingsQmlPath])
                }
                StyledToolTip {
                    content: Translation.tr("Settings")
                }
            }
            ActionButtonIcon {
                anchors.verticalCenter: parent.verticalCenter
                colBackground: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colPrimary : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                iconMaterial: "power_settings_new"
                iconSize: 16
                implicitWidth: 40
                implicitHeight: parent.height - 2
                buttonRadiusTopLeft: 30
                buttonRadiusTopRight: 30
                buttonRadiusBottomLeft: 30
                buttonRadiusBottomRight: 30
                onPressed: {
                    GlobalStates.sessionOpen = true
                }
                StyledToolTip {
                    content: Translation.tr("Power Menu")
                }
            }

        }     
    } 
}
