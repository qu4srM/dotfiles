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
                        spacing: 6
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
                        Separator { implicitWidth: 0 }
                        AppLabel {}
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
                        ActionButton {
                            colBackground: "transparent"
                            colBackgroundHover: Appearance.colors.colPrimaryHover
                            buttonText: Translation.tr("Wallpapers")
                            implicitHeight: bar.implicitHeight 
                            releaseAction: () => GlobalStates.wallSelectorOpen = true
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
                            command: "~/.config/quickshell/scripts/htb_status.sh status"
                            releaseAction: () => {
                                Quickshell.execDetached(["bash", "-c", `echo "${ipHost.commandText}" | wl-copy -n`])
                            }
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
                            onPressed: Quickshell.execDetached(["bash", "-c", "~/.config/quickshell/scripts/screenshot.sh"])
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
                            onPressed: Quickshell.execDetached(["bash", "-c", "hyprpicker | wl-copy -n"])
                        }
                        IconTextButton {
                            id: targetIp
                            colBackground: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                            colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colSecondaryHover : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                            implicitWidth: 120
                            implicitHeight: parent.height
                            buttonRadius: Appearance.rounding.full
                            buttonIcon: "view_in_ar"
                            command: "~/.config/quickshell/scripts/htb_status.sh target"
                            releaseAction: () => {
                                Quickshell.execDetached(["bash", "-c", `echo "${targetIp.commandText}" | wl-copy -n`])
                            }
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
                        /*
                        ActionButtonMultiIcon {
                            Layout.preferredHeight: bar.implicitHeight
                            Layout.alignment: Qt.AlignVCenter
                            iconList: [
                                Icons.getNetworkIcon(50),
                                Icons.getBluetoothIcon(true),
                                "volume_up"
                            ]
                            columns: iconList.length
                            colBackground: "transparent"
                            colBackgroundHover: Appearance.colors.colPrimaryHover
                            iconSize: Appearance.font.pixelSize.small
                            buttonRadius: Appearance.rounding.verysmall
                            releaseAction: () => GlobalStates.sidebarRightOpen = true
                        }*/
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
                            releaseAction: () => {GlobalStates.sidebarRightOpen = true}
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
