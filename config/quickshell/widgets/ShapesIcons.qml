import qs
import qs.configs
import qs.widgets
import qs.utils

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

Item {
    id: root 
    property string shape: Config.options.appearance.shape
    property color color: Appearance.colors.colPrimaryActive
    Loader {
        anchors.fill: parent
        active: root.shape === "circle"
        sourceComponent: Rectangle {
            anchors.fill: parent 
            color: root.color
            radius: Appearance.rounding.full
        }
    }
    Loader {
        anchors.fill: parent
        active: root.shape === "square"
        sourceComponent: Rectangle {
            anchors.fill: parent 
            color: root.color
            radius: Appearance.rounding.normal
        }
    }
    Loader {
        anchors.fill: parent
        active: root.shape === "4sidedcookie"
        sourceComponent: SidedCookieShape {
            rotation: 23
            sides: 4
            bulge: 0.3
            fillColor: root.color
        }
    }
    Loader {
        anchors.fill: parent
        active: root.shape === "7sidedcookie"
        sourceComponent: SidedCookieShape {
            sides: 7
            bulge: 0.1
            fillColor: root.color
        }
    }

    Loader {
        anchors.fill: parent
        active: root.shape === "arch"
        sourceComponent: Rectangle {
            anchors.fill: parent 
            color: root.color
            topLeftRadius: Appearance.rounding.full
            topRightRadius: Appearance.rounding.full
            bottomLeftRadius: Appearance.rounding.unsharpenmore
            bottomRightRadius: Appearance.rounding.unsharpenmore
        }
    }
}