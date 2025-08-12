pragma ComponentBehavior: Bound

import qs.widgets

import Quickshell
import QtQuick

Scope {
    id: root

    required property ShellScreen screen
    required property Item bar
    required property Item dock

    ExclusionZone {
        anchors.left: true
        //exclusiveZone: root.bar.implicitWidth
    }

    ExclusionZone {
        anchors.top: true
        exclusiveZone: root.bar.implicitHeight
    }

    ExclusionZone {
        anchors.right: true
    }

    ExclusionZone {
        anchors.bottom: true
        exclusiveZone: root.dock.implicitHeight
    }

    component ExclusionZone: StyledWindow {
        screen: root.screen

        name: "border-exclusion"
        exclusiveZone: 0
        mask: Region {}
    }
}