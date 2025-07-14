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
    property string commandToggle: "whoami"
    property string icon: "hola"
    property string cmd: "hyprpicker"
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
        anchors.leftMargin: 6
        spacing: 4
        z: 10

        ActionButtonIcon {
            implicitHeight: parent.height -10
            implicitWidth: parent.width / 4
            anchors.verticalCenter: parent.verticalCenter
            colBackground: "#1689be"
            colBackgroundHover: "transparent"
            iconMaterial: root.icon
            iconSize: 20
            buttonRadiusTopLeft: 8
            buttonRadiusTopRight: 8
            buttonRadiusBottomLeft: 8
            buttonRadiusBottomRight: 8
            onPressed: {
                Quickshell.execDetached(["bash", "-c", root.commandToggle])
            }
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
        onClicked: runCommand.startDetached()
    }
}
