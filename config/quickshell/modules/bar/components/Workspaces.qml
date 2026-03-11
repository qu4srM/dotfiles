import qs 
import qs.configs
import qs.services
import qs.widgets 
import qs.utils

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Rectangle {
    id: root
    implicitWidth: workspacesRow.implicitWidth + 8
    Layout.alignment: Qt.AlignVCenter
    color: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : "transparent"
    radius: Appearance.rounding.normal
    
    /* Icons Nerd
    property var iconsWorkspaces: [
        "󰈹", "", "", "", "", "·", "·", "󰊖", "", "󰆧"
    ]
    */
    property var iconsWorkspaces: [
        //"public", "code_blocks", "terminal", "folder", "edit_square", "·", "·", "gamepad", "settings", "vpn_key"
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
    Item {
        id: indicator
        anchors.fill: parent 
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: height
            height: root.implicitHeight - 6
            radius: Appearance.rounding.full 
            color: Config.options.bar.showBackground ? Appearance.colors.colSecondaryContainer : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.2)

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
            model: Config.options.bar.workspaces.shown
            Workspace {
                id: workspace
                required property var modelData
                required property int index
                workspaceId: 1 + index
                //iconMaterial: root.iconsWorkspaces[index]
                //fillMaterial: modelData.focused ? 1 : 0
                implicitWidth: implicitHeight - 6
                implicitHeight: root.implicitHeight
                iconSize: 20
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
