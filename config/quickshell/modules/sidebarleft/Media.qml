import "root:/"
import "root:/modules/common/"
import "root:/modules/sidebar/"
import "root:/modules/bar/components/"
import "root:/modules/bar/popups/"
import "root:/modules/drawers/"
import "root:/services/"
import "root:/widgets/"
import "root:/utils/"

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

Item {
    id: root 
    anchors.fill: parent

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
        spacing: 0
        anchors.fill: parent 

        Item {
            id: right
            implicitWidth: 200
            implicitHeight: 200

            ClippingRectangle {
                anchors.fill: parent
                anchors.margins: 30
                color: "transparent"
                radius: Appearance.rounding.full

                Image {
                    anchors.fill: parent
                    source: Players.active?.trackArtUrl ?? ""
                    asynchronous: true
                    fillMode: Image.PreserveAspectCrop
                    sourceSize.width: width
                    sourceSize.height: height
                }
            }
        }
        Item {
            id: center
            implicitWidth: 200
            implicitHeight: 200

            Column {
                id: column
                anchors.fill: parent
                anchors.margins: 10
                spacing: 8

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

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    Layout.fillWidth: true
                    height: 30
                    spacing: 10

                    ActionButtonIcon {
                        anchors.verticalCenter: parent.verticalCenter
                        colBackground: "transparent"
                        colBackgroundHover: "transparent"
                        iconMaterial: "skip_previous"
                        iconSize: 18
                        releaseAction: () => Players.active?.previous()
                    }

                    ActionButtonIcon {
                        anchors.verticalCenter: parent.verticalCenter
                        colBackground: Appearance.colors.colsecondary
                        colBackgroundHover: Appearance.colors.colsecondary_hover
                        implicitHeight: iconSize + 10
                        iconMaterial: Players.active?.isPlaying ? "pause" : "play_arrow"
                        iconSize: 20
                        releaseAction: () => Players.active?.togglePlaying()
                    }

                    ActionButtonIcon {
                        anchors.verticalCenter: parent.verticalCenter
                        colBackground: "transparent"
                        colBackgroundHover: "transparent"
                        iconMaterial: "skip_next"
                        iconSize: 18
                        releaseAction: () => Players.active?.next()
                    }
                }

                ProgressBarH {
                    implicitWidth: parent.width - 12
                    value: root.playerProgress
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    Layout.fillWidth: true
                    height: 20
                    spacing: parent.width - 55

                    StyledText {
                        text: root.lengthStr(Players.active?.position ?? -1)
                    }
                    StyledText {
                        text: root.lengthStr(Players.active?.length ?? -1)
                    }
                }
            }
        }
        Rectangle {
            id: left
            implicitWidth: 200
            implicitHeight: 200
            color: "transparent"

            AnimatedImage {
                anchors.fill: parent
                playing: Players.active?.isPlaying ?? false
                speed: 0.7
                source: Qt.resolvedUrl("root:/assets/animated/jake.gif")
                asynchronous: true
                fillMode: AnimatedImage.PreserveAspectFit
            }
        }
    }
}
