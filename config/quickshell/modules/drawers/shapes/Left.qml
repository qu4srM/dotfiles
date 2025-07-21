import QtQuick
import Quickshell
import QtQuick.Shapes

ShapePath {
    id: root
    property real rounding: 10
    property real w: 100
    property real h: 100
    property string colorMain: "#ffffff"
    strokeWidth: -1
    fillColor: colorMain

    Behavior on w {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }
    Behavior on h {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }
    Behavior on rounding {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }

    // Arco superior izquierdo (inward)
    PathArc {
        relativeX: -root.rounding
        relativeY: -root.rounding
        radiusX: root.rounding
        radiusY: root.rounding
    }

    // Línea hacia abajo (borde izquierdo)
    PathLine {
        relativeX: 0
        relativeY: root.h + 40
    }

    // Arco inferior izquierdo (inward)
    PathArc {
        relativeX: root.rounding
        relativeY: -root.rounding
        radiusX: root.rounding
        radiusY: root.rounding
    }

    // Línea inferior (hacia la derecha)
    PathLine {
        relativeX: root.w
        relativeY: 0
    }

    // Arco inferior derecho (outward)
    PathArc {
        relativeX: root.rounding
        relativeY: -root.rounding
        radiusX: root.rounding
        radiusY: root.rounding
        direction: PathArc.Counterclockwise
    }

    // Línea hacia arriba (lado derecho)
    PathLine {
        relativeX: 0
        relativeY: -root.h
    }

    // Arco superior derecho (outward)
    PathArc {
        relativeX: -root.rounding
        relativeY: -root.rounding
        radiusX: root.rounding
        radiusY: root.rounding
        direction: PathArc.Counterclockwise
    }
}
