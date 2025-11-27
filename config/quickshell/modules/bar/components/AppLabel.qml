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
    implicitWidth: textItem.implicitWidth + 14
    StyledText {
        id: textItem
        anchors.centerIn: parent
        font.pixelSize: Appearance.font.pixelSize.normal
        color: Appearance.colors.colText
        text: root.focusingThisMonitor && root.activeWindow?.activated && root.biggestWindow ? 
            root.activeWindow?.appId :
            (root.biggestWindow?.class) ?? Translation.tr("Desktop")
    }
}
