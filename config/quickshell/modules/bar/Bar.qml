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
            color: "transparent"
            anchors {
                top: true
                left: true
                right: true
            }
            property string pathIcons: "root:/assets/icons/"
            property string colorMain: "transparent"
            property string pathScripts: "~/.config/quickshell/scripts/"

            implicitHeight: Appearance.sizes.barHeight
            WlrLayershell.layer: WlrLayer.Overlay


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
                        anchors.leftMargin: 14
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
                            colBackgroundHover: "#111111"
                            buttonText: "Volume"
                            implicitHeight: parent.height 
                            releaseAction: () => {
                                GlobalStates.onScreenVolumeOpen = true
                            }
                        }
                        ActionButton {
                            colBackground: "transparent"
                            colBackgroundHover: "#111111"
                            buttonText: "Configuración"
                            implicitHeight: parent.height
                            onPressed: {
                                Quickshell.execDetached(["qs", "-p", root.settingsQmlPath])
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
                        spacing: 8
                        ActionButtonIcon {
                            anchors.verticalCenter: parent.verticalCenter
                            colBackground: "#111111"
                            colBackgroundHover: "transparent"
                            iconMaterial: "screenshot_region"
                            iconSize: 14
                            implicitHeight: parent.height - 2
                            buttonRadiusTopLeft: 10
                            buttonRadiusTopRight: 10
                            buttonRadiusBottomLeft: 10
                            buttonRadiusBottomRight: 10
                            onPressed: {
                                Quickshell.execDetached(["bash", "-c", "~/.config/quickshell/scripts/screenshot.sh"])
                            }
                        }
                        Workspaces { }
                        ActionButtonIcon {
                            anchors.verticalCenter: parent.verticalCenter
                            colBackground: "#111111"
                            colBackgroundHover: "transparent"
                            iconImage: "picker-symbolic.svg"
                            iconSize: 14
                            implicitHeight: parent.height - 2
                            buttonRadiusTopLeft: 10
                            buttonRadiusTopRight: 10
                            buttonRadiusBottomLeft: 10
                            buttonRadiusBottomRight: 10
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
                        anchors.rightMargin: 14
                        spacing: 8
                        Battery {}
                        ActionButtonMultiIcon {
                            iconList: [
                                Icons.getNetworkIcon(50),
                                Icons.getBluetoothIcon(true)

                            ]
                            columns: 2
                            colBackground: "transparent"
                            colBackgroundHover: "#111111"
                            iconSize: 14
                            buttonRadiusTopLeft: 10
                            buttonRadiusTopRight: 10
                            buttonRadiusBottomLeft: 10
                            buttonRadiusBottomRight: 10

                            implicitHeight: bar.height
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