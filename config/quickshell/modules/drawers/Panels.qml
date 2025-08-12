import qs 
import qs.configs
import qs.modules.drawers
import qs.modules.background 
import qs.modules.overview 
import qs.widgets 
import qs.utils

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

Item {
    id: root
    required property var styledWindow
    //property alias dashboard: dashboard
    property alias overview: overview
    property alias wallSelector: wallSelector
    anchors.fill: parent
    /*Dashboard {
        id: dashboard
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
    }*/
    Overview {
        id: overview 
        styledWindow: root.styledWindow
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top

    }
    WallSelector {
        id: wallSelector 
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
    }

}