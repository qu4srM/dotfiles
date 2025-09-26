import qs
import qs.configs
import qs.modules.sidebarleft 
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
import Quickshell.Services.Mpris

Rectangle {
    id: root 
    color: "transparent"

    property real playerProgress: {
        const active = Players.active;
        return active?.length ? active.position / active.length : 0;
    }

    function lengthStr(length: int): string {
        if (length < 0)
            return "-1:-1";
        return `${Math.floor(length / 60)}:${Math.floor(length % 60).toString().padStart(2, "0")}`;
    }

    ColumnLayout {
        id: columnLayout
        anchors.fill: parent 
        spacing: 10
        Rectangle {
            implicitWidth: parent.width 
            Layout.fillHeight: true
            color: Config.options.bar.showBackground ? "transparent" : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
            radius: Appearance.rounding.normal
        }
        Rectangle {
            implicitWidth: parent.width 
            implicitHeight: 180
            clip: true
            color: Config.options.bar.showBackground ? "transparent" : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
            radius: Appearance.rounding.normal
                
            Item {
                id: image 
                implicitWidth: parent.width
                implicitHeight: parent.width
                y: -parent.width / 2 - 50
                x: 0

                property bool playing: Players.active?.isPlaying ?? false

                ClippingRectangle {
                    id: clip
                    anchors.fill: parent
                    anchors.margins: 60
                    color: "transparent"
                    radius: Appearance.rounding.full
                    opacity: 0.7

                    Image {
                        id: albumArt
                        anchors.fill: parent
                        source: Players.active?.trackArtUrl ?? ""
                        asynchronous: true
                        fillMode: Image.PreserveAspectCrop
                        sourceSize.width: width
                        sourceSize.height: height

                        transformOrigin: Item.Center
                        rotation: 0

                        RotationAnimator on rotation {
                            id: spin
                            from: 0
                            to: 360
                            duration: 20000 
                            loops: Animation.Infinite
                            running: image.playing
                        }
                    }
                }
            }
            Item {
                id: control 
                anchors.fill: parent

                Column {
                    id: column
                    anchors.centerIn: parent
                    width: parent.width - 20
                    spacing: 10

                    StyledText {
                        text: Players.active
                        color: "white"
                    }

                    StyledText {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: (Players.active?.trackTitle ?? qsTr("No media")) || qsTr("Unknown title")
                        color: "white"
                    }

                    StyledText {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: (Players.active?.trackAlbum ?? qsTr("No media")) || qsTr("Unknown album")
                        color: "white"
                    }

                    StyledText {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: (Players.active?.trackArtist ?? qsTr("No media")) || qsTr("Unknown artist")
                        color: "white"
                    }

                    

                    ProgressBarH {
                        implicitWidth: parent.width - 12
                        value: root.playerProgress
                    }

                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        Layout.fillWidth: true
                        height: 10
                        spacing: parent.width - 55

                        StyledText {
                            text: root.lengthStr(Players.active?.position ?? -1)
                        }
                        StyledText {
                            text: root.lengthStr(Players.active?.length ?? -1)
                        }
                    }
                    RowLayout {
                        anchors.horizontalCenter: parent.horizontalCenter
                        Layout.fillWidth: true
                        height: 20
                        spacing: 10

                        ActionButtonIcon {
                            Layout.alignment: Qt.AlignVCenter
                            colBackground: "transparent"
                            colBackgroundHover: "transparent"
                            implicitHeight: iconSize + 10
                            iconMaterial: "skip_previous"
                            iconSize: 18
                            releaseAction: () => Players.active?.previous()
                        }

                        ActionButtonIcon {
                            Layout.alignment: Qt.AlignVCenter
                            colBackground: Config.options.bar.showBackground ? Appearance.colors.colsecondary : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                            colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colsecondary_hover : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                            implicitHeight: iconSize + 10
                            iconMaterial: Players.active?.isPlaying ? "pause" : "play_arrow"
                            iconSize: 20
                            releaseAction: () => Players.active?.togglePlaying()
                        }

                        ActionButtonIcon {
                            Layout.alignment: Qt.AlignVCenter
                            colBackground: "transparent"
                            colBackgroundHover: "transparent"
                            implicitHeight: iconSize + 10
                            iconMaterial: "skip_next"
                            iconSize: 18
                            releaseAction: () => Players.active?.next()
                        }
                    }
                }
                
            }
            
        }
    }
}
