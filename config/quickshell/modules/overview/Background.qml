import qs 
import qs.configs
import qs.utils
import qs.services

import QtQuick
import QtQuick.Shapes

ShapePath {
    id: root

    required property Item component
    readonly property real rounding: 20
    readonly property bool flatten: component.height < rounding * 2
    readonly property real roundingY: flatten ? component.height / 2 : rounding

    strokeWidth: -1
    fillColor: Config.options.bar.showBackground ? Appearance.colors.colSurface : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
    
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
        relativeX: root.rounding
        relativeY: root.roundingY
        radiusX: root.rounding
        radiusY: Math.min(root.rounding, root.component.height)
        direction: PathArc.Counterclockwise
    }

    PathLine {
        relativeX: root.component.width - root.rounding * 2
        relativeY: 0
    }

    PathArc {
        relativeX: root.rounding
        relativeY: -root.roundingY
        radiusX: root.rounding
        radiusY: Math.min(root.rounding, root.component.height)
        direction: PathArc.Counterclockwise
    }

    PathLine {
        relativeX: 0
        relativeY: -(root.component.height - root.roundingY * 2)
    }

    PathArc {
        relativeX: root.rounding
        relativeY: -root.roundingY
        radiusX: root.rounding
        radiusY: Math.min(root.rounding, root.component.height)
    }

    Behavior on fillColor {
        ColorAnimation {
            duration: Appearance.animationDurations.normal
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.animationCurves.standard
        }
    }
}