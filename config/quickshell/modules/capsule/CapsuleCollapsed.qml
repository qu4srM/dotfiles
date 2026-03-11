import qs
import qs.configs
import qs.modules.capsule
import qs.utils
import qs.widgets 

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import Quickshell.Io
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland




import qs
import qs.configs
import qs.widgets
import qs.utils
import qs.services

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: root

    property bool hasMedia:
        Players.active
        && Players.active.trackTitle

    property bool isPlaying:
        Players.active?.isPlaying ?? false

    visible: hasMedia
    opacity: hasMedia ? 1 : 0


    Behavior on opacity {
        NumberAnimation { duration: 120 }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 10

        // 🎵 Cover / Icon
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            ClippingRectangle {
                id: clip
                property bool playing: Players.active?.isPlaying ?? false
                implicitHeight: parent.height
                implicitWidth: parent.height
                anchors.margins: 0
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
                        running: clip.playing
                    }
                }
            }
            Rectangle {
                anchors.right: parent.right
                anchors.rightMargin: width / 2
                anchors.verticalCenter: parent.verticalCenter
                width: height
                height: parent.height - 10
                color: "green"
                radius: 999
            }
        }

    }
}
