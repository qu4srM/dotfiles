import qs.configs

import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

MouseArea {
    id: root
    required property Item component
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: pressed ? Qt.PointingHandCursor : Qt.ArrowCursor

    property string axis: "y"

    onPressed: (mouse) => updateValue(mouse)
    onPositionChanged: (mouse) => {
        if (mouse.buttons & Qt.LeftButton)
            updateValue(mouse)
    }

    function updateValue(mouse) {
        let ratio
        if (axis === "y") {
            ratio = 1 - (mouse.y / component.height)
        } else if (axis === "x") {
            ratio = mouse.x / component.width
        } else {
            console.warn("❗ DragArea.axis debe ser 'x' o 'y'")
            return
        }

        // Limitar el valor entre 0 y 1
        let clamped = Math.max(0, Math.min(1, ratio))
        component.value = clamped

        // Si hay una acción asociada, la ejecuta
        if (component.motionAction) component.motionAction(clamped)
    }
}