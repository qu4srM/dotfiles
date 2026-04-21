import qs
import qs.modules.capsule.components
import qs.configs
import qs.configs.utils
import qs.widgets 
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

Item {
    id: root 
    property bool show
    implicitWidth: rowLayout.implicitWidth
    implicitHeight: rowLayout.implicitHeight


    RowLayout {
        id: rowLayout
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        Media {
            show: root.show
            implicitHeight: 160
        }
        ColumnLayout {
            Layout.fillHeight: true
            Layout.leftMargin: 8
            spacing: 8
            Rectangle {
                implicitWidth: userdata.implicitWidth + 16
                implicitHeight: userdata.implicitHeight + 16
                color: Appearance.colors.colCapsuleSurface
                radius: Appearance.rounding.small

                RowLayout {
                    id: userdata
                    anchors.centerIn: parent
                    ClippingRectangle {
                        implicitWidth: 80
                        implicitHeight: implicitWidth
                        color: "transparent"
                        radius: Appearance.rounding.full 
                        border.width: 2
                        border.color: Appearance.colors.colPrimary
                        Image {
                            anchors.fill: parent
                            source: Config.options.user.avatar
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                            smooth: true
                            mipmap: true
                        }
                    }
                    Column {
                        Layout.alignment: Qt.AlignVCenter
                        StyledText {
                            text: SystemInfo.username + "@" + SystemInfo.hostname
                            color: Appearance.colors.colPrimary
                        }
                        Row {
                            spacing: 4
                            CustomIcon { 
                                size: 18
                                source: SystemInfo.distroIcon
                                colorize: true 
                                color: "white"
                            }
                            StyledText {
                                text: SystemInfo.distroName
                                font.pixelSize: 16
                                color: Appearance.colors.colText
                            }
                        }
                        Row {
                            spacing: 4
                            StyledMaterialSymbol { 
                                text: "select_window"
                                size: 18
                                color: "white"
                                fill: 1
                            }
                            StyledText {
                                text: SystemInfo.desktopEnvironment
                                font.pixelSize: 16
                                color: Appearance.colors.colText
                            }
                        }
                        Row {
                            spacing: 4
                            StyledMaterialSymbol { 
                                text: "timer"
                                size: 18
                                color: "white"
                                fill: 1
                            }
                            StyledText {
                                text: SystemInfo.uptime
                                font.pixelSize: 16
                                color: Appearance.colors.colText 

                            }
                        }
                    }

                }
            }
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Appearance.colors.colCapsuleSurface
                radius: Appearance.rounding.small
                RowLayout {
                    anchors.centerIn: parent
                    spacing: 4
                    StyledMaterialSymbol {
                        text: "deployed_code"
                        size: 18
                        color: Appearance.colors.colPrimary
                    }
                    StyledText {
                        text: HackingData.vpnIp
                        color: Appearance.colors.colPrimary
                    }
                }
            }
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Appearance.colors.colCapsuleSurface
                radius: Appearance.rounding.small
                RowLayout {
                    anchors.centerIn: parent
                    spacing: 4
                    StyledMaterialSymbol {
                        text: "view_in_ar"
                        size: 18
                        color: Appearance.colors.colPrimary
                    }
                    StyledText {
                        text: HackingData.targetIp == "" ? "Target" : HackingData.targetIp
                        color: Appearance.colors.colPrimary
                    }
                }
            }
            


        }
        ProgressBarV{
            colorMain: Appearance.colors.colPrimary 
            colorBg: Appearance.colors.colCapsuleSurface
            implicitWidth: 40
            Layout.fillHeight: true
            icon: value === 0.0 ? "music_off" : "music_note"
            size: 18
            value: (Audio.muted)
                ? 0.0
                : (Audio.sink?.audio?.volume ?? 0.0)

            motionAction: (value) => {
                value = Math.max(0, Math.min(1, value));
                Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", `${Math.round(value * 100)}%`,"+ -l 1.5"]);
            }
        }
        ProgressBarV {
            id: brightnessBar
            colorMain: Appearance.colors.colPrimary 
            colorBg: Appearance.colors.colCapsuleSurface
            
            implicitWidth: 40
            Layout.fillHeight: true

            value: Brightness.value
            icon: "light_mode"
            rotateIcon: true

            // Cambiar brillo al deslizar
            motionAction: (val) => Brightness.setBrightness(val)

            // Escucha cambios de brillo en tiempo real
            Connections {
                target: Brightness
                function onBrightnessChanged(v) {
                    brightnessBar.value = v
                }
            }
        }
    }
    
}
