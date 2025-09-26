import qs
import qs.configs
import qs.widgets 
import qs.utils

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import Quickshell.Io
import Quickshell

Rectangle {
    id: root
    property string icon
    property string cmd
    property string text

    property bool toggled: false

    color: Config.options.bar.showBackground
        ? (mouseArea.containsMouse
            ? Appearance.colors.colPrimaryHover
            : (toggled
                ? Appearance.colors.colPrimary
                : Appearance.colors.colSurfaceContainer))
        : (mouseArea.containsMouse
            ? Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
            : (toggled
                ? Appearance.colors.colPrimary
                : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)))


    Layout.fillWidth: true
    Layout.fillHeight: true
    radius: toggled ? Appearance.rounding.normal : Appearance.rounding.verysmall

    Row {
        anchors.fill: parent
        anchors.leftMargin: 6 + 10
        spacing: anchors.leftMargin - 3

        StyledMaterialSymbol {
            id: symbol
            anchors.verticalCenter: parent.verticalCenter
            text: root.icon
            size: 20
            color: Appearance.colors.colText
            fill: root.toggled ? 1 : 0
            Behavior on fill {
                NumberAnimation {
                    duration: Appearance.animationDurations.normal
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Appearance.animationCurves.standard
                }
            }
        }

        StyledText {
            anchors.verticalCenter: parent.verticalCenter
            text: root.text
            elide: Text.ElideRight
        }
    }

    Process {
        id: runCommand
        command: ["bash", "-c", root.cmd]
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            toggled = !toggled
            runCommand.startDetached()
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: 300
            easing.type: Easing.InOutQuad
        }
    }
    Behavior on radius {
        NumberAnimation {
            duration: 300
            easing.type: Easing.InOutQuad
        }
    }
}
