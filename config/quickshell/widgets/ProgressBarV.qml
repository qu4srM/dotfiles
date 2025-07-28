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
    property real w: 20
    property real h: 100
    property real value: 0.5
    property real progress: root.implicitHeight * value
    property string colorMain: "white"
    property string colorBg: "black"
    property var motionAction
    property real radius: 2

    implicitWidth: w
    implicitHeight: h
    anchors.verticalCenter: parent.verticalCenter

    Behavior on progress {
        NumberAnimation {
            duration: 100
            easing.type: Easing.BezierSpline
        }
    }

    Column {
        anchors.fill: parent
        spacing: 0


        Rectangle {
            id: end
            implicitWidth: parent.width - 10
            implicitHeight: parent.height - progress
            anchors.horizontalCenter: parent.horizontalCenter
            color: root.colorBg
            topLeftRadius: root.radius
            topRightRadius: root.radius
        }

        Item {
            implicitWidth: parent.width
            implicitHeight: 12
            Rectangle {
                implicitWidth: parent.width
                implicitHeight: 4
                anchors.verticalCenter: parent.verticalCenter
                radius: 10
                color: root.colorMain
            }
        }

        Rectangle {
            id: start
            implicitWidth: parent.width - 10
            implicitHeight: progress
            anchors.horizontalCenter: parent.horizontalCenter
            color: root.colorMain
            bottomLeftRadius: root.radius
            bottomRightRadius: root.radius
        }
    }

    // 🎯 MouseArea para cambiar el valor arrastrando en vertical
    MouseArea {
        id: dragArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onPressed: (mouse) => updateValue(mouse.y)
        onPositionChanged: (mouse) => {
            if (mouse.buttons & Qt.LeftButton)
                updateValue(mouse.y)
        }
        function updateValue(yPos) {
            let clamped = Math.max(0, Math.min(1, 1 - (yPos / root.height)));
            root.value = clamped;
            if (root.motionAction) root.motionAction(clamped);
        }
    }
}
