pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

Singleton {
    id: root

    property QtObject colors
    property QtObject rounding
    property QtObject sizes 
    property QtObject font

    colors: QtObject {
        property bool darkmode: false
        property bool transparent: false
        property color background: "black"
        property color background_bar: "black"
        property color background_dock: "black"
    }

    rounding: QtObject {
        property int unsharpen: 2
        property int unsharpenmore: 6
        property int verysmall: 8
        property int small: 12
        property int normal: 17
        property int large: 23
        property int verylarge: 30
        property int full: 9999
        property int screenRounding: large
        property int windowRounding: 18
    }

    font: QtObject {
        property QtObject family: QtObject {
            property string main: "Roboto"
            property string title: "Gabarito"
            property string iconMaterial: "Material Symbols Rounded"
            property string iconNerd: "SpaceMono NF"
            property string monospace: "Roboto Mono"
            property string reading: "Readex Pro"
        }
        property QtObject pixelSize: QtObject {
            property int smallest: 10
            property int smaller: 12
            property int small: 15
            property int normal: 16
            property int large: 17
            property int larger: 19
            property int huge: 22
            property int hugeass: 23
            property int title: huge
        }
    }

    sizes: QtObject {
        property real barHeight: 24
        property real dockHeight: 40
        property real sidebarWidth: 300
        property real sidebarWidthExtended: 750
        property real notchWidth: 180
        property real notchWidthExtended: 200
        property real notchHeight: 5
        property real notchHeightExtended: 40
    }
}
