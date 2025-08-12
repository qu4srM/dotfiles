import qs 
import qs.configs
import qs.modules.bar.components 
import qs.modules.drawers
import qs.widgets 
import qs.utils


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

PopupWindow {
    id: root
    required property ShellRoot screen
    required property StyledWindow window

    anchor.window: win
    anchor.rect.x: parentWindow.width / 2 - width / 2
    anchor.rect.y: parentWindow.height / 2
    implicitWidth: 20
    implicitHeight: 20
    color: "transparent"

    Rectangle {
        id: fadeWrapper
        anchors.fill: parent
        color: "transparent"
    }
}
