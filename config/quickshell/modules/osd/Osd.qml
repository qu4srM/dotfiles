import "root:/"
import "root:/modules/common/"
import "root:/modules/bar/components/"
import "root:/modules/drawers/"
import "root:/modules/sidebar/"
import "root:/widgets/"
import "root:/utils/"
import "root:/modules/drawers/shapes/" as Shapes
import "root:/services/"

import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
import QtQuick.Layouts
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import Quickshell.Io
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        StyledWindow {
            id: volume
            required property ShellScreen screen

            visible: GlobalStates.osdOpen
            screen: screen
            name: "osd"
            color: "transparent"
            exclusiveZone: 0

            anchors {
                left: true
            }

            function hide() {
                GlobalStates.osdOpen = false
            }

            implicitWidth: Appearance.sizes.volumeWidth
            implicitHeight: 400

            property string pathIcons: "root:/assets/icons/"
            property string colorMain: "transparent"
            property string pathScripts: "~/.config/quickshell/scripts/"

            HyprlandFocusGrab {
                id: grab
                windows: [ volume ]
                active: GlobalStates.osdOpen
                onCleared: () => {
                    if (!active) volume.hide()
                }
            }

            Timer {
                id: autoHideTimer
                interval: 3000
                repeat: false
                onTriggered: volume.hide()
            }

            Connections {
                target: Audio.sink?.audio
                function onVolumeChanged() {
                    GlobalStates.osdOpen = true
                    autoHideTimer.restart()
                }
            }
            
            Column {
                anchors.fill: parent
                spacing: 0
                Loader {
                    id: brightnessLoader
                    active: GlobalStates.osdOpen
                    height: parent.height / 2
                    width: parent.width
                    focus: GlobalStates.osdOpen

                    Keys.onPressed: (event) => {
                        if (event.key === Qt.Key_Escape) {
                            volume.hide();
                        }
                    }

                    sourceComponent: Item {
                        implicitWidth: parent.width 
                        implicitHeight: parent.height

                        Shape {
                            id: background
                            anchors.fill: parent 
                            preferredRendererType: Shape.CurveRenderer

                            Shapes.Left {
                                w: parent.width - 20
                                h: parent.height - 40
                                rounding: 10
                                colorMain: "#000000"
                                startX: 0 + rounding
                                startY: 10
                            }

                            Column {
                                anchors.fill: parent
                                spacing: 0

                                StyledIcon {
                                    iconSystem: "display-brightness"
                                    size: 14
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.top: parent.top
                                    anchors.topMargin: 20
                                }

                                ProgressBarV {
                                    id: progressBar
                                    colorMain: "#1689be"
                                    colorBg: "white"
                                    value: Audio.sink?.audio.volume ?? 0.0

                                    motionAction: (value) => {
                                        let volume = Math.round(value * 100);
                                        Quickshell.execDetached(["amixer", "set", "Master", volume + "%"]);
                                    }
                                }

                                Text {
                                    text: Math.round((Audio.sink?.audio.volume ?? 0.0) * 100).toString()
                                    color: "white"
                                    font.pixelSize: 12
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.bottom: parent.bottom
                                    anchors.bottomMargin: 16
                                }
                            }
                        }
                    }
                }
                Loader {
                    id: volumeLoader
                    active: GlobalStates.osdOpen
                    height: parent.height / 2
                    width: parent.width

                    focus: GlobalStates.osdOpen

                    Keys.onPressed: (event) => {
                        if (event.key === Qt.Key_Escape) {
                            volume.hide();
                        }
                    }

                    sourceComponent: Item {
                        implicitWidth: parent.width 
                        implicitHeight: parent.height

                        Shape {
                            id: background
                            anchors.fill: parent 
                            preferredRendererType: Shape.CurveRenderer

                            Shapes.Left {
                                w: parent.width - 20
                                h: parent.height - 40
                                rounding: 10
                                colorMain: "#000000"
                                startX: 0 + rounding
                                startY: 10
                            }

                            Column {
                                anchors.fill: parent
                                spacing: 0

                                StyledIcon {
                                    iconSystem: "audio-volume-high"
                                    size: 14
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.top: parent.top
                                    anchors.topMargin: 20
                                }

                                ProgressBarV {
                                    id: progressBar
                                    colorMain: "#1689be"
                                    colorBg: "white"
                                    value: Audio.sink?.audio.volume ?? 0.0

                                    motionAction: (value) => {
                                        let volume = Math.round(value * 100);
                                        Quickshell.execDetached(["amixer", "set", "Master", volume + "%"]);
                                    }
                                }

                                Text {
                                    text: Math.round((Audio.sink?.audio.volume ?? 0.0) * 100).toString()
                                    color: "white"
                                    font.pixelSize: 12
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.bottom: parent.bottom
                                    anchors.bottomMargin: 16
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
