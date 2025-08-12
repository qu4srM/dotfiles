import qs 
import qs.configs
import qs.widgets 
import qs.utils
import qs.services

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import Quickshell.Io
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

Rectangle {
    id: root
    required property var modelData
    property int index: PathView.view.model.indexOf(modelData)

    function apply() {
        const path = Paths.expandTilde(modelData);
        Wallpapers.actualCurrent = path;
        PathView.view.currentIndex = root.index
        Quickshell.execDetached([
            "bash", "-c",
            `echo "${Paths.strip(path)}" > ${Paths.strip(Wallpapers.currentNamePath)}`
        ])

    }

    scale: 0.5
    opacity: 0
    implicitWidth: image.width + 2
    implicitHeight: image.height + 2
    color: "transparent"
    radius: Appearance.rounding.normal
    border.width: 3

    Component.onCompleted: {
        scale  = Qt.binding(() => PathView.isCurrentItem ? 1 : PathView.onPath ? 0.8 : 0);
        opacity = Qt.binding(() => PathView.onPath ? 1 : 0);
        border.color = Qt.binding(() => PathView.isCurrentItem ? "white" : "transparent");
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.apply()
    }

    ClippingRectangle {
        id: image
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: "transparent"
        radius: Appearance.rounding.normal

        implicitWidth: 200
        implicitHeight: implicitWidth / 16 * 9

        Image {
            smooth: !root.PathView.view.moving
            anchors.fill: parent
            source: Paths.expandTilde(root.modelData)
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            sourceSize.width: width
            sourceSize.height: height
        }
    }

    Behavior on scale   { Anim {} }
    Behavior on opacity { Anim {} }
    Behavior on color   { Anim {} }

    component Anim: NumberAnimation {
        duration: 400
        easing.type: Easing.BezierSpline
        easing.bezierCurve: [0.2, 0, 0, 1, 1, 1]
    }
}
