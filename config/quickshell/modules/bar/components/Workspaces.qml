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

Rectangle {
    width: Appearance.sizes.workspacesWidth
    height: parent.height - Appearance.margins.itemBarMargin
    anchors.verticalCenter: parent.verticalCenter
    color: Appearance.colors.colsecondary
    radius: Appearance.rounding.verysmall


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
        spacing: GlobalStates.notchOpen ? Appearance.sizes.notchWidthExtended / 22 : 0

        Repeater {
            model: Hyprland.workspaces.values

            Rectangle {
                width: 19
                height: 19
                radius: Appearance.rounding.full
                color: modelData.focused ? Appearance.colors.colprimary : "transparent"
            }
        }
        Behavior on spacing  {
            animation: Appearance.animation.elementExpand.numberAnimation.createObject(this)
        }
    }
    
    // Íconos + interacciones
    RowLayout {
        anchors.centerIn: parent
        spacing: GlobalStates.notchOpen ? Appearance.sizes.notchWidthExtended / 22 : 0
        Repeater {
            model: 10

            Workspace {
                required property int index
                workspaceId: 1 + index
            }
        }
        Behavior on spacing  {
            animation: Appearance.animation.elementExpand.numberAnimation.createObject(this)
        }
    }
    
    
    Behavior on width {
        animation: Appearance.animation.elementExpand.numberAnimation.createObject(this)
    }
    Behavior on height {
        animation: Appearance.animation.elementExpand.numberAnimation.createObject(this)
    }

}
