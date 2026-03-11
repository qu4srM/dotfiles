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
    property color color: '#fff'

    property var source: null
    property real smallerVal: Math.min(width, height)
    property var cornerRadii: Qt.vector4d(Math.min(smallerVal/2, radius), Math.min(smallerVal/2, radius), Math.min(smallerVal/2, radius), Math.min(smallerVal/2, radius))
    property var iResolution: Qt.point(width+2, height+2)
    property var boxSize: Qt.point(width/2, height/2)
    property var glowColor: Qt.rgba(1,1,1,1)
    property real glowIntensity: 1.0
    property real glowEdgeBand: 1.0
    property real glowAngWidth: 1.7
    property real glowTheta1: 0.0
    property real glowTheta2: Math.PI
    property var baseColor: Qt.rgba(0,0,0,0)
    property var lightDir: Qt.vector2d(1, 1)

    Rectangle {
        anchors.fill: parent
        radius: box.radius
        color: box.color
    }

    ShaderEffect {
        anchors.fill: parent
        property var iResolution: box.iResolution
        property var boxSize: box.boxSize
        property var cornerRadii: box.cornerRadii
        property var glowColor: box.glowColor
        property real glowIntensity: box.glowIntensity
        property real glowEdgeBand: box.glowEdgeBand
        property real glowAngWidth: box.glowAngWidth
        property real glowTheta1: box.glowTheta1
        property real glowTheta2: box.glowTheta2
        property var baseColor: box.baseColor
        property var source: box.source
        property var lightDir: box.lightDir

        vertexShader: Qt.resolvedUrl(
            Quickshell.shellDir + "/utils/glow.vert.qsb"
        )
        fragmentShader: Qt.resolvedUrl(
            Quickshell.shellDir + "/utils/glow.frag.qsb"
        )
    }
}