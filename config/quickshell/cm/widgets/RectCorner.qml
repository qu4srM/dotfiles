import QtQuick
import QtQuick.Shapes

Item {
    id: root

    enum CornerEnum {
        TopLeft,
        TopRight,
        BottomLeft,
        BottomRight
    }

    property int corner: RectCorner.CornerEnum.TopLeft

    property int size: 40
    property color color: "black"

    implicitWidth: size
    implicitHeight: size

    readonly property bool isTopLeft:     corner === RectCorner.CornerEnum.TopLeft
    readonly property bool isTopRight:    corner === RectCorner.CornerEnum.TopRight
    readonly property bool isBottomLeft:  corner === RectCorner.CornerEnum.BottomLeft
    readonly property bool isBottomRight: corner === RectCorner.CornerEnum.BottomRight

    readonly property bool isTop:    isTopLeft || isTopRight
    readonly property bool isBottom: isBottomLeft || isBottomRight
    readonly property bool isLeft:   isTopLeft || isBottomLeft
    readonly property bool isRight:  isTopRight || isBottomRight

    readonly property real startX: isLeft  ? 0 : size
    readonly property real startY: isTop   ? 0 : size

    readonly property real startAngle: {
        switch (corner) {
        case RectCorner.CornerEnum.TopLeft:     return 180;
        case RectCorner.CornerEnum.TopRight:    return -90;
        case RectCorner.CornerEnum.BottomRight: return 0;
        case RectCorner.CornerEnum.BottomLeft:  return 90;
        }
    }

    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeWidth: 0
            fillColor: root.color

            startX: isTopLeft ? 0 :
                    isTopRight ? width :
                    isBottomLeft ? 0 :
                    width

            startY: isTopLeft ? 0 :
                    isTopRight ? 0 :
                    isBottomLeft ? height :
                    height

            PathLine {
                x: isTopLeft ? width :
                isTopRight ? width :
                isBottomLeft ? 0 :
                width

                y: isTopLeft ? 0 :
                isTopRight ? height :
                isBottomLeft ? 0 :
                0
            }

            PathLine {
                x: isTopLeft ? 0 :
                isTopRight ? 0 :
                isBottomLeft ? width :
                0

                y: isTopLeft ? height :
                isTopRight ? 0 :
                isBottomLeft ? height :
                height
            }

            PathLine {
                x: startX
                y: startY
            }
        }
    }
}