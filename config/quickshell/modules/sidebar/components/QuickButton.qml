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
    property string colorMain: "#111111"
    property string colorHover: "transparent"
    property real rounding: 10
    property string text: "none"
    property string colorToggle: "#1689be"


    color: colorMain
    Layout.fillWidth: true
    Layout.fillHeight: true
    radius: rounding

    Row {
        anchors.fill: parent
        anchors.leftMargin: 14
        spacing: 4

        StyledMaterialSymbol {
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
        onClicked: runCommand.startDetached()
    }
}
