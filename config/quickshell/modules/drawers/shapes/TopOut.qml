import "root:/services"
import "root:/config"
import "root:/modules/common/"
import QtQuick
import QtQuick.Shapes

ShapePath {
    id: root
    property real rounding: 10
    property real w: 100
    property real h: 100
    fillColor: Appearance.colors.colbackground
    strokeWidth: -1

    Behavior on w {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }
    Behavior on h {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }
    Behavior on rounding {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }

    PathArc {
        relativeX: -root.rounding
        relativeY: root.rounding
        radiusX: root.rounding
        radiusY: root.rounding
        direction: PathArc.Counterclockwise
    }

    PathLine {
        relativeX: 0
        relativeY: root.h
    }

    PathArc {
        relativeX: root.rounding
        relativeY: root.rounding
        radiusX: root.rounding
        radiusY: root.rounding
        direction: PathArc.Counterclockwise
    }

    PathLine {
        relativeX: -root.w
        relativeY: 0
    }

    PathArc {
        relativeX: root.rounding
        relativeY: -root.rounding
        radiusX: root.rounding
        radiusY: root.rounding
        direction: PathArc.Counterclockwise
    }

    PathLine {
        relativeX: 0
        relativeY: -root.h
    }

    PathArc {
        relativeX: -root.rounding
        relativeY: -root.rounding
        radiusX: root.rounding
        radiusY: root.rounding
        direction: PathArc.Counterclockwise
    }
}
