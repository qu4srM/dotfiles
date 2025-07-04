import "root:/modules/bar/components/"
import "root:/modules/drawers/"
import "root:/widgets/"

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Hyprland

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
                Separator { implicitWidth: 14 }
                Battery {}
                ButtonIcon { iconSystem: "redhat-symbolic.svg"; command: "~/.config/rofi/launcher/launch.sh"; size: 18 }
                Separator { implicitWidth: 5 }
                AppLabel {}
                ButtonText { text: "Atajos"; command: panel.pathScripts + "screenshot.sh" }
                ButtonText { text: "Configuración"; command: "..." }
                ButtonText { text: "HackTheBox"; command: "..." }
                ButtonText { text: "Hola" ; command: "..." }
            }
        }

        // Zona central
        Item {
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

            Row {
                anchors.centerIn: parent
                spacing: 8
                StyledButtonIcon { iconSource: "screenshot-light.svg"; command: panel.pathScripts + "screenshot.sh" ; background: "#000000"; size: 14 }
                Workspaces { }
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
                Battery {}
                Clock {}
            }
        }
    }
}
