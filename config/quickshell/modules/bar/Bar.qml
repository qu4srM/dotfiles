import "root:/"
import "root:/modules/common/"
import "root:/modules/sidebar/"
import "root:/modules/bar/components/"
import "root:/modules/drawers/"
import "root:/widgets/"
import "root:/utils/"

import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland


Scope {
    id: root
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
                        ButtonIcon { iconSystem: "redhat-symbolic.svg"; command: "~/.config/rofi/launcher/launch.sh"; size: 18 }
                        Separator { implicitWidth: 10 }
                        AppLabel {}
                        Separator { implicitWidth: 5 }
                        ButtonText { text: "Atajos"; command: bar.pathScripts + "screenshot.sh" }
                        ButtonText { text: "Configuración"; command: "..." }
                        ButtonText { text: "HackTheBox"; command: "..." }
                        ButtonText { text: "Hola" ; command: "..." }
                    }
                }

                // Zona central
                Item {
                    anchors.fill: parent
                    implicitHeight: parent.implicitHeight
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

                    Row {
                        anchors.centerIn: parent
                        spacing: 8
                        StyledButtonIcon { iconSource: "screenshot-light.svg"; command: bar.pathScripts + "screenshot.sh" ; background: "#000000"; size: 14 }
                        Workspaces { }
                        StyledButtonIcon { iconSource: "picker-symbolic.svg"; command: "hyprpicker | wl-copy -n"; background: "#000000"; size: 14 }
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
                        ButtonMultiIcon {
                            item: rowMultiButtonIcon
                            h: bar.implicitHeight
                            active: GlobalStates.sidebarRightOpen
                            onToggled: (value) => GlobalStates.sidebarRightOpen = value

                            Row {
                                id: rowMultiButtonIcon
                                anchors.centerIn: parent
                                spacing: 8
                                StyledIcon { iconSystem: Icons.getNetworkIcon(40); size: 12 }
                                StyledIcon { iconSystem: Icons.getBluetoothIcon(true); size: 12 }
                            }
                        }
                        Clock {}
                    }
                }
            }
        }
    }
}