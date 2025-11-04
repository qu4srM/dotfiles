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
    property real radius
    property real topLeftRadius
    property real topRightRadius
    property real bottomLeftRadius
    property real bottomRightRadius
    property color color: "transparent"
    Rectangle {
        id: rect
        anchors.fill: parent
         color: root.color !== "transparent"
            ? root.color
            : (Config.options.bar.showBackground
                ? Appearance.colors.colSurface
                : "transparent")
        visible: false
    }
    Item {
        id: mask
        anchors.fill: parent
        layer.enabled: true
        visible: false

        Rectangle {
            anchors.fill: parent
            anchors.margins: root.margin

            topLeftRadius: root.radius > 0 ? root.radius : root.topLeftRadius
            topRightRadius: root.radius > 0 ? root.radius : root.topRightRadius
            bottomLeftRadius: root.radius > 0 ? root.radius : root.bottomLeftRadius
            bottomRightRadius: root.radius > 0 ? root.radius : root.bottomRightRadius
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

