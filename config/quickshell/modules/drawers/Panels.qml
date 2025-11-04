import qs.modules.background 
import qs.modules.overview 
import qs.modules.launcher

import QtQuick
import Quickshell

Item {
    id: root
    required property var styledWindow
    property alias overview: overview
    property alias wallSelector: wallSelector
    property alias launcher: launcher
    anchors.fill: parent
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
    Launcher {
        id: launcher
        styledWindow: root.styledWindow
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
    }
}