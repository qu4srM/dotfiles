import qs.configs
import qs.widgets

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
    property string iconNerd
    property bool materialIconFill: true
    property real iconSize
    implicitWidth: iconSize + 10

    contentItem: Item {
        implicitWidth: parent.width
        Loader {
            id: iconMaterialLoader 
            anchors.centerIn: parent 
            active: !!root.iconMaterial && root.iconMaterial.length > 0
            sourceComponent: StyledMaterialSymbol {
                text: root.iconMaterial
                size: root.iconSize
                color: Appearance.colors.colprimaryicon
                fill: root.materialIconFill ? 1 : 0
            }
        }
        Loader {
            id: iconNerdLoader 
            anchors.centerIn: parent 
            active: !iconMaterialLoader.active && !!root.iconNerd && root.iconNerd.length > 0
            sourceComponent: StyledText {
                text: root.iconNerd
                font.pixelSize: root.iconSize
                font.family: Appearance.font.family.iconNerd
                color: Appearance.colors.colprimarytext
            }
        }
        Loader {
            id: iconImageLoader
            anchors.centerIn: parent 
            active: !iconMaterialLoader.active && !iconNerdLoader.active && !!root.iconImage && root.iconImage.length > 0
            sourceComponent: StyledIconImage {
                icon: root.iconImage
                size: root.iconSize
            }
        }

    }
}