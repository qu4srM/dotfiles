import qs
import qs.configs 
import qs.widgets

import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
    id: root 
    component CornerWindow: StyledWindow {
        id: cornerWindow
        property bool fullscreen
        property var corner
        property var screen: QsWindow.window?.screen
        visible: !fullscreen
        name: "screenCorners"
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        
        color: "transparent"
        /*
        mask: Region {
            x: 0
            y: 0
            width: cornerWindow.width
            height: cornerWindow.height
            intersection: Intersection.Xor
        }*/

        anchors {
            top: roundCorner.isTopLeft || roundCorner.isTopRight
            left: roundCorner.isBottomLeft || roundCorner.isTopLeft
            right: roundCorner.isTopRight || roundCorner.isBottomRight
            bottom: roundCorner.isBottomLeft || roundCorner.isBottomRight
        }
        implicitWidth: roundCorner.implicitWidth
        implicitHeight: roundCorner.implicitHeight
        RoundCorner {
            id: roundCorner
            corner: cornerWindow.corner
            size: Appearance.rounding.normal
        }
    }
    Variants {
        model: Quickshell.screens
        Scope {
            id: monitorScope
            required property var modelData
            property HyprlandMonitor monitor: Hyprland.monitorFor(modelData)

            property list<HyprlandWorkspace> workspacesForMonitor: Hyprland.workspaces.values.filter(workspace => workspace.monitor && workspace.monitor.name == monitor.name)
            property var activeWorkspaceWithFullscreen: workspacesForMonitor.filter(workspace => ((workspace.toplevels.values.filter(window => window.wayland?.fullscreen)[0] != undefined) && workspace.active))[0]
            property bool fullscreen: activeWorkspaceWithFullscreen != undefined

            CornerWindow{
                screen: modelData
                corner: RoundCorner.CornerEnum.TopLeft
                fullscreen: monitorScope.fullscreen
            }
            CornerWindow{
                screen: modelData
                corner: RoundCorner.CornerEnum.TopRight
                fullscreen: monitorScope.fullscreen
            }
            CornerWindow{
                screen: modelData
                corner: RoundCorner.CornerEnum.BottomLeft
                fullscreen: monitorScope.fullscreen
            }
            CornerWindow{
                screen: modelData
                corner: RoundCorner.CornerEnum.BottomRight
                fullscreen: monitorScope.fullscreen
            }
        }
        
    }
}