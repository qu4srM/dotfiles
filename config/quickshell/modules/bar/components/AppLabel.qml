import qs 
import qs.configs
import qs.widgets 
import qs.services

import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

ContainerRectangle {
    id: root 
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(root.QsWindow.window?.screen)
    readonly property Toplevel activeWindow: ToplevelManager.activeToplevel

    property bool focusingThisMonitor: HyprlandData.activeWorkspace?.monitor == monitor?.name
    property var biggestWindow: HyprlandData.biggestWindowForWorkspace(HyprlandData.monitors[root.monitor?.id]?.activeWorkspace.id)

    implicitHeight: parent.height - Appearance.margins.panelMargin * 2
    implicitWidth: textItem.implicitWidth
    StyledText {
        id: textItem
        anchors.verticalCenter: parent.verticalCenter
        text: root.focusingThisMonitor && root.activeWindow?.activated && root.biggestWindow ? 
            root.activeWindow?.appId.charAt(0).toUpperCase() + root.activeWindow?.appId.slice(1) :
            (root.biggestWindow?.class) ?? Translation.tr("Desktop")
        font.weight: Appearance?.font.weight.medium ?? 400
    }
}
