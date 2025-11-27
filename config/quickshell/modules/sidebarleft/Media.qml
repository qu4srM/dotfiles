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

        const hours = Math.floor(length / 3600);
        const mins = Math.floor((length % 3600) / 60);
        const secs = Math.floor(length % 60).toString().padStart(2, "0");

        if (hours > 0)
            return `${hours}:${mins.toString().padStart(2, "0")}:${secs}`;
        return `${mins}:${secs}`;
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
            implicitHeight: 300 
            clip: true
            color: Config.options.bar.showBackground ? Appearance.colors.colOnTertiary : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
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

                ColumnLayout {
                    id: column
                    anchors.centerIn: parent
                    width: parent.width - 20
                    spacing: 0

                    StyledText {
                        Layout.alignment: Qt.AlignHCenter
                        text: (Players.active?.trackTitle ?? qsTr("No media")) || qsTr("Unknown title")
                        color: Appearance.colors.colInverseSurface
                        font.family: Appearance.font.family.expressive
                        font.pixelSize: Appearance.font.pixelSize.larger
                        font.weight: Appearance.font.weight.bold
                    }

                    StyledText {
                        Layout.alignment: Qt.AlignHCenter
                        text: (Players.active?.trackAlbum ?? qsTr("No media")) || qsTr("Unknown album")
                        color: Appearance.colors.colText
                        font.family: Appearance.font.family.expressive
                        font.pixelSize: Appearance.font.pixelSize.large
                        font.weight: Appearance.font.weight.normal
                    }

                    StyledText {
                        Layout.alignment: Qt.AlignHCenter
                        text: (Players.active?.trackArtist ?? qsTr("No media")) || qsTr("Unknown artist")
                        color: Appearance.colors.colText
                        font.family: Appearance.font.family.expressive
                        font.pixelSize: Appearance.font.pixelSize.normal
                        font.weight: Appearance.font.weight.normal
                    }

                    
                    Item {
                        id: slider 
                        implicitWidth: parent.width
                        implicitHeight: 30
                        ProgressBarH {
                            value: root.playerProgress
                            colorMain: Appearance.colors.colPrimary 
                            colorBg: Appearance.colors.colSurfaceContainer
                            implicitWidth: parent.width
                            implicitHeight: parent.height
                            icon: "music_note"
                            rotateIcon: true
                            size: 18
                            motionAction: (value) => {
                                const active = Players.active;
                                if (active?.canSeek && active?.positionSupported)
                                    active.position = value * active.length;
                            }
                        }
                    }

                    Row {
                        Layout.alignment: Qt.AlignHCenter
                        height: 10
                        spacing: (parent.width / 2) + 130

                        StyledText {
                            text: root.lengthStr(Players.active?.position ?? -1)
                        }
                        StyledText {
                            text: root.lengthStr(Players.active?.length ?? -1)
                        }
                    }
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.fillWidth: true
                        height: 20
                        spacing: 10

                        ActionButtonIcon {
                            Layout.alignment: Qt.AlignVCenter
                            colBackground: Config.options.bar.showBackground ? Appearance.colors.colTertiaryContainer : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                            colBackgroundHover: "transparent"
                            implicitWidth: implicitHeight + 30
                            implicitHeight: iconSize + 30
                            buttonRadius: Appearance.rounding.full
                            iconMaterial: "skip_previous"
                            iconSize: 30
                            releaseAction: () => Players.active?.previous()
                        }

                        ActionButtonIcon {
                            Layout.alignment: Qt.AlignVCenter
                            colBackground: Config.options.bar.showBackground ? Appearance.colors.colTertiary : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                            colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colTertiaryActive : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                            implicitWidth: implicitHeight + 30
                            implicitHeight: iconSize + 30
                            buttonRadius: Players.active?.isPlaying ? Appearance.rounding.unsharpenmore : Appearance.rounding.full
                            iconMaterial: Players.active?.isPlaying ? "pause" : "play_arrow"
                            iconSize: 30
                            releaseAction: () => Players.active?.togglePlaying()
                        }

                        ActionButtonIcon {
                            Layout.alignment: Qt.AlignVCenter
                            colBackground: "transparent"
                            colBackgroundHover: "transparent"
                            implicitWidth: implicitHeight + 30
                            implicitHeight: iconSize + 30
                            buttonRadius: Appearance.rounding.full
                            iconMaterial: "skip_next"
                            iconSize: 30
                            releaseAction: () => Players.active?.next()
                        }
                    }
                }
                
            }
            
        }
    }
}
