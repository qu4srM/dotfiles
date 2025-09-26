import qs 
import qs.configs
import qs.modules.bar.components
import qs.services
import qs.widgets 
import qs.utils

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland

Rectangle {
    id: root
    width: workspacesRow.implicitWidth + 5
    anchors.verticalCenter: parent.verticalCenter
    color: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
    radius: Appearance.rounding.normal
    
    /* Icons Nerd
    property var iconsWorkspaces: [
        "󰈹", "", "", "", "", "·", "·", "󰊖", "", "󰆧"
    ]
    */
    property var iconsWorkspaces: [
        "public", "code_blocks", "terminal", "folder", "edit_square", "·", "·", "gamepad", "settings", "vpn_key"
    ]

    property int activeIndex: {
        let ws = HyprlandData.activeWorkspace
        if (!ws) return -1
        return ws.id - 1
    }
    WheelHandler {
        onWheel: (event) => {
            if (event.angleDelta.y < 0)
                Hyprland.dispatch(`workspace r+1`);
            else if (event.angleDelta.y > 0)
                Hyprland.dispatch(`workspace r-1`);
        }
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
    }

    MouseArea {
        id: mouseArea
        anchors.top: parent.top
        implicitWidth: parent.width
        implicitHeight: 6
        hoverEnabled: true
        onEntered: GlobalStates.overviewOpen = true
    }

    Item {
        id: indicator
        anchors.fill: parent
        Rectangle {
            id: indicatorCircle
            anchors.verticalCenter: parent.verticalCenter
            width: 20
            height: 20
            radius: Appearance.rounding.full 
            color: Appearance.colors.colSecondaryContainer

            x: {
                if (root.activeIndex < 0) return 0
                let item = repeater.itemAt(root.activeIndex)
                return item ? item.x + workspacesRow.x : 0
            }

            Behavior on x {
                animation: Appearance?.animation.elementMove.numberAnimation.createObject(this)
            }
        }
    }

    Row {
        id: workspacesRow
        anchors.centerIn: parent
        spacing: 0

        Repeater {
            id: repeater
            model: Hyprland.workspaces.values
            Workspace {
                required property var modelData
                required property int index
                workspaceId: 1 + index
                iconMaterial: root.iconsWorkspaces[index]
                fillMaterial: modelData.focused ? 1 : 0
                iconSize: 18
            }
        }

        Behavior on spacing {
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
