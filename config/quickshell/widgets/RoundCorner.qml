import qs
import qs.configs

import QtQuick
import QtQuick.Shapes

Item {
    id: root

    enum CornerEnum { TopLeft, TopRight, BottomLeft, BottomRight }
    property int corner: RoundCorner.CornerEnum.TopLeft

    property alias leftVisualMargin: shape.anchors.leftMargin
    property alias topVisualMargin: shape.anchors.topMargin
    property alias rightVisualMargin: shape.anchors.rightMargin
    property alias bottomVisualMargin: shape.anchors.bottomMargin

    property int size: 25
    property color color: "#000000"

    implicitWidth: size
    implicitHeight: size

    readonly property bool isTopLeft:     corner === RoundCorner.CornerEnum.TopLeft
    readonly property bool isTopRight:    corner === RoundCorner.CornerEnum.TopRight
    readonly property bool isBottomLeft:  corner === RoundCorner.CornerEnum.BottomLeft
    readonly property bool isBottomRight: corner === RoundCorner.CornerEnum.BottomRight

    readonly property bool isTop:    isTopLeft || isTopRight
    readonly property bool isBottom: isBottomLeft || isBottomRight
    readonly property bool isLeft:   isTopLeft || isBottomLeft
    readonly property bool isRight:  isTopRight || isBottomRight

    readonly property real startX: isLeft  ? 0 : size
    readonly property real startY: isTop   ? 0 : size

    readonly property real startAngle: {
        switch (corner) {
        case RoundCorner.CornerEnum.TopLeft:     return 180;
        case RoundCorner.CornerEnum.TopRight:    return -90;
        case RoundCorner.CornerEnum.BottomRight: return 0;
        case RoundCorner.CornerEnum.BottomLeft:  return 90;
        }
    }

    Shape {
        id: shape
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer
        layer.enabled: true
        layer.smooth: true

        ShapePath {
            strokeWidth: 0
            fillColor: root.color
            startX: root.startX
            startY: root.startY

            PathAngleArc {
                moveToStart: false
                centerX: root.width  - root.startX
                centerY: root.height - root.startY
                radiusX: root.width
                radiusY: root.height
                startAngle: root.startAngle
                sweepAngle: 90
            }

            PathLine {
                x: root.startX
                y: root.startY
            }
        }
    }
}
