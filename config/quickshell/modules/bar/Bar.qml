import qs 
import qs.configs
import qs.modules.bar.components
import qs.widgets 
import qs.utils
import qs.services

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
    Variants {
        model: Quickshell.screens
        LazyLoader {
            id: barLoader 
            active: GlobalStates.barOpen && !GlobalStates.screenLock
            required property ShellScreen modelData 
            component: StyledWindow {
                id: bar
                screen: barLoader.modelData
                name: "bar"
                color: "transparent"
                anchors {
                    top: true
                    left: true
                    right: true
                }
                margins {
                    left: Config.options.bar.floating ? Appearance.margins.panelMargin : 0
                    right: Config.options.bar.floating ? Appearance.margins.panelMargin : 0
                    top: Config.options.bar.floating ? Appearance.margins.panelMargin : 0
                }
                property string pathIcons: "root:/assets/icons/"
                property string colorMain: "transparent"
                property string pathScripts: "~/.config/quickshell/scripts/"

                implicitHeight: Appearance.sizes.barHeight
                WlrLayershell.layer: WlrLayer.Top
                Rectangle {
                    visible: !Config.options.bar.showBackground 
                    id: shadow
                    anchors.top: parent.top 
                    implicitWidth: parent.width 
                    implicitHeight: 1
                    color: "transparent"
                }
                StyledRectangularShadow {
                    visible: !Config.options.bar.showBackground 
                    target: shadow
                    blur: 30
                }
                // Content >
                Rectangle {
                    anchors.fill: parent 
                    color: Config.options.bar.showBackground ? Appearance.colors.colSurface : "transparent"
                    radius: Config.options.bar.floating ? Appearance.rounding.normal : 0
                    RowLayout {
                        id: row
                        anchors.fill: parent
                        spacing: 0

                        Item {
                            Layout.preferredWidth: 300
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft

                            RowLayout {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 6
                                ActionButtonIcon {
                                    colBackground: "transparent"
                                    colBackgroundHover: "transparent"
                                    iconImage: "redhat-symbolic"
                                    iconSize: 18
                                    implicitHeight: bar.implicitHeight 
                                    releaseAction: () => {
                                        GlobalStates.sidebarLeftOpen = true
                                    }
                                }
                                Separator { implicitWidth: 10 }
                                AppLabel {}
                                Separator { implicitWidth: 5 }
                                ActionButton {
                                    colBackground: "transparent"
                                    colBackgroundHover: Appearance.colors.colPrimaryHover
                                    buttonText: Translation.tr("Apps")
                                    implicitHeight: bar.implicitHeight 
                                    releaseAction: () => {
                                        GlobalStates.launcherOpen = true
                                    }
                                }
                                ActionButton {
                                    colBackground: "transparent"
                                    colBackgroundHover: Appearance.colors.colPrimaryHover
                                    buttonText: Translation.tr("Cheat sheet")
                                    implicitHeight: bar.implicitHeight 
                                    onPressed: {
                                        Quickshell.execDetached(["qs", "-p", root.settingsQmlPath])
                                    }
                                }
                                ActionButton {
                                    colBackground: "transparent"
                                    colBackgroundHover: Appearance.colors.colPrimaryHover
                                    buttonText: Translation.tr("Wallpapers")
                                    implicitHeight: bar.implicitHeight 
                                    releaseAction: () => {
                                        GlobalStates.wallSelectorOpen = true
                                    }
                                }
                            }
                        }
                        
                        Item {
                            Layout.fillWidth: true
                            implicitHeight: parent.implicitHeight
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

                            Row {
                                anchors.centerIn: parent
                                height: parent.height
                                spacing: 4

                                ActionButtonIcon {
                                    anchors.verticalCenter: parent.verticalCenter
                                    colBackground: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                                    colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colsecondary_hover : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                                    iconMaterial: "screenshot_region"
                                    iconSize: 16
                                    materialIconFill: true
                                    implicitHeight: bar.implicitHeight - 6
                                    buttonRadiusTopLeft: Appearance.rounding.full
                                    buttonRadiusTopRight: Appearance.rounding.full
                                    buttonRadiusBottomLeft: Appearance.rounding.full
                                    buttonRadiusBottomRight: Appearance.rounding.full
                                    onPressed: {
                                        Quickshell.execDetached(["bash", "-c", "~/.config/quickshell/scripts/screenshot.sh"])
                                    }
                                }
                                
                                Workspaces {
                                    implicitHeight: bar.implicitHeight - 6
                                }
                                ActionButtonIcon {
                                    anchors.verticalCenter: parent.verticalCenter
                                    colBackground: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                                    colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colsecondary_hover : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                                    iconMaterial: "dropper_eye"
                                    iconSize: 16
                                    materialIconFill: true
                                    implicitHeight: bar.implicitHeight - 6
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
                        Item {
                            Layout.preferredWidth: 300
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight

                            RowLayout {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: 6
                                spacing: 8
                                Battery {}
                                ActionButtonMultiIcon {
                                    iconList: [
                                        Icons.getNetworkIcon(50),
                                        Icons.getBluetoothIcon(true),
                                        "volume_up"
                                    ]
                                    columns: iconList.length
                                    colBackground: "transparent"
                                    colBackgroundHover: Appearance.colors.colPrimaryHover
                                    iconSize: Appearance.font.pixelSize.small
                                    buttonRadiusTopLeft: Appearance.rounding.verysmall
                                    buttonRadiusTopRight: Appearance.rounding.verysmall
                                    buttonRadiusBottomLeft: Appearance.rounding.verysmall
                                    buttonRadiusBottomRight: Appearance.rounding.verysmall

                                    implicitHeight: bar.height - Appearance.margins.itemBarMargin
                                    releaseAction: () => {
                                        GlobalStates.sidebarRightOpen = true
                                    }
                                }
                                StyledText {
                                    id: clock
                                    text: Time.date + " " + Time.time
                                }
                            }
                        }
                    }
                }
                
            }
        }
    }
}