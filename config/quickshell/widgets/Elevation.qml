import qs.services
import qs.configs
import QtQuick
import QtQuick.Effects

RectangularShadow {
    property int level
    property real dp: [0, 1, 3, 6, 8, 12][level]

    //color: Qt.alpha(Colours.palette.m3shadow, 0.7)
    color: Qt.alpha("#000000", 0.8)
    blur: (dp * 5) ** 0.8
    spread: -dp * 0.3 + (dp * 0.1) ** 2
    offset.y: dp / 2

    Behavior on dp {
        NumberAnimation {
            duration: Appearance.animationDurations.normal
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.animationCurves.standard
        }
    }
}