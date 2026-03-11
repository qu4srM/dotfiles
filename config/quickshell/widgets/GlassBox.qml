import qs
import qs.configs
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
Item {
    id: box

    property real radius: 20
    property color color: '#17ffffff'

    property var source: null

    property var blurSource: source

    property var iResolution: Qt.point(width, height)
    property var boxSize: Qt.point(width, height)

    property var cornerRadii: Qt.vector4d(
        radius,
        radius,
        radius,
        radius
    )

    property color glowColor: Qt.rgba(1, 1, 1, 1)
    property real glowIntensity: 1.0
    property real glowEdgeBand: 1.0
    property real glowAngWidth: 1.7
    property real glowTheta1: 0.0
    property real glowTheta2: Math.PI

    property color baseColor: color
    property var lightDir: Qt.vector2d(1.0, 1.0)

    property real glassBevel: 20.0
    property real glassMaxRefractionDistance: 20.0
    property real glassHairlineWidthPixels: 5.0
    property real glassHairlineReflectionDistance: 20.0

    Rectangle {
        anchors.fill: parent
        radius: box.radius
        color: box.color
    }

    ShaderEffect {
        anchors.fill: parent

        property var source: box.source
        property var blurSource: box.blurSource

        property var iResolution: box.iResolution
        property var boxSize: box.boxSize
        property var cornerRadii: box.cornerRadii

        property color glowColor: box.glowColor
        property real glowIntensity: box.glowIntensity
        property real glowEdgeBand: box.glowEdgeBand
        property real glowAngWidth: box.glowAngWidth
        property real glowTheta1: box.glowTheta1
        property real glowTheta2: box.glowTheta2

        property color baseColor: box.baseColor
        property var lightDir: box.lightDir

        property real glassBevel: box.glassBevel
        property real glassMaxRefractionDistance: box.glassMaxRefractionDistance
        property real glassHairlineWidthPixels: box.glassHairlineWidthPixels
        property real glassHairlineReflectionDistance: box.glassHairlineReflectionDistance

        vertexShader: Qt.resolvedUrl(
            Quickshell.shellDir + "/utils/glass.vert.qsb"
        )
        fragmentShader: Qt.resolvedUrl(
            Quickshell.shellDir + "/utils/glass.frag.qsb"
        )
    }
}