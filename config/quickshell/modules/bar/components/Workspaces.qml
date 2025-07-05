import "root:/widgets/"
import "root:/utils/"
import "root:/services/"
import "root:/modules/bar/components/"

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland

Item {
    width: 190
    height: parent.height
    anchors.verticalCenter: parent.verticalCenter
    Layout.alignment: Qt.AlignVCenter

    RowLayout {
        anchors.centerIn: parent
        spacing: 0

        Repeater {
            model: Hyprland.workspaces.values

            Rectangle {
                width: 19
                height: 19
                radius: 10
                color: modelData.focused ? "#55677d" : "transparent"
                z: -1
            }
        }
    }
    
    // Íconos + interacciones
    RowLayout {
        anchors.centerIn: parent
        spacing: 0
        z: 1

        Repeater {
            model: 10

            Workspace {
                required property int index
                workspaceId: 1 + index
            }
        }
    }


    Connections {
        target: Hyprland.workspaces
        function onValuesChanged() {
            forceLayout()
        }
    }
}
