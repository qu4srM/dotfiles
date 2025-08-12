import qs
import qs.configs
import qs.widgets

import QtQuick
import Quickshell
import QtQuick.Effects
import Quickshell.Wayland

Item {
    id: root
    anchors.fill: parent

    property real margin: 0
    Rectangle {
        id: rect
        anchors.fill: parent
        color: Appearance.colors.colbackground
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

            radius: Appearance.rounding.normal
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

