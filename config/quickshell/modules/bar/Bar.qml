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

                // --- CONTENIDO PRINCIPAL ---
                Rectangle {
                    anchors.fill: parent 
                    color: Config.options.bar.showBackground ? Appearance.colors.colSurface : "transparent"
                    radius: Config.options.bar.floating ? Appearance.rounding.normal : 0

                    // === IZQUIERDA ===
                    RowLayout {
                        id: leftRow
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: Appearance.margins.panelMargin
                        spacing: 0
                        width: Math.min(implicitWidth, parent.width * 0.35)
                        ActionButton {
                            colBackground: "transparent"
                            colBackgroundHover: "transparent"
                            implicitHeight: bar.implicitHeight 
                            releaseAction: () => GlobalStates.sidebarLeftOpen = true
                            contentItem: Item { 
                                width: parent.width
                                CustomIcon {
                                    colorize: true 
                                    color: Appearance.colors.colOutline
                                    anchors.centerIn: parent 
                                    source: "gemini-symbolic"
                                    size: Appearance.font.pixelSize.large
                                }
                            }
                        }
                        Separator { implicitWidth: 10 }
                        AppLabel {}
                        Separator { implicitWidth: 6 }
                        ActionButton {
                            colBackground: "transparent"
                            colBackgroundHover: Appearance.colors.colPrimaryHover
                            buttonText: Translation.tr("Apps")
                            implicitHeight: bar.implicitHeight 
                            releaseAction: () => GlobalStates.launcherOpen = true
                        }
                        /*
                        ActionButton {
                            colBackground: "transparent"
                            colBackgroundHover: Appearance.colors.colPrimaryHover
                            buttonText: Paths.getName("/home/qu4s4r/Pictures/wall-05.jpg")
                            implicitHeight: bar.implicitHeight 
                            releaseAction: () => {
                                const pathFile = Config.options.background.wallpaperPath;
                                const nameFile = Paths.getName(pathFile)

                                Quickshell.execDetached([
                                    "bash", "-c",
                                    `~/.local/share/pipx/venvs/rembg/bin/python ~/.config/quickshell/scripts/create_depth_image_rembg.py ${pathFile} ~/.cache/quickshell/overlay/${nameFile}-overlay.png`
                                ])
                                Config.options.background.wallpaperOverlayPath = Paths.strip(Paths.cache + "/quickshell/overlay/" + Paths.getName(Config.options.background.wallpaperPath)) + "-overlay.png"
                                console.log("Execute")
                            }
                        }*/
                        /*
                        ActionButton {
                            colBackground: "transparent"
                            colBackgroundHover: Appearance.colors.colPrimaryHover
                            //buttonText: Wallpapers.nameWallpaper
                            //buttonText: `${Paths.strip(Paths.cache)}/quickshell/overlay/${Paths.getName(Config.options.background.wallpaperPath)}`
                            implicitHeight: bar.implicitHeight 
                            releaseAction: () => {
                                //Wallpapers.updateOverlay(`${Paths.strip(Paths.cache)}/quickshell/overlay/${Paths.getName(Config.options.background.wallpaperPath)}`)
                            }
                        }*/
                        /*
                        ActionButton {
                            colBackground: "transparent"
                            colBackgroundHover: Appearance.colors.colPrimaryHover
                            buttonText: Translation.tr("Wallpapers")
                            implicitHeight: bar.implicitHeight 
                            releaseAction: () => GlobalStates.wallSelectorOpen = true
                        }*/
                        IconTextButton {
                            colBackground: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                            colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colSecondaryHover : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                            implicitWidth: 120
                            implicitHeight: parent.height - 12
                            buttonRadius: Appearance.rounding.full
                            buttonIcon: "host"
                            buttonText: HackingData.hostIp
                            releaseAction: Execute.copyTextToClipboard(HackingData.hostIp)
                        }
                    }

                    // === CENTRO ===
                    RowLayout {
                        id: centerRow
                        anchors.horizontalCenter: parent.horizontalCenter 
                        anchors.top: parent.top 
                        anchors.bottom: parent.bottom
                        anchors.margins: 6
                        spacing: 4
                        width: implicitWidth
                        IconTextButton {
                            id: ipHost
                            colBackground: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                            colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colSecondaryHover : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                            implicitWidth: 120
                            implicitHeight: parent.height
                            buttonRadius: Appearance.rounding.full
                            buttonIcon: "deployed_code"
                            buttonText: HackingData.vpnIp
                            releaseAction: Execute.copyTextToClipboard(HackingData.vpnIp)
                        }

                        ActionButtonIcon {
                            Layout.alignment: Qt.AlignVCenter
                            colBackground: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                            colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colsecondary_hover : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                            iconMaterial: "screenshot_region"
                            iconSize: 16
                            materialIconFill: true
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
                            implicitHeight: parent.height
                            implicitWidth: implicitHeight
                            buttonRadius: Appearance.rounding.full
                            onPressed: Execute.openHyprpicker()
                        }
                        IconTextButton {
                            id: targetIp
                            colBackground: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                            colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colSecondaryHover : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                            implicitWidth: 120
                            implicitHeight: parent.height
                            buttonRadius: Appearance.rounding.full
                            buttonIcon: "view_in_ar"
                            buttonText: HackingData.targetIp
                            releaseAction: Execute.copyTextToClipboard(HackingData.targetIp)
                        }
                    }

                    // === DERECHA ===
                    RowLayout {
                        id: rightRow
                        anchors.right: parent.right
                        anchors.top: parent.top 
                        anchors.bottom: parent.bottom
                        anchors.margins: 6

                        anchors.rightMargin: Appearance.margins.panelMargin
                        spacing: 4
                        width: implicitWidth

                        Battery {
                            implicitHeight: parent.height -6
                        }
                        MultiIconButton {
                            Layout.alignment: Qt.AlignVCenter
                            implicitHeight: parent.height
                            iconList: [
                                Icons.getNetworkIcon(50),
                                Icons.getBluetoothIcon(true),
                                "volume_up"
                            ]
                            colBackground: "transparent"
                            colBackgroundHover: Appearance.colors.colPrimaryHover
                            iconSize: Appearance.font.pixelSize.normal
                            buttonRadius: Appearance.rounding.full
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
