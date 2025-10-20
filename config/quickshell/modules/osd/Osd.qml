import qs 
import qs.configs 
import qs.widgets 
import qs.utils
import qs.services

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland


Scope {
    id: root

    property string currentIndicator: "volume"
    property var indicators: [
        {
            id: "volume",
            sourceUrl: "./VolumeIndicator.qml"
        },
        {
            id: "brightness",
            sourceUrl: "./BrightnessIndicator.qml"
        },
    ]

    function hide () {
        GlobalStates.osdVolumeOpen = false;
    }


    function triggerOsd() {
        GlobalStates.osdVolumeOpen = true;
        osdTimeout.restart();
    }

    Timer {
        id: osdTimeout
        interval: 3000
        repeat: false
        onTriggered: root.hide()
    }
    Connections {
        target: Brightness
        function onBrightnessChanged() {
            root.currentIndicator = "brightness";
            root.triggerOsd();
        }
    }

    Connections {
        target: Audio.sink?.audio ?? null
        function onVolumeChanged() {
            if (!Audio.ready)
                return;
            root.currentIndicator = "volume";
            root.triggerOsd();
        }
        function onMutedChanged() {
            if (!Audio.ready)
                return;
            root.currentIndicator = "volume";
            root.triggerOsd();
        }
    }
    Connections {
        target: Audio
        function onSinkProtectionTriggered(reason) {
            root.currentIndicator = "volume";
            root.triggerOsd();
        }
    }
    Loader {
        id: osdLoader
        active: GlobalStates.osdVolumeOpen
        sourceComponent: StyledWindow {
            id: volume
            visible: osdLoader.active
            name: "osd"
            color: "transparent"
            exclusiveZone: 0

            anchors {
                left: true
            }

            implicitWidth: 70
            implicitHeight: 300

            property string pathIcons: "root:/assets/icons/"
            property string colorMain: "transparent"
            property string pathScripts: "~/.config/quickshell/scripts/"
            /*

            HyprlandFocusGrab {
                id: grab
                windows: [ volume ]
                active: GlobalStates.osdVolumeOpen
                onCleared: () => {
                    if (!active) volume.hide()
                }
            }*/
            

            /*
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
                StyledText {
                    text: "Hola"
                }
            }*/
            Rectangle {
                anchors.fill: parent
                anchors.margins: 10
                color: Appearance.colors.colBackground
                radius: Appearance.rounding.full
                Loader {
                    id: osdIndicatorLoader
                    anchors.fill: parent
                    source: root.indicators.find(i => i.id === root.currentIndicator)?.sourceUrl
                }
            }
        }
    }
}

