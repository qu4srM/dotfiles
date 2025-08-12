import qs 
import qs.configs
import qs.modules.bar.components 
import qs.modules.drawers
import qs.widgets 
import qs.utils

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

Popup {
    id: root
    width: 100
    height: 100
    modal: false
    focus: true
    property var onUnhovered
    

    MouseArea {
        id: popupMouseAreaTop
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true

        onExited: {
            if (!popupMouseAreaTop.containsMouse) {
                onUnhovered()
            }
        }
    }

    enter: Transition {
        NumberAnimation { properties: "opacity"; from: 0; to: 1; duration: 300; easing.type: Easing.OutCubic }
    }
    exit: Transition {
        NumberAnimation { properties: "opacity"; from: 1; to: 0; duration: 300; easing.type: Easing.InCubic }
    }
}