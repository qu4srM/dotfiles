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
    property QtObject animation

    colors: QtObject {
        property bool darkmode: false
        property bool transparent: false
        property color background: "#9d212b3c"
        property color background_bar: "black"
        property color background_dock: "black"
        property color colOnText: "white"
        property color colMSymbol: "white"
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
        property QtObject weight: QtObject {
            property int thin: Font.Thin            // 100
            property int extraLight: Font.ExtraLight // 200
            property int light: Font.Light          // 300
            property int normal: Font.Normal        // 400
            property int medium: Font.Medium        // 500
            property int demiBold: Font.DemiBold    // 600
            property int bold: Font.Bold            // 700
            property int extraBold: Font.ExtraBold  // 800
            property int black: Font.Black          // 900
        }
    }
    animation: QtObject {
        property QtObject elementExpand: QtObject {
            property int duration: 300
            property int type: Easing.InOutQuad
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementExpand.duration
                    easing.type: root.animation.elementExpand.type
                }
            }
        }
    }

    sizes: QtObject {
        property real barHeight: 24
        property real dockHeight: 40
        property real sidebarWidth: 360
        property real sidebarWidthExtended: 750
        property real notchWidth: 180
        property real notchWidthExtended: 300
        property real notchHeight: 5
        property real notchHeightExtended: 100
        property real volumeWidth: 30
        property real volumeHeight: 400
    }
}
