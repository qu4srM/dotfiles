import qs.configs

import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

Item {
    id: root

    property real padding: 8

    property color color: Appearance.colors.colBackground

    // modo global
    property bool useUniformCorners: true
    property real cornerSize: Appearance.rounding.small

    // esquinas individuales
    property real topLeftRadius: Appearance.rounding.small
    property real topRightRadius: Appearance.rounding.small
    property real bottomRightRadius: Appearance.rounding.small
    property real bottomLeftRadius: Appearance.rounding.small

    property real borderWidth: 0
    property color borderColor: "#ffffff"

    implicitWidth: 300
    implicitHeight: 200

    clip: true

    function rTL() { return useUniformCorners ? cornerSize : topLeftRadius }
    function rTR() { return useUniformCorners ? cornerSize : topRightRadius }
    function rBR() { return useUniformCorners ? cornerSize : bottomRightRadius }
    function rBL() { return useUniformCorners ? cornerSize : bottomLeftRadius }

    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            fillColor: root.color
            strokeWidth: root.borderWidth
            strokeColor: root.borderColor
            joinStyle: ShapePath.MiterJoin

            startX: root.rTL()
            startY: 0

            // TOP
            PathLine {
                x: width - root.rTR()
                y: 0
            }

            // TOP RIGHT
            PathLine {
                x: width
                y: root.rTR()
            }

            // RIGHT
            PathLine {
                x: width
                y: height - root.rBR()
            }

            // BOTTOM RIGHT
            PathLine {
                x: width - root.rBR()
                y: height
            }

            // BOTTOM
            PathLine {
                x: root.rBL()
                y: height
            }

            // BOTTOM LEFT
            PathLine {
                x: 0
                y: height - root.rBL()
            }

            // LEFT
            PathLine {
                x: 0
                y: root.rTL()
            }

            // TOP LEFT
            PathLine {
                x: root.rTL()
                y: 0
            }
        }
    }
}