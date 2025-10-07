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

Item {
    id: root
    required property StyledWindow window
    property string wallpaperOverlayPath: Config.options.background.wallpaperOverlayPath

    property Item current: one

    anchors.fill: parent

    onWallpaperOverlayPathChanged: {
        if (!wallpaperOverlayPath)
            current = null;
        else if (current === one)
            two.update();
        else
            one.update();
    }

    Img {
        id: one
    }

    Img {
        id: two
    }

    component Img: Image {
        id: img

        property string path

        function update(): void {
            if (path === Config.options.background.wallpaperOverlayPath)
                root.current = this;
            else
                path = Config.options.background.wallpaperOverlayPath;
        }

        anchors.fill: parent
        asynchronous: true
        fillMode: Image.PreserveAspectCrop
        opacity: 0
        scale: 0.8
        source: path

        sourceSize: Qt.size(root.window.screen.width, root.window.screen.height)

        onStatusChanged: {
            if (status === Image.Ready)
                root.current = this;
        }

        states: State {
            name: "visible"
            when: root.current === img

            PropertyChanges {
                img.opacity: 1
                img.scale: 1
            }
        }

        transitions: Transition {
            NumberAnimation {
                target: img
                properties: "opacity,scale"
                duration: Appearance.animationDurations.normal
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.animationCurves.standard
            }
        }
    }
}
