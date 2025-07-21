import "root:/modules/common/"

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
    property real value: 0.5
    property real progress: root.implicitWidth * value
    property var motionAction
    property real radius: 2

    implicitWidth: 100
    implicitHeight: 20

    Behavior on progress {
        NumberAnimation {
            duration: 100
            easing.type: Easing.BezierSpline
        }
    }

    Row {
        anchors.fill: parent 
        spacing: 0
        
        Rectangle {
            id: start
            implicitWidth: progress
            implicitHeight: parent.height - 10
            anchors.verticalCenter: parent.verticalCenter
            color: Appearance.colors.colprimary
            topLeftRadius: root.radius
            bottomLeftRadius: root.radius
        }

        Item {
            implicitWidth: 12
            implicitHeight: parent.height
            Rectangle {
                implicitWidth: 4
                implicitHeight: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                radius: 10
                color: dragArea.containsMouse ? Appearance.colors.colprimary_hover : Appearance.colors.colprimary
            }
        }

        Rectangle {
            id: end
            implicitWidth: parent.width - progress
            implicitHeight: parent.height - 10
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            topRightRadius: root.radius
            bottomRightRadius: root.radius
        }
    }

    MouseArea {
        id: dragArea
        anchors.fill: parent
        hoverEnabled: true
        drag.target: null
        cursorShape: Qt.PointingHandCursor

        onPressed: (mouse) => updateValue(mouse.x)
        onPositionChanged: (mouse) => {
            if (mouse.buttons & Qt.LeftButton)
                updateValue(mouse.x)
        }

        function updateValue(xPos) {
            let clamped = Math.max(0, Math.min(1, xPos / root.width)); // ← no invertimos
            root.value = clamped;
            if (root.motionAction) root.motionAction(clamped);
        }
    }

}
