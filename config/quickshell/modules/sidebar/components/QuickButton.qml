import "root:/modules/common/"
import "root:/widgets/"

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

    color: mouseArea.containsMouse ? Appearance.colors.colsecondary_hover : ( toggled ? Appearance.colors.colprimary : Appearance.colors.colsecondary)

    Layout.fillWidth: true
    Layout.fillHeight: true
    radius: toggled ? Appearance.rounding.normal : Appearance.rounding.verysmall

    Row {
        anchors.fill: parent
        anchors.leftMargin: 6 + 10
        spacing: 4

        StyledMaterialSymbol {
            id: symbol
            anchors.verticalCenter: parent.verticalCenter
            text: root.icon
            size: 20
            color: Appearance.colors.colMSymbol
            fill: 1
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.text
            color: "white"
            font.pixelSize: 12
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
