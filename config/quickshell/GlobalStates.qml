pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

Singleton {
    id: root
    property bool sidebarRightOpen: false
    property bool dashboardOpen: false
    property bool wallSelectorOpen: false
    property bool osdOpen: false
    property int currentTabDashboard
}