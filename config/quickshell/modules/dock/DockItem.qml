import qs
import qs.configs
import qs.modules.dock
import qs.widgets
import qs.utils

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Hyprland

Rectangle {
    id: root
    required property var modelData
    property var appListRoot
    property HyprlandMonitor monitor
    property PopupWindow toolTipElement 
    property var listView: parent.width
    implicitWidth: 30
    implicitHeight: 30
    color: "transparent"

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: () => {
            root.modelData.execute()
            appListRoot.lastHoveredItem = null
        }
        cursorShape: Qt.PointingHandCursor
        propagateComposedEvents: true
        onEntered: {
            appListRoot.lastHoveredItem = root
            toolTipElement.anchor.rect.x = (monitor.width / 2 ) - (root.listView / 2) + 10 + root.x - (toolTipElement.implicitWidth / 2)
        }
        onExited: {
            appListRoot.lastHoveredItem = null
        }

        IconImage {
            anchors.centerIn: parent
            width: parent.width
            height: width
            source: Quickshell.iconPath(root.modelData.icon)

            transform: Scale {
                origin.x: width / 2
                origin.y: height / 2
            }
        }
    }
}
