import "root:/"
import "root:/services/"
import Quickshell
import QtQuick
import QtQuick.Shapes

ShapePath {
    id: root

    required property Item component
    readonly property real rounding: 20
    readonly property bool flatten: component.height < rounding * 2
    readonly property real roundingY: flatten ? component.height / 2 : rounding
    property real fullHeightRounding: component.height >= QsWindow.window?.height - 10 * 2 ? -rounding : rounding // where 10 is border tickness

    strokeWidth: -1
    fillColor: Colours.palette.m3surface

    PathLine {
        relativeX: -(root.component.width + root.rounding)
        relativeY: 0
    }
    PathArc {
        relativeX: root.rounding
        relativeY: root.roundingY
        radiusX: root.rounding
        radiusY: Math.min(root.rounding, root.component.height)
    }
    PathLine {
        relativeX: 0
        relativeY: root.component.height - root.roundingY * 2
    }
    PathArc {
        relativeX: root.fullHeightRounding
        relativeY: root.roundingY
        radiusX: Math.abs(root.fullHeightRounding)
        radiusY: Math.min(root.rounding, root.component.height)
        direction: root.fullHeightRounding < 0 ? PathArc.Clockwise : PathArc.Counterclockwise
    }
    PathLine {
        relativeX: root.component.height > 0 ? root.component.width - root.rounding - root.fullHeightRounding : root.component.width
        relativeY: 0
    }
    PathArc {
        relativeX: root.rounding
        relativeY: root.rounding
        radiusX: root.rounding
        radiusY: root.rounding
    }

    Behavior on fillColor {
        ColorAnimation {
            duration: Appearance.anim.durations.normal
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.anim.curves.standard
        }
    }

    Behavior on fullHeightRounding {
        NumberAnimation {
            duration: Appearance.anim.durations.normal
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.anim.curves.standard
        }
    }
}