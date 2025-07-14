import "root:/"
import "root:/modules/common/"
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
    width: GlobalStates.notchOpen ? Appearance.sizes.notchWidthExtended + 8 : Appearance.sizes.notchWidth + 8
    height: parent.height
    anchors.verticalCenter: parent.verticalCenter
    Layout.alignment: Qt.AlignVCenter


    MouseArea {
        id: mouseArea
        implicitWidth: parent.width
        implicitHeight: 6
        hoverEnabled: true
        onEntered: {
            GlobalStates.notchOpen = true
        }
        onExited: {
            GlobalStates.notchOpen = false
        }
    }

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
            }
        }
    }
    
    // Íconos + interacciones
    RowLayout {
        anchors.centerIn: parent
        spacing: 0
        Repeater {
            model: 10

            Workspace {
                required property int index
                workspaceId: 1 + index
            }
        }
    }
    
    
    Behavior on width {
        animation: Appearance.animation.elementExpand.numberAnimation.createObject(this)
    }
    Behavior on height {
        animation: Appearance.animation.elementExpand.numberAnimation.createObject(this)
    }

}
