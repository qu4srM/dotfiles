import qs
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
import Quickshell.Services.Mpris

Item {
    id: root 
    property bool show: false
    implicitWidth: rowLayout.implicitWidth + 40
    implicitHeight: rowLayout.implicitHeight

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
    ClippingRectangle {
        id: clip
        anchors.fill: parent
        color: "transparent"
        radius: Appearance.rounding.small
        opacity: 1

        Image {
            id: albumArt
            anchors.fill: parent
            source: Players.active?.trackArtUrl ?? ""
            asynchronous: true
            smooth: true
            mipmap: true
            fillMode: Image.PreserveAspectCrop
        }
        /*
        Loader {
            active: root.show
            anchors.fill: parent 
            anchors.topMargin: 80
            sourceComponent: CavaWave {
                anchors.fill: parent 
            }
        }*/
    }
    RectangleRing {
        id: box
        anchors.fill: parent 
        anchors.margins: 4
        anchors.topMargin: 60
        radius: Appearance.rounding.small
        color: Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
        source: ShaderEffectSource {
            anchors.fill: parent 
            sourceRect: Qt.rect(0,0,200,400)
            hideSource: true
            live: true
            visible: true
        }
    }

    
    RowLayout {
        id: rowLayout
        anchors.centerIn: box
        ColumnLayout {
            Layout.fillHeight: true
            spacing: 0

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: (Players.active?.trackTitle ?? qsTr("No media")) || qsTr("Unknown title")
                color: Appearance.colors.colInverseSurface
                font.family: Appearance.font.family.expressive
                font.pixelSize: Appearance.font.pixelSize.normal + 1
                font.weight: Appearance.font.weight.bold
            }
            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: (Players.active?.trackArtist ?? qsTr("No media")) || qsTr("Unknown artist")
                color: Appearance.colors.colInverseSurface
                font.family: Appearance.font.family.expressive
                font.pixelSize: Appearance.font.pixelSize.small
                font.weight: Appearance.font.weight.normal
            }
            ProgressBarH {
                Layout.fillWidth: true
                Layout.preferredWidth: 140
                value: root.playerProgress
                colorMain: "white" 
                colorBg: Colors.setTransparency("white", 0.7)
                implicitHeight: 24
                motionAction: (value) => {
                    const active = Players.active;
                    if (active?.canSeek && active?.positionSupported)
                        active.position = value * active.length;
                }
            }
        
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
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
                    changeColor: true 
                    iconColor: "white"
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
                    changeColor: true 
                    iconColor: "white"
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
                    changeColor: true 
                    iconColor: "white"
                    releaseAction: () => Players.active?.next()
                }
            }
        }
    }
    /*Rectangle {// sound wave

        width: parent.width
        height: 0
        color: "green"
    }*/
}