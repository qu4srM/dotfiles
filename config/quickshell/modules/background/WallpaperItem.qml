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
        const pathFile = Paths.strip(path);

        Config.options.background.wallpaperPath = pathFile;
        PathView.view.currentIndex = root.index;

        console.log("Change Background:", pathFile);

        Wallpapers.updateMaterialColor();
        /*
        Quickshell.execDetached([
            "bash", "-c",
            `~/.local/share/pipx/venvs/rembg/bin/python ~/.config/quickshell/scripts/create_depth_image_rembg.py ${pathFile} ~/.cache/quickshell/overlay/output.png`
        ])*/
    }

    scale: 0.5
    opacity: 0
    implicitWidth: 120
    implicitHeight: implicitWidth / 14 * 9
    color: "transparent"
    radius: Appearance.rounding.normal
    border.width: 2

    Component.onCompleted: {
        scale  = Qt.binding(() => PathView.isCurrentItem ? 1 : PathView.onPath ? 0.7 : 0);
        opacity = Qt.binding(() => PathView.onPath ? 1 : 0);
        border.color = Qt.binding(() => PathView.isCurrentItem ? Appearance.colors.colPrimary : "transparent");
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.apply()
    }

    ClippingRectangle {
        id: image
        anchors.fill: parent
        anchors.margins: 2
        color: "transparent"
        radius: Appearance.rounding.normal - 2

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
