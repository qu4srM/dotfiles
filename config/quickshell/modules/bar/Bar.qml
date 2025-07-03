import "root:/modules/bar/components/"
import "root:/modules/drawers/"
import "root:/widgets/"
import "root:/assets/icons/"

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

Item {
    id: panel
    required property ShellScreen screen
    required property real barHeight
    property string pathIcons: "root:/assets/icons/"
    property string colorMain: "transparent"
    property string pathScripts: "~/.config/quickshell/scripts/"
    
    implicitHeight: barHeight
    implicitWidth: parent.width

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Zona izquierda
        Item {
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            Layout.preferredWidth: 300

            Row {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8
                Separator { implicitWidth: 10 }
                ButtonIcon { iconSystem: "redhat-symbolic.svg"; command: "~/.config/rofi/launcher/launch.sh"; size: 18 }
                ButtonText { text: "Capturar"; command: panel.pathScripts + "screenshot.sh" }
                ButtonText { text: "Gotero"; command: "hyprpicker" }
                ButtonText { text: "Teclado"; command: "..." }
                ButtonText { text: "HackTheBox"; command: "..." }
            }
        }

        // Zona central
        Item {
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

            Row {
                anchors.centerIn: parent
                spacing: 8
                StyledButtonIcon { iconSource: "screenshot-light.svg"; command: panel.pathScripts + "screenshot.sh" ; background: "#000000"; size: 14 }
                Separator { implicitWidth: 167 }
                StyledButtonIcon { iconSource: "picker-symbolic.svg"; command: "hyprpicker"; background: "#000000"; size: 14 }
            }
        }

        // Zona derecha
        Item {
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            Layout.preferredWidth: 300

            Row {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8
                ButtonIcon { iconSystem: "firefox-symbolic.svg"; command: "code"; size: 16}
                Clock {}
            }
        }
    }
}
