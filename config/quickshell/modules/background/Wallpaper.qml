import qs 
import qs.configs
import qs.widgets 
import qs.services

import QtQuick

Item {
    id: root
    required property StyledWindow window
    property string wallpaperPath: Config.options.background.wallpaperPath

    property Item current: one

    anchors.fill: parent

    onWallpaperPathChanged: {
        if (!wallpaperPath)
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
            if (path === Config.options.background.wallpaperPath)
                root.current = this;
            else
                path = Config.options.background.wallpaperPath;
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
