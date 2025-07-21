pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

Singleton {
    id: root
    property bool sidebarRightOpen: false
    property bool hackOpen: false
    property bool notchOpen: false
    property bool notchSettingsOpen: false
    property bool osdOpen: false
}