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
    contentHeight: content.implicitHeight + 100
    clip: true
    ColumnLayout {
        id: content
        width: parent.width
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            margins: 20
        }
        spacing: 30
        ContentSection{
            width: root.width
            icon: "spoke"
            title: Translation.tr("Positioning")
            spacing: 5

            ConfigSwitch {
                implicitWidth: root.width
                implicitHeight: 40
                text: Translation.tr("Show background")
                checked: Config.options.bar.showBackground
                onCheckedChanged: {
                    Config.options.bar.showBackground = checked;
                }
            }
            
            ConfigSwitch {
                implicitWidth: root.width
                implicitHeight: 40
                text: Translation.tr("Floating")
                checked: Config.options.bar.floating
                onCheckedChanged: {
                    Config.options.bar.floating = checked;
                }
            } 
        }
    }
}