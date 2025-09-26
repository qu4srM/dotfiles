import qs 
import qs.configs
import qs.modules.bar.components
import qs.services
import qs.widgets 
import qs.utils

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets


Item {
    id: root
    width: iconSize + 2
    height: iconSize + 2
    required property int workspaceId
    property bool fillMaterial
    property string iconNerd
    property string iconMaterial
    property real iconSize

    property bool workspaceActive: workspaceId === (HyprlandData.activeWorkspace ? HyprlandData.activeWorkspace.id : -1)

    anchors.verticalCenter: parent.verticalCenter
    Layout.alignment: Qt.AlignVCenter

    property bool hasWindows: HyprlandData.biggestWindowForWorkspace(root.workspaceId) !== null
    
    Item {
        anchors.centerIn: parent

        Loader {
            id: iconMaterialLoader 
            anchors.centerIn: parent 
            active: !root.hasWindows && !!root.iconMaterial && root.iconMaterial.length > 0
            sourceComponent: StyledMaterialSymbol {
                anchors.centerIn: parent 
                text: root.iconMaterial
                size: root.iconSize
                color: {
                    if (root.hasWindows) {
                        return "transparent"
                    }
                    if (Config.options.bar.showBackground) {
                        return mouseArea.containsMouse ? Appearance.colors.colPrimaryHover : Appearance.colors.colText
                    } else {
                        return mouseArea.containsMouse ? Appearance.colors.colprimary_hover : Appearance.colors.colprimarytext
                    }
                }
                font.variableAxes: { 
                    "FILL": root.workspaceActive && !root.hasWindows ? 1 : 0
                }
            }
        }

        Loader {
            id: iconNerdLoader 
            anchors.centerIn: parent 
            active: !root.hasWindows && !iconMaterialLoader.active && !!root.iconNerd && root.iconNerd.length > 0
            sourceComponent: StyledText {
                anchors.centerIn: parent 
                text: root.iconNerd
                font.pixelSize: root.iconSize
                font.family: Appearance.font.family.iconNerd 
                color: {
                    if (root.hasWindows) {
                        return "transparent"
                    }
                    if (Config.options.bar.showBackground) {
                        return mouseArea.containsMouse ? Appearance.colors.colPrimaryHover : Appearance.colors.colText
                    } else {
                        return mouseArea.containsMouse ? Appearance.colors.colprimary_hover : Appearance.colors.colprimarytext
                    }
                }
            }
        }
    }

    Loader {
        anchors.centerIn: parent 
        active: root.hasWindows
        sourceComponent: IconImage {
            id: icon
            anchors.centerIn: parent
            property var biggestWindow: HyprlandData.biggestWindowForWorkspace(root.workspaceId)
            implicitSize: 13
            source: Quickshell.iconPath(Icons.getIcon(biggestWindow?.class), "image-missing")
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            Hyprland.dispatch("workspace " + root.workspaceId)
        }
    }
}
