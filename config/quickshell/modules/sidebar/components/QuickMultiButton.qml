import "root:/widgets/"
import "root:/modules/common/"

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
    property string text: "none"

    property bool toggled: false

    color: mouseArea.containsMouse ? Appearance.colors.colsecondary_hover : Appearance.colors.colsecondary

    Layout.fillWidth: true
    Layout.fillHeight: true
    radius: Appearance.rounding.verysmall

    Row {
        anchors.fill: parent
        anchors.leftMargin: 6
        spacing: 4
        z: 10

        ActionButtonIcon {
            implicitHeight: parent.height - 10
            implicitWidth: parent.height - 10
            anchors.verticalCenter: parent.verticalCenter
            colBackground: Appearance.colors.colprimary
            colBackgroundHover: Appearance.colors.colprimary_hover
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
    Behavior on color {
        ColorAnimation {
            duration: 300
            easing.type: Easing.InOutQuad
        }
    }
}
