import "root:/widgets/"

import QtQuick
import Quickshell
import QtQuick.Effects
import Quickshell.Wayland

Item {
    id: root
    anchors.fill: parent

    property real marginTop
    property real margin: 0
    property string colorMain: "#975f5f"
    property real radius: 10
    Rectangle {
        id: rect
        anchors.fill: parent
        color: root.colorMain
        visible: false
    }
    Item {
        id: mask
        anchors.fill: parent
        layer.enabled: true
        visible: false

        Rectangle {
            anchors.fill: parent
            anchors.leftMargin: root.margin
            anchors.rightMargin: root.margin
            anchors.bottomMargin: root.margin

            radius: root.radius
        }
    }
    MultiEffect {
        anchors.fill: parent
        maskEnabled: true
        maskInverted: true
        maskSource: mask
        source: rect
        maskThresholdMin: 0.5
        maskSpreadAtMin: 1
    }
}

