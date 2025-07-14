import "root:/modules/common/"
import "root:/widgets/"

import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Widgets

ActionButton {
    id: root
    property string iconImage
    property string iconMaterial
    property bool materialIconFill: true
    property real iconSize
    implicitWidth: iconSize + 10

    contentItem: Item {
        implicitWidth: parent.width
        Loader {
            id: iconMaterialLoader 
            anchors.centerIn: parent 
            active: iconMaterial
            sourceComponent: StyledMaterialSymbol {
                text: root.iconMaterial
                size: root.iconSize
                color: Appearance.colors.colMSymbol
                fill: root.materialIconFill ? 1 : 0
            }
        }
        Loader {
            id: iconImageLoader
            anchors.centerIn: parent 
            active: !iconMaterial
            sourceComponent: StyledIconImage {
                icon: root.iconImage
                size: root.iconSize
            }
        }

    }
}