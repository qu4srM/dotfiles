import "root:/"
import "root:/modules/common/"
import "root:/modules/sidebar/"
import "root:/modules/bar/components/"
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


Scope {
    id: root
    property string settingsQmlPath: Quickshell.configPath("settings.qml")
    Variants {
        model: Quickshell.screens
        StyledWindow {
            id: bar
            required property ShellScreen screen
            screen: screen
            name: "bar"
            color: Appearance.colors.colbackground
            anchors {
                top: true
                left: true
                right: true
            }
            property string pathIcons: "root:/assets/icons/"
            property string colorMain: "transparent"
            property string pathScripts: "~/.config/quickshell/scripts/"

            implicitHeight: Appearance.sizes.barHeight
            WlrLayershell.layer: WlrLayer.Top


            RowLayout {
                anchors.fill: parent
                spacing: 0

                // Zona izquierda
                Item {
                    anchors.fill: parent
                    implicitHeight: parent.implicitHeight
                    Layout.preferredWidth: 300

                    Row {
                        anchors.fill: parent
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        ActionButtonIcon {
                            colBackground: "transparent"
                            colBackgroundHover: "transparent"
                            iconImage: "redhat-symbolic"
                            iconSize: 18
                            implicitHeight: parent.height 
                            onPressed: {
                                Quickshell.execDetached(["bash", "-c", "~/.config/rofi/launcher/launch.sh"])
                            }
                        }
                        Separator { implicitWidth: 10 }
                        AppLabel {}
                        Separator { implicitWidth: 5 }
                        ActionButton {
                            colBackground: "transparent"
                            colBackgroundHover: Appearance.colors.colprimary_hover
                            buttonText: "Volume"
                            implicitHeight: parent.height 
                            releaseAction: () => {
                                Panels.hack.open()
                            }
                        }
                        ActionButton {
                            colBackground: "transparent"
                            colBackgroundHover: Appearance.colors.colprimary_hover
                            buttonText: "Configuración"
                            implicitHeight: parent.height
                            onPressed: {
                                Quickshell.execDetached(["qs", "-p", root.settingsQmlPath])
                            }
                            releaseAction: () => {
                                GlobalStates.notchSettingsOpen = true
                            }
                        }
                    }
                }

                // Zona central
                Item {
                    implicitHeight: parent.implicitHeight
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

                    Row {
                        anchors.centerIn: parent
                        height: parent.height
                        spacing: 4

                        ActionButtonIcon {
                            anchors.verticalCenter: parent.verticalCenter
                            colBackground: Appearance.colors.colsecondary
                            colBackgroundHover: Appearance.colors.colsecondary_hover
                            iconNerd: "󰆧"
                            iconSize: 16
                            implicitHeight: parent.height - Appearance.margins.itemBarMargin
                            buttonRadiusTopLeft: Appearance.rounding.full
                            buttonRadiusTopRight: Appearance.rounding.full
                            buttonRadiusBottomLeft: Appearance.rounding.full
                            buttonRadiusBottomRight: Appearance.rounding.full
                            onHovered: () => {
                                DrawersManager.openPopup("hack")
                            }
                        }
                        ActionButtonIcon {
                            anchors.verticalCenter: parent.verticalCenter
                            colBackground: Appearance.colors.colsecondary
                            colBackgroundHover: Appearance.colors.colsecondary_hover
                            iconMaterial: "screenshot_region"
                            iconSize: 14
                            implicitHeight: parent.height - Appearance.margins.itemBarMargin
                            buttonRadiusTopLeft: Appearance.rounding.full
                            buttonRadiusTopRight: Appearance.rounding.full
                            buttonRadiusBottomLeft: Appearance.rounding.full
                            buttonRadiusBottomRight: Appearance.rounding.full
                            onPressed: {
                                Quickshell.execDetached(["bash", "-c", "~/.config/quickshell/scripts/screenshot.sh"])
                            }
                        }
                        Workspaces { }
                        ActionButtonIcon {
                            anchors.verticalCenter: parent.verticalCenter
                            colBackground: Appearance.colors.colsecondary
                            colBackgroundHover: Appearance.colors.colsecondary_hover
                            iconImage: "picker-symbolic.svg"
                            iconSize: 14
                            implicitHeight: parent.height - Appearance.margins.itemBarMargin
                            buttonRadiusTopLeft: Appearance.rounding.full
                            buttonRadiusTopRight: Appearance.rounding.full
                            buttonRadiusBottomLeft: Appearance.rounding.full
                            buttonRadiusBottomRight: Appearance.rounding.full
                            onPressed: {
                                Quickshell.execDetached(["bash", "-c", "hyprpicker | wl-copy -n"])
                            }
                        }
                        ActionButtonIcon {
                            anchors.verticalCenter: parent.verticalCenter
                            colBackground: Appearance.colors.colsecondary
                            colBackgroundHover: Appearance.colors.colsecondary_hover
                            iconMaterial: "wallpaper"
                            iconSize: 14
                            implicitHeight: parent.height - Appearance.margins.itemBarMargin
                            buttonRadiusTopLeft: Appearance.rounding.full
                            buttonRadiusTopRight: Appearance.rounding.full
                            buttonRadiusBottomLeft: Appearance.rounding.full
                            buttonRadiusBottomRight: Appearance.rounding.full
                            onPressed: {
                                Quickshell.execDetached(["bash", "-c", "hyprpicker | wl-copy -n"])
                            }
                        }
                    }
                }

                // Zona derecha
                Item {
                    anchors.fill: parent
                    implicitHeight: parent.implicitHeight
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight 
                    Layout.preferredWidth: 300

                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 6
                        spacing: 8
                        Battery {}
                        ActionButtonMultiIcon {
                            iconList: [
                                Icons.getNetworkIcon(50),
                                Icons.getBluetoothIcon(true)

                            ]
                            columns: 2
                            colBackground: "transparent"
                            colBackgroundHover: Appearance.colors.colprimary_hover
                            iconSize: 14
                            buttonRadiusTopLeft: Appearance.rounding.verysmall
                            buttonRadiusTopRight: Appearance.rounding.verysmall
                            buttonRadiusBottomLeft: Appearance.rounding.verysmall
                            buttonRadiusBottomRight: Appearance.rounding.verysmall

                            implicitHeight: bar.height - Appearance.margins.itemBarMargin
                            releaseAction: () => {
                                GlobalStates.sidebarRightOpen = true
                            }
                        }
                        Clock {}
                    }
                }
            }
        }
    }
}