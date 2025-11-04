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
    property string commandToggle: "whoami"
    property string icon: "hola"
    property string cmd: "hyprpicker"
    property string text: "none"

    property bool toggled: false


    color: Config.options.bar.showBackground 
        ? mouseArea.containsMouse ? Appearance.colors.colSurfaceContainerHighestHover : Appearance.colors.colSurfaceContainer
        : mouseArea.containsMouse ? Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6) : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)

    Layout.fillWidth: true
    implicitHeight: 50
    radius: Appearance.rounding.verysmall

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 6
        spacing: 4
        z: 10
        
        ActionButtonIcon {
            implicitHeight: parent.height - 10
            implicitWidth: parent.height - 10
            Layout.alignment: Qt.AlignVCenter
            colBackground: root.toggled || root.text != "none" ? Appearance.colors.colPrimary : Colors.setTransparency(Appearance.colors.colSurfaceContainer, 0.8)
            colBackgroundHover: Appearance.colors.colPrimaryActive
            iconMaterial: root.icon
            iconSize: 20
            buttonRadiusTopLeft: 8
            buttonRadiusTopRight: 8
            buttonRadiusBottomLeft: 8
            buttonRadiusBottomRight: 8
            onPressed: {
                Quickshell.execDetached(["bash", "-c", root.commandToggle])
            }

            StyledToolTip {
                content: root.toggled ? root.text + " On" : root.text + " Off"
            }
        }

        StyledText {
            text: root.text
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
