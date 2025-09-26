import qs
import qs.configs
import qs.utils
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

ColumnLayout {
    id: root
    
    property string title
    property string icon: ""
    default property alias data: sectionContent.data

    Layout.fillWidth: true
    spacing: 6
    RowLayout {
        StyledMaterialSymbol {
            text: root.icon
            font.pixelSize: Appearance.font.pixelSize.larger
            color: "white"
        }
        StyledText {
            text: root.title
            font.pixelSize: Appearance.font.pixelSize.larger
            font.weight: Font.Medium
        }

    }
    /*
    ColumnLayout {
        id: sectionContent
        Layout.fillWidth: true
        spacing: 4

    }*/
    ClippingRectangle {
        Layout.fillWidth: true
        height: sectionContent.implicitHeight
        color: "transparent"
        radius: Appearance.rounding.normal
        
        ColumnLayout {
            id: sectionContent
            spacing: 2
        }
    }
}