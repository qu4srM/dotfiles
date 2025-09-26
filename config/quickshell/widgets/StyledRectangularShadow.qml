import QtQuick
import QtQuick.Effects
import qs.configs
import qs.utils

RectangularShadow {
    required property var target
    anchors.fill: target
    radius: target.radius
    blur: 0.9 * 4
    offset: Qt.vector2d(0.0, 1.0)
    spread: 1
    color: Colors.setTransparency(Appearance.colors.colshadow, 0.1)
    cached: true
}