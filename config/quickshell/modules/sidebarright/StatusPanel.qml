import qs 
import qs.configs
import qs.modules.sidebarright.components
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

Rectangle {
    id: root
    property string settingsQmlPath: Quickshell.shellPath("settings.qml")
    Layout.fillWidth: true
    implicitHeight: 60
    color: Appearance.colors.colSurfaceContainer
    radius: Appearance.rounding.normal - 2

    RowLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: Appearance.margins.itemPanelMargin
        spacing: Appearance.margins.panelMargin
        Row {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 6
            
            ClippingRectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: height
                height: parent.height
                color: "transparent"
                radius: Appearance.rounding.full 
                border.width: 2
                border.color: Appearance.colors.colPrimary
                Image {
                    source: Config.options.user.avatar
                    width: parent.width
                    height: width
                    fillMode: Image.PreserveAspectCrop
                }

            }
            Column {
                anchors.verticalCenter: parent.verticalCenter
                StyledText {
                    text: SystemInfo.username
                    color: Appearance.colors.colPrimary
                }
                StyledText {
                    text: Translation.tr("Uptime: ") + SystemInfo.uptime
                    font.pixelSize: 14
                }

            }
        }

        Row {
            spacing: 6
            Layout.alignment: Qt.AlignRight 
            Layout.fillWidth: false
            Layout.fillHeight: true
            ActionButtonIcon {
                anchors.verticalCenter: parent.verticalCenter
                colBackground: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainerHigh : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colPrimary : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                iconMaterial: "restart_alt"
                iconSize: 20
                implicitWidth: implicitHeight
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
                colBackground: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainerHigh : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colPrimary : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                iconMaterial: "settings"
                iconSize: 16
                implicitWidth: implicitHeight
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
                colBackground: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainerHigh : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colPrimary : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                iconMaterial: "power_settings_new"
                iconSize: 16
                implicitWidth: implicitHeight
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
