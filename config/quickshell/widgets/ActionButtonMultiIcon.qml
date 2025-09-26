import qs.configs
import qs.widgets

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

ActionButton {
    id: root
    property var iconList: []
    property real iconSize
    property real columns
    implicitWidth: grid.implicitWidth + 10

    contentItem: GridLayout {
        id: grid
        anchors.centerIn: parent
        columns: root.columns
        rowSpacing: 0
        columnSpacing: 5
        Repeater {
            model: root.iconList
            Loader {
                id: iconMaterialLoader 
                Layout.preferredWidth: root.iconSize
                Layout.preferredHeight: root.iconSize
                sourceComponent: StyledMaterialSymbol {
                    text: modelData
                    size: root.iconSize
                    color: Appearance.colors.colText
                    fill: 1
                }
            }
        }
    }
}