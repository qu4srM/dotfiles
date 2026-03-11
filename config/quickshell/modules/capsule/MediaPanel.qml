import qs
import qs.configs
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

Item {
    id: root 
    width: rowLayout.implicitWidth
    height: rowLayout.implicitHeight
    RowLayout {
        id: rowLayout
        anchors.horizontalCenter: parent.horizontalCenter
        Item {
            Layout.preferredWidth: height
            Layout.fillHeight: true
            ClippingRectangle {
                id: clip
                anchors.fill: parent
                anchors.margins: 0
                color: "transparent"
                radius: Appearance.rounding.small
                opacity: 0.7

                Image {
                    id: albumArt
                    anchors.fill: parent
                    source: Players.active?.trackArtUrl ?? ""
                    asynchronous: true
                    fillMode: Image.PreserveAspectCrop
                    sourceSize.width: width
                    sourceSize.height: height
                }
            }
        }
        ColumnLayout {
            Layout.fillHeight: true
            spacing: 2

            StyledText {
                text: (Players.active?.trackTitle ?? qsTr("No media")) || qsTr("Unknown title")
                color: Appearance.colors.colInverseSurface
                font.family: Appearance.font.family.expressive
                font.pixelSize: Appearance.font.pixelSize.normal + 1
                font.weight: Appearance.font.weight.bold
            }
            StyledText {
                text: (Players.active?.trackAlbum ?? qsTr("No media")) || qsTr("Unknown album")
                color: Appearance.colors.colText
                font.family: Appearance.font.family.expressive
                font.pixelSize: Appearance.font.pixelSize.normal
                font.weight: Appearance.font.weight.normal
            }

            StyledText {
                text: (Players.active?.trackArtist ?? qsTr("No media")) || qsTr("Unknown artist")
                color: Appearance.colors.colText
                font.family: Appearance.font.family.expressive
                font.pixelSize: Appearance.font.pixelSize.small
                font.weight: Appearance.font.weight.normal
            }
        
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                width: 50
                height: 20
                spacing: 10

                ActionButtonIcon {
                    Layout.alignment: Qt.AlignVCenter
                    colBackground: Config.options.bar.showBackground ? Appearance.colors.colTertiaryContainer : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                    colBackgroundHover: "transparent"
                    implicitWidth: implicitHeight 
                    implicitHeight: iconSize
                    buttonRadius: Appearance.rounding.full
                    iconMaterial: "skip_previous"
                    iconSize: 30
                    releaseAction: () => Players.active?.previous()
                }

                ActionButtonIcon {
                    Layout.alignment: Qt.AlignVCenter
                    colBackground: Config.options.bar.showBackground ? Appearance.colors.colTertiary : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                    colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colTertiaryActive : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                    implicitWidth: implicitHeight
                    implicitHeight: iconSize
                    buttonRadius: Players.active?.isPlaying ? Appearance.rounding.unsharpenmore : Appearance.rounding.full
                    iconMaterial: Players.active?.isPlaying ? "pause" : "play_arrow"
                    iconSize: 30
                    releaseAction: () => Players.active?.togglePlaying()
                }

                ActionButtonIcon {
                    Layout.alignment: Qt.AlignVCenter
                    colBackground: "transparent"
                    colBackgroundHover: "transparent"
                    implicitWidth: implicitHeight
                    implicitHeight: iconSize
                    buttonRadius: Appearance.rounding.full
                    iconMaterial: "skip_next"
                    iconSize: 30
                    releaseAction: () => Players.active?.next()
                }
            }
        }
    }
    Rectangle {// sound wave

        width: parent.width
        height: 0
        color: "green"
    }
}