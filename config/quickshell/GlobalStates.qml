pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

Singleton {
    id: root
    property bool barOpen: true
    property bool drawersOpen: true
    property bool sidebarRightOpen: false
    property bool sidebarLeftOpen: false
    property bool dashboardOpen: false
    property bool wallSelectorOpen: false
    property bool launcherOpen: false
    property bool overviewOpen: false
    property bool osdOpen: false
    property bool sessionOpen: false 
    property bool screenLock: false
    property bool screenLockContainsCharacters: false
    property int currentTabDashboard
}