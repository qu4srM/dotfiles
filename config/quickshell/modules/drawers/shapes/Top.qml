import "root:/services"
import "root:/config"
import QtQuick
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

    PathArc {
        relativeX: -root.rounding
        relativeY: root.rounding
        radiusX: root.rounding
        radiusY: root.rounding
        direction: PathArc.Counterclockwise
    }

    PathLine {
        relativeX: 0
        relativeY: root.h // 100 - 20*2
    }

    PathArc {
        relativeX: -root.rounding
        relativeY: root.rounding
        radiusX: root.rounding
        radiusY: root.rounding
    }

    PathLine {
        relativeX: -root.w  // 300 - 20*2
        relativeY: 0
    }

    PathArc {
        relativeX: -root.rounding
        relativeY: -root.rounding
        radiusX: root.rounding
        radiusY: root.rounding
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
