import "root:/modules/common/"
import "root:/widgets/"

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
    property bool materialIconFill: true
    property real iconSize
    property int columns: 3
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
                    color: Appearance.colors.colprimaryicon
                    fill: root.materialIconFill ? 1 : 0
                }
            }
        }
    }
}