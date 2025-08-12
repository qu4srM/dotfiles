pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

Singleton {
    id: root

    property QtObject colors
    property QtObject rounding
    property QtObject sizes 
    property QtObject margins
    property QtObject font
    property QtObject animation
    property QtObject animationCurves 
    property QtObject animationDurations

    colors: QtObject {
        property bool darkmode: true
        property bool transparent: false
        property color colbackground: "#1B1B1F"  
        //property color colbackground: "transparent"
        property color colprimary: "#7d03ba"
        property color colprimary_hover: "#a503ba"
        property color colsecondary: "#36343B"
        property color colsecondary_hover: "#5a5762"
        property color colprimaryicon: "#e0d5e0"
        property color colprimarytext: "#e0d5e0"
        property color colsecondarytext: "#8393a6"
        property color background_bar: "black"
        property color background_dock: "black"
        property color colOnText: "white"
        property color colMSymbol: "white"
        property color colprimary_error: "red"
    }
    rounding: QtObject {
        property int unsharpen: 2
        property int unsharpenmore: 6
        property int verysmall: 10
        property int small: 12
        property int normal: 15
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
            property int duration: root.animationDurations.normal
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.standard
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementExpand.duration
                    easing.type: root.animation.elementExpand.type
                    easing.bezierCurve: root.animation.elementExpand.bezierCurve
                }
            }
        }
        property QtObject elementMove: QtObject {
            property int duration: animationDurations.expressiveDefaultSpatial
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.expressiveDefaultSpatial
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMove.duration
                    easing.type: root.animation.elementMove.type
                    easing.bezierCurve: root.animation.elementMove.bezierCurve
                }
            }
            property Component colorAnimation: Component {
                ColorAnimation {
                    duration: root.animation.elementMove.duration
                    easing.type: root.animation.elementMove.type
                    easing.bezierCurve: root.animation.elementMove.bezierCurve
                }
            }
        }
        property QtObject elementMoveEnter: QtObject {
            property int duration: 400
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.emphasizedDecel
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMoveEnter.duration
                    easing.type: root.animation.elementMoveEnter.type
                    easing.bezierCurve: root.animation.elementMoveEnter.bezierCurve
                }
            }
        }
        property QtObject elementMoveFast: QtObject {
            property int duration: animationDurations.expressiveEffects
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.expressiveEffects
            property int velocity: 850
            property Component colorAnimation: Component { ColorAnimation {
                duration: root.animation.elementMoveFast.duration
                easing.type: root.animation.elementMoveFast.type
                easing.bezierCurve: root.animation.elementMoveFast.bezierCurve
            }}
            property Component numberAnimation: Component { NumberAnimation {
                    duration: root.animation.elementMoveFast.duration
                    easing.type: root.animation.elementMoveFast.type
                    easing.bezierCurve: root.animation.elementMoveFast.bezierCurve
            }}
        }
        property QtObject scroll: QtObject {
            property int duration: 200
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.standardDecel
        }
    }
    animationCurves: QtObject {
        property list<real> emphasized: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
        property list<real> emphasizedFirstHalf: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82]
        property list<real> emphasizedLastHalf: [5 / 24, 0.82, 0.25, 1, 1, 1]
        property list<real> emphasizedAccel: [0.3, 0, 0.8, 0.15, 1, 1]
        property list<real> emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
        property list<real> standard: [0.2, 0, 0, 1, 1, 1]
        property list<real> standardAccel: [0.3, 0, 1, 1, 1, 1]
        property list<real> standardDecel: [0, 0, 0, 1, 1, 1]
        property list<real> expressiveFastSpatial: [0.42, 1.67, 0.21, 0.9, 1, 1]
        property list<real> expressiveDefaultSpatial: [0.38, 1.21, 0.22, 1, 1, 1]
        property list<real> expressiveSlowSpatial: [0.39, 1.29, 0.35, 0.98, 1, 1]
        property list<real> expressiveEffects: [0.34, 0.8, 0.34, 1, 1, 1]
    }
    animationDurations: QtObject {
        property real scale: 1
        property int small: 200 * scale
        property int normal: 400 * scale
        property int large: 600 * scale
        property int extraLarge: 1000 * scale
        property int expressiveFastSpatial: 350 * scale
        property int expressiveDefaultSpatial: 500 * scale
        property int expressiveSlowSpatial: 650 * scale
        property int expressiveEffects: 200 * scale
    }
    sizes: QtObject {
        property real barHeight: 30
        property real dockHeight: 40
        property real sidebarWidth: 360
        property real sidebarWidthExtended: 750
        property real sidebarLeftWidth: 440
        property real workspacesWidth: 200
        property real volumeWidth: 30
        property real volumeHeight: 400
        property real dashboardWidth: 500
        property real dashboardHeight: 200
    }
    margins: QtObject {
        property real itemBarMargin: 6
        property real panelMargin: 4
    }
}
