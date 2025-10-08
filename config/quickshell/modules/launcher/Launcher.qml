import qs 
import qs.configs
import qs.modules.launcher
import qs.widgets 
import qs.utils

import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

Item {
    id: root 
    required property var styledWindow
    implicitHeight: 0
    implicitWidth: content.implicitWidth

    states: State {
        name: "visible"
        when: GlobalStates.launcherOpen

        PropertyChanges {
            root.implicitHeight: content.implicitHeight
        }
    }
    transitions: [
        Transition {
            from: ""
            to: "visible"

            NumberAnimation {
                target: root
                property: "implicitHeight"
                duration: 500
                easing.type: Easing.BezierSpline
                easing.bezierCurve: [0.38, 1.21, 0.22, 1, 1, 1]
            }
        },
        Transition {
            from: "visible"
            to: ""

            NumberAnimation {
                target: root
                property: "implicitHeight"
                duration: 400
                easing.type: Easing.BezierSpline
                easing.bezierCurve: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
            }
        }
    ]
    Loader {
        id: content
        Component.onCompleted: active = GlobalStates.launcherOpen || root.visible
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top

        sourceComponent: Content {
            styledWindow: root.styledWindow
            launcher: root 
        }
    }
    GlobalShortcut {
        name: "launcherToggle"
        description: "Toggles launcher on press"
        onPressed: GlobalStates.launcherOpen = !GlobalStates.launcherOpen
    }
    GlobalShortcut {
        name: "launcherOpen"
        description: "Opens launcher on press"
        onPressed: GlobalStates.launcherOpen = true
    }
    GlobalShortcut {
        name: "launcherClose"
        description: "Closes launcher on press"
        onPressed: GlobalStates.launcherOpen = false
    }
}