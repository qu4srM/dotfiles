import qs.configs
import qs.widgets

import QtQuick

Item {
    id: root
    anchors.fill: parent

    property real size: 30
    property color color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        //color: root.color !== "transparent"
        //    ? root.color
        //    : (Config.options.bar.showBackground
        //        ? Appearance.colors.colSurface
        //        : "transparent")
    }

    // TOP LEFT
    RectCorner {
        anchors.top: parent.top
        anchors.left: parent.left

        size: root.size
        color: root.color

        corner: RectCorner.CornerEnum.TopLeft
    }

    // TOP RIGHT
    RectCorner {
        anchors.top: parent.top
        anchors.right: parent.right

        size: root.size
        color: root.color

        corner: RectCorner.CornerEnum.TopRight
    }
}