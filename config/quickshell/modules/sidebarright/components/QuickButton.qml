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

    // 🔹 Tamaños base y expandido
    property real expandedWidth: parent.width / 2
    property bool isExpanded: false

    Layout.fillWidth: true
    implicitWidth: isExpanded ? expandedWidth : expandedWidth - 50
    implicitHeight: 50
    radius: toggled ? Appearance.rounding.normal : Appearance.rounding.verysmall

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

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 14
        spacing: 10

        StyledMaterialSymbol {
            id: symbol
            Layout.alignment: Qt.AlignVCenter
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
            text: root.text
            Layout.alignment: Qt.AlignVCenter
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

            // 🔹 Contrae los demás botones
            if (root.parent && root.parent.children) {
                for (let i = 0; i < root.parent.children.length; i++) {
                    let c = root.parent.children[i]
                    if (c !== root && c.isExpanded !== undefined)
                        c.isExpanded = false
                }
            }

            // 🔹 Expande este
            root.isExpanded = true
            revertTimer.restart()
        }
    }

    // 🔹 Temporizador para volver a fillWidth
    Timer {
        id: revertTimer
        interval: 100
        repeat: false
        onTriggered: root.isExpanded = false
    }

    // 🔹 Transición suave entre anchos
    Behavior on implicitWidth {
        NumberAnimation {
            duration: 250
            easing.type: Easing.OutCubic
        }
    }

    Behavior on color {
        ColorAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }

    Behavior on radius {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }
}
