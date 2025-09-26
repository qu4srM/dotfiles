import qs
import qs.configs
import qs.widgets 

import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Widgets

Flickable {
    id: root
    //anchors.fill: parent
    //anchors.rightMargin: 10
    //forceWidth: true

    maximumFlickVelocity: 3500

    anchors.fill: parent 
    anchors.rightMargin: 10
    contentHeight: parent.implicitHeight
    clip: true
    
    ContentSection{
        id: content
        width: root.width
        title: "Dock"
        icon: "dock_to_bottom"
        spacing: 5
        ConfigSwitch {
            implicitWidth: root.width
            implicitHeight: 40
            text: Translation.tr("Enable")
        }
        ConfigSwitch {
            implicitWidth: root.width
            implicitHeight: 40
            text: Translation.tr("Hover to reveal")
        }
        ConfigSwitch {
            implicitWidth: root.width
            implicitHeight: 40
            text: Translation.tr("Pinned on startup")
        }
    }
}