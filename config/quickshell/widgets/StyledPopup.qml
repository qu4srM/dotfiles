import "root:/"
import "root:/modules/common/"
import "root:/modules/sidebar/"
import "root:/modules/bar/components/"
import "root:/modules/drawers/"
import "root:/widgets/"
import "root:/utils/"

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
    property var onUnhovered  

    width: 100
    height: 100
    modal: false
    focus: true
    padding: 10
    background: Rectangle {
        color: "#2b2b2b"
        radius: 8
    }

    // Animación de apertura
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 200 }
        NumberAnimation { property: "scale"; from: 0.95; to: 1.0; duration: 200; easing.type: Easing.OutCubic }
    }

    // Animación de cierre
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 150 }
        NumberAnimation { property: "scale"; from: 1.0; to: 0.95; duration: 150; easing.type: Easing.InCubic }
    }

    contentItem: MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onExited: {
            root.close()
            if (root.onUnhovered) root.onUnhovered()
        }
    }
}

