import qs 
import qs.configs
import qs.modules.bar.components
import qs.widgets 
import qs.utils
import qs.services

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

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
                    left: 0
                    right: 0
                    top: 0//Appearance.margins.panelMargin
                }
                property string pathIcons: "root:/assets/icons/"
                property string colorMain: "transparent"
                property string pathScripts: "~/.config/quickshell/scripts/"

                implicitHeight: Appearance.sizes.barHeight
                WlrLayershell.layer: WlrLayer.Top
                /*
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
                }*/

                Rectangle {
                    anchors.fill: parent 
                    color: Config.options.bar.showBackground ? Appearance.colors.colBackground : "transparent"//Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                    radius: Config.options.bar.floating ? Appearance.rounding.normal : 0

                    // === IZQUIERDA ===
                    RowLayout {
                        id: leftRow
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: Appearance.margins.panelMargin
                        spacing: Appearance.margins.panelMargin
                        width: Math.min(implicitWidth, parent.width * 0.35)
                        Workspaces {
                            implicitHeight: parent.height - 8
                        }
                        
                        AppLabel {}
                        
                        
                        //MediaControl {}
                        
                        
                        
                        ActionButton {
                            colBackground: "transparent"
                            colBackgroundHover: Appearance.colors.colOnPrimary
                            buttonText: Translation.tr("Overview")
                            changeColor: true 
                            textColor: "black"
                            implicitHeight: bar.implicitHeight 
                            releaseAction: () => GlobalStates.overviewOpen = !GlobalStates.overviewOpen 
                        }
                        /*
                        IconTextButton {
                            colBackground: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                            colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colSecondaryHover : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                            implicitWidth: 120
                            implicitHeight: parent.height - 12
                            buttonRadius: Appearance.rounding.full
                            buttonIcon: "host"
                            buttonText: HackingData.hostIp
                            releaseAction: Execute.copyTextToClipboard(HackingData.hostIp)
                        }*/
                        
                    }

                    // === CENTRO ===
                    RowLayout {
                        visible: false
                        id: centerRow
                        anchors.horizontalCenter: parent.horizontalCenter 
                        anchors.top: parent.top 
                        anchors.bottom: parent.bottom
                        anchors.margins: Appearance.margins.panelMargin
                        spacing: Appearance.margins.panelMargin
                        width: implicitWidth

                        
                        ContainerRectangle {
                            implicitWidth: 130
                            implicitHeight: parent.height
                            RowLayout {
                                anchors.centerIn: parent 
                                spacing: 4
                                StyledMaterialSymbol {
                                    text: "deployed_code"
                                    size: 18
                                    color: Config.options.bar.showBackground ? Appearance.colors.colText : "white"
                                }
                                StyledText {
                                text: HackingData.vpnIp
                                }
                            }
                        }

                        ActionButtonIcon {
                            Layout.alignment: Qt.AlignVCenter
                            colBackground: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                            colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colsecondary_hover : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                            iconMaterial: "screenshot_region"
                            iconSize: 16
                            materialIconFill: true
                            changeColor: true
                            iconColor: Config.options.bar.showBackground ? Appearance.colors.colText : "white"
                            implicitHeight: parent.height
                            implicitWidth: implicitHeight
                            buttonRadius: Appearance.rounding.full
                            onPressed: Execute.openScreenshot()
                        }

                        Workspaces {
                            implicitHeight: parent.height
                        }

                        ActionButtonIcon {
                            Layout.alignment: Qt.AlignVCenter
                            colBackground: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                            colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colsecondary_hover : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                            iconMaterial: "dropper_eye"
                            iconSize: 16
                            materialIconFill: true
                            changeColor: true
                            iconColor: Config.options.bar.showBackground ? Appearance.colors.colText : "white"
                            implicitHeight: parent.height
                            implicitWidth: implicitHeight
                            buttonRadius: Appearance.rounding.full
                            onPressed: Execute.openHyprpicker()
                        }
                        ContainerRectangle {
                            implicitWidth: 130
                            implicitHeight: parent.height
                            RowLayout {
                                anchors.centerIn: parent 
                                spacing: 4
                                StyledMaterialSymbol {
                                    text: "view_in_ar"
                                    size: 18
                                    color: Config.options.bar.showBackground ? Appearance.colors.colText : "white"
                                }
                                StyledText {
                                    text: HackingData.targetIp
                                }
                            }
                        }
                    }

                    // === DERECHA ===
                    RowLayout {
                        id: rightRow
                        anchors.right: parent.right
                        anchors.top: parent.top 
                        anchors.bottom: parent.bottom
                        anchors.margins: Appearance.margins.panelMargin
                        spacing: Appearance.margins.panelMargin
                        width: implicitWidth
                        ActionButtonIcon {
                            Layout.alignment: Qt.AlignVCenter
                            colBackground: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                            colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colsecondary_hover : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                            iconMaterial: "dropper_eye"
                            iconSize: 16
                            materialIconFill: true
                            changeColor: true
                            iconColor: Config.options.bar.showBackground ? Appearance.colors.colText : "white"
                            implicitHeight: parent.height
                            implicitWidth: implicitHeight
                            buttonRadius: Appearance.rounding.full
                            onPressed: Execute.openHyprpicker()
                        }
                        ActionButtonIcon {
                            Layout.alignment: Qt.AlignVCenter
                            colBackground: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : "transparent"
                            colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colsecondary_hover : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                            iconMaterial: "screenshot_region"
                            iconSize: Appearance.font.pixelSize.large
                            materialIconFill: true
                            changeColor: true
                            iconColor: Config.options.bar.showBackground ? Appearance.colors.colText : Appearance.colors.colOnText
                            implicitHeight: parent.height
                            implicitWidth: implicitHeight
                            buttonRadius: Appearance.rounding.full
                            onPressed: Execute.openScreenshot()
                        }
                        ActionButtonIcon {
                            Layout.alignment: Qt.AlignVCenter
                            colBackground: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : "transparent"
                            colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colsecondary_hover : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                            iconMaterial: "note_stack_add"
                            iconSize: Appearance.font.pixelSize.large
                            materialIconFill: true
                            changeColor: true
                            iconColor: Config.options.bar.showBackground ? Appearance.colors.colText : Appearance.colors.colOnText
                            implicitHeight: parent.height
                            implicitWidth: implicitHeight
                            buttonRadius: Appearance.rounding.full
                            releaseAction: () => {
                                Quickshell.execDetached(["bash", "-c", "qs ipc call notes addNote"])
                            }
                            altAction: () => {
                                GlobalStates.sticksOpen = !GlobalStates.sticksOpen
                            }
                        }

                        Battery {
                            implicitHeight: parent.height -6
                        }
                        ActionButtonIcon {
                            Layout.alignment: Qt.AlignVCenter
                            colBackground: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : "transparent"
                            colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colsecondary_hover : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                            iconMaterial: "instant_mix"
                            iconSize: Appearance.font.pixelSize.large
                            materialIconFill: true
                            changeColor: true
                            iconColor: Config.options.bar.showBackground ? Appearance.colors.colText : Appearance.colors.colOnText
                            implicitHeight: parent.height
                            implicitWidth: implicitHeight
                            buttonRadius: Appearance.rounding.full
                            releaseAction: () => {
                                GlobalStates.sidebarRightOpen = true
                            }
                        }
                        
                        ContainerRectangle {
                            implicitWidth: clock.implicitWidth + 10
                            implicitHeight: parent.height
                            StyledText {
                                id: clock
                                anchors.centerIn: parent
                                text: Time.date + " " + Time.time
                            }
                        }
                        
                    }
                }
            }
        }
    }
}
