pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.utils
import "./"

Singleton {
    id: root

    property QtObject colors
    property QtObject mcolors
    property QtObject rounding
    property QtObject sizes 
    property QtObject margins
    property QtObject font
    property QtObject animation
    property QtObject animationCurves 
    property QtObject animationDurations
    
    mcolors: QtObject {
        property bool mdarkmode: Theme.options.darkmode
        property bool mtransparent: Theme.options.transparent

        property color mPrimaryPaletteKeyColor: Theme.options.material_colors.colPrimaryPaletteKeyColor
        property color mSecondaryPaletteKeyColor: Theme.options.material_colors.colSecondaryPaletteKeyColor
        property color mTertiaryPaletteKeyColor: Theme.options.material_colors.colTertiaryPaletteKeyColor
        property color mNeutralPaletteKeyColor: Theme.options.material_colors.colNeutralPaletteKeyColor
        property color mNeutralVariantPaletteKeyColor: Theme.options.material_colors.colNeutralVariantPaletteKeyColor

        property color mBackground: Theme.options.material_colors.colBackground
        property color mOnBackground: Theme.options.material_colors.colOnBackground
        property color mSurface: Theme.options.material_colors.colSurface
        property color mSurfaceDim: Theme.options.material_colors.colSurfaceDim
        property color mSurfaceBright: Theme.options.material_colors.colSurfaceBright
        property color mSurfaceContainerLowest: Theme.options.material_colors.colSurfaceContainerLowest
        property color mSurfaceContainerLow: Theme.options.material_colors.colSurfaceContainerLow
        property color mSurfaceContainer: Theme.options.material_colors.colSurfaceContainer
        property color mSurfaceContainerHigh: Theme.options.material_colors.colSurfaceContainerHigh
        property color mSurfaceContainerHighest: Theme.options.material_colors.colSurfaceContainerHighest
        property color mOnSurface: Theme.options.material_colors.colOnSurface
        property color mSurfaceVariant: Theme.options.material_colors.colSurfaceVariant
        property color mOnSurfaceVariant: Theme.options.material_colors.colOnSurfaceVariant

        property color mInverseSurface: Theme.options.material_colors.colInverseSurface
        property color mInverseOnSurface: Theme.options.material_colors.colInverseOnSurface
        property color mOutline: Theme.options.material_colors.colOutline
        property color mOutlineVariant: Theme.options.material_colors.colOutlineVariant
        property color mShadow: Theme.options.material_colors.colShadow
        property color mScrim: Theme.options.material_colors.colScrim
        property color mSurfaceTint: Theme.options.material_colors.colSurfaceTint

        property color mPrimary: Theme.options.material_colors.colPrimary
        property color mOnPrimary: Theme.options.material_colors.colOnPrimary
        property color mPrimaryContainer: Theme.options.material_colors.colPrimaryContainer
        property color mOnPrimaryContainer: Theme.options.material_colors.colOnPrimaryContainer
        property color mInversePrimary: Theme.options.material_colors.colInversePrimary

        property color mSecondary: Theme.options.material_colors.colSecondary
        property color mOnSecondary: Theme.options.material_colors.colOnSecondary
        property color mSecondaryContainer: Theme.options.material_colors.colSecondaryContainer
        property color mOnSecondaryContainer: Theme.options.material_colors.colOnSecondaryContainer

        property color mTertiary: Theme.options.material_colors.colTertiary
        property color mOnTertiary: Theme.options.material_colors.colOnTertiary
        property color mTertiaryContainer: Theme.options.material_colors.colTertiaryContainer
        property color mOnTertiaryContainer: Theme.options.material_colors.colOnTertiaryContainer

        property color mError: Theme.options.material_colors.colError
        property color mOnError: Theme.options.material_colors.colOnError
        property color mErrorContainer: Theme.options.material_colors.colErrorContainer
        property color mOnErrorContainer: Theme.options.material_colors.colOnErrorContainer

        property color mPrimaryFixed: Theme.options.material_colors.colPrimaryFixed
        property color mPrimaryFixedDim: Theme.options.material_colors.colPrimaryFixedDim
        property color mOnPrimaryFixed: Theme.options.material_colors.colOnPrimaryFixed
        property color mOnPrimaryFixedVariant: Theme.options.material_colors.colOnPrimaryFixedVariant

        property color mSecondaryFixed: Theme.options.material_colors.colSecondaryFixed
        property color mSecondaryFixedDim: Theme.options.material_colors.colSecondaryFixedDim
        property color mOnSecondaryFixed: Theme.options.material_colors.colOnSecondaryFixed
        property color mOnSecondaryFixedVariant: Theme.options.material_colors.colOnSecondaryFixedVariant

        property color mTertiaryFixed: Theme.options.material_colors.colTertiaryFixed
        property color mTertiaryFixedDim: Theme.options.material_colors.colTertiaryFixedDim
        property color mOnTertiaryFixed: Theme.options.material_colors.colOnTertiaryFixed
        property color mOnTertiaryFixedVariant: Theme.options.material_colors.colOnTertiaryFixedVariant

        property color mSuccess: Theme.options.material_colors.colSuccess
        property color mOnSuccess: Theme.options.material_colors.colOnSuccess
        property color mSuccessContainer: Theme.options.material_colors.colSuccessContainer
        property color mOnSuccessContainer: Theme.options.material_colors.colOnSuccessContainer
    }
    colors: QtObject {
        property bool darkmode: mcolors.mdarkmode
        property bool transparent: mcolors.mtransparent

        property color colText: mcolors.mOutline

        property color colPrimary: mcolors.mPrimary
        property color colOnPrimary: mcolors.mOnPrimary
        property color colPrimaryContainer: mcolors.mPrimaryContainer
        property color colOnPrimaryContainer: mcolors.mOnPrimaryContainer
        property color colInversePrimary: mcolors.mInversePrimary
        property color colPrimaryHover: Colors.setMix(colors.colPrimary, colOnPrimary, 0.87)
        property color colPrimaryActive: Colors.setMix(colors.colPrimary, colOnPrimary, 0.7)
        property color colPrimaryContainerHover: Colors.setMix(colors.colPrimaryContainer, colOnPrimaryContainer, 0.9)
        property color colPrimaryContainerActive: Colors.setMix(colors.colPrimaryContainer, colOnPrimaryContainer, 0.8)


        property color colSecondary: mcolors.mSecondary
        property color colOnSecondary: mcolors.mOnSecondary
        property color colSecondaryHover: Colors.setMix(colors.colSecondary, colOnSecondary, 0.87)
        property color colSecondaryActive: Colors.setMix(colors.colSecondary, colOnSecondary, 0.7)
        property color colSecondaryContainer: mcolors.mSecondaryContainer
        property color colOnSecondaryContainer: mcolors.mOnSecondaryContainer
        property color colSecondaryContainerHover: Colors.setMix(colors.colSecondaryContainer, colOnSecondaryContainer, 0.9)
        property color colSecondaryContainerActive: Colors.setMix(colors.colSecondaryContainer, colOnSecondaryContainer, 0.8)

        property color colTertiary: mcolors.mTertiary
        property color colOnTertiary: mcolors.mOnTertiary
        property color colTertiaryContainer: mcolors.mTertiaryContainer
        property color colOnTertiaryContainer: mcolors.mOnTertiaryContainer

        property color colError: mcolors.mError
        property color colOnError: mcolors.mOnError
        property color colErrorContainer: mcolors.mErrorContainer
        property color colOnErrorContainer: mcolors.mOnErrorContainer

        property color colBackground: mcolors.mBackground
        property color colOnBackground: mcolors.mOnBackground
        property color colBackgroundHover: Colors.setMix(colors.colBackground, colors.colOnBackground, 0.87)
        property color colSurface: mcolors.mSurface
        property color colSurfaceDim: mcolors.mSurfaceDim
        property color colSurfaceBright: mcolors.mSurfaceBright
        property color colSurfaceContainerLowest: mcolors.mSurfaceContainerLowest
        property color colSurfaceContainerLow: mcolors.mSurfaceContainerLow
        property color colSurfaceContainer: mcolors.mSurfaceContainer
        property color colSurfaceContainerHigh: mcolors.mSurfaceContainerHigh
        property color colSurfaceContainerHighest: mcolors.mSurfaceContainerHighest
        property color colSurfaceContainerHighestHover: Colors.setMix(colors.colSurfaceContainerHighest, colors.colOnSurface, 0.95)
        property color colSurfaceContainerHighestActive: Colors.setMix(colors.colSurfaceContainerHighest, colors.colOnSurface, 0.85)
        property color colOnSurface: mcolors.mOnSurface
        property color colSurfaceVariant: mcolors.mSurfaceVariant
        property color colOnSurfaceVariant: mcolors.mOnSurfaceVariant

        property color colInverseSurface: mcolors.mInverseSurface
        property color colInverseOnSurface: mcolors.mInverseOnSurface
        property color colOutline: mcolors.mOutline
        property color colOutlineVariant: mcolors.mOutlineVariant
        property color colShadow: mcolors.mShadow
        property color colScrim: mcolors.mScrim
        property color colSurfaceTint: mcolors.mSurfaceTint

        property color colPrimaryFixed: mcolors.mPrimaryFixed
        property color colPrimaryFixedDim: mcolors.mPrimaryFixedDim
        property color colOnPrimaryFixed: mcolors.mOnPrimaryFixed
        property color colOnPrimaryFixedVariant: mcolors.mOnPrimaryFixedVariant

        property color colSecondaryFixed: mcolors.mSecondaryFixed
        property color colSecondaryFixedDim: mcolors.mSecondaryFixedDim
        property color colOnSecondaryFixed: mcolors.mOnSecondaryFixed
        property color colOnSecondaryFixedVariant: mcolors.mOnSecondaryFixedVariant

        property color colTertiaryFixed: mcolors.mTertiaryFixed
        property color colTertiaryFixedDim: mcolors.mTertiaryFixedDim
        property color colOnTertiaryFixed: mcolors.mOnTertiaryFixed
        property color colOnTertiaryFixedVariant: mcolors.mOnTertiaryFixedVariant

        property color colSuccess: mcolors.mSuccess
        property color colOnSuccess: mcolors.mOnSuccess
        property color colSuccessContainer: mcolors.mSuccessContainer
        property color colOnSuccessContainer: mcolors.mOnSuccessContainer

        property color colTooltip: mcolors.mInverseSurface
        property color colOnTooltip: mcolors.mInverseOnSurface

        property color colsecondary: "#36343B"
        property color colsecondary_hover: "#5a5762"
        property color coltertiary: "#414148"
        property color colprimaryicon: "#e0d5e0"
        property color colprimarytext: "#E2E2E9"
        property color colsecondarytext: "#8393a6"
        property color colglassmorphism: "#ffffff"
        property color coltooltip: mcolors.mInverseOnSurface
        property color colOnText: "white"
        property color colMSymbol: "white"
        property color coloutlined: "white"
        property color colshadow: "#000000"
    }

    /*
    colors: QtObject {
        property bool darkmode: true
        property bool transparent: false
        property color colbackground: "#1B1B1F"  
        property color colprimary: "#7d03ba"
        property color colprimary_hover: "#a503ba"
        //........
        property color colPrimary: "#aac7ff"
        property color colOnPrimary: "#0a305f"
        property color colPrimaryHover: "#5b8adb"
        property color colPrimaryActive: "#648ed7"
        property color colPrimaryContainer: "#284777"
        property color colOnPrimaryContainer: "#d6e3ff"
        property color colInversePrimary: "#415f91"

        property color colSecondary: "#bec6dc"
        property color colOnSecondary: "#283141"
        property color colSecondaryContainer: "#3e4759"
        property color colOnSecondaryContainer: "#dae2f9"

        property color colTertiary: "#ddbce0"
        property color colOnTertiary: "#3f2844"
        property color colTertiaryContainer: "#573e5c"
        property color colOnTertiaryContainer: "#fad8fd"

        property color colError: "#ffb4ab"
        property color colOnError: "#690005"
        property color colErrorContainer: "#93000a"
        property color colOnErrorContainer: "#ffdad6"

        property color colSurface: "#111318"
        property color colSurfaceDim: "#111318"
        property color colSurfaceBright: "#37393e"
        property color colSurfaceContainerLowest: "#0c0e13"
        property color colSurfaceContainerLow: "#191c20"
        property color colSurfaceContainer: "#1d2024"
        property color colSurfaceContainerHigh: "#282a2f"
        property color colSurfaceContainerHighest: "#33353a"
        property color colOnSurface: "#e2e2e9"
        property color colOnSurfaceVar: "#c4c6d0"
        property color colInverseSurface: "#e2e2e9"
        property color colInverseOnSurface: "#2e3036"
        property color colOutline: "#8e9099"
        property color colOutlineVariant: "#8e9099"

        property color colScrim: "#000000"
        property color colShadow: "#000000"

        
        property color colNeutral: "#919093"
        property color colNeutralVariant: "#8E9098"

        property QtObject palettes: QtObject {
            property QtObject primary: QtObject {
                property color col0: "#000000"
                property color col5: "#00102B"
                property color col10: "#001B3E"
                property color col15: "#002551"
                property color col20: "#002F64"
                property color col25: "#033A77"
                property color col30: "#194683"
                property color col35: "#285290"
                property color col40: "#365E9D"
                property color col50: "#5177B8"
                property color col60: "#6B91D3"
                property color col70: "#86ACF0"
                property color col80: "#AAC7FF"
                property color col90: "#D6E3FF"
                property color col95: "#ECF0FF"
                property color col98: "#F9F9FF"
                property color col99: "#FDFBFF"
                property color col100: "#FFFFFF"
            }

            property QtObject secondary: QtObject {
                property color col0: "#000000"
                property color col5: "#09111E"
                property color col10: "#141C29"
                property color col15: "#1E2634"
                property color col20: "#29313F"
                property color col25: "#343C4A"
                property color col30: "#3F4756"
                property color col35: "#4B5362"
                property color col40: "#575E6F"
                property color col50: "#707788"
                property color col60: "#8991A2"
                property color col70: "#A4ABBD"
                property color col80: "#BFC6D9"
                property color col90: "#DBE2F6"
                property color col95: "#ECF0FF"
                property color col98: "#F9F9FF"
                property color col99: "#FDFBFF"
                property color col100: "#FFFFFF"
            }

            property QtObject tertiary: QtObject {
                property color col0: "#000000"
                property color col5: "#1B0A21"
                property color col10: "#27142C"
                property color col15: "#321F37"
                property color col20: "#3D2942"
                property color col25: "#49344D"
                property color col30: "#553F59"
                property color col35: "#614B65"
                property color col40: "#6E5772"
                property color col50: "#886F8B"
                property color col60: "#A288A6"
                property color col70: "#BEA2C1"
                property color col80: "#DABDDD"
                property color col90: "#F7D9FA"
                property color col95: "#FFEBFE"
                property color col98: "#FFF7FB"
                property color col99: "#FFFBFF"
                property color col100: "#FFFFFF"
            }

            property QtObject neutral: QtObject {
                property color col0: "#000000"
                property color col5: "#101113"
                property color col10: "#1B1B1E"
                property color col15: "#252628"
                property color col20: "#303033"
                property color col25: "#3B3B3E"
                property color col30: "#464649"
                property color col35: "#525255"
                property color col40: "#5E5E61"
                property color col50: "#77777A"
                property color col60: "#919093"
                property color col70: "#ACABAE"
                property color col80: "#C7C6C9"
                property color col90: "#E3E2E5"
                property color col95: "#F2F0F3"
                property color col98: "#FAF9FC"
                property color col99: "#FDFBFF"
                property color col100: "#FFFFFF"
            }

            property QtObject neutralVariant: QtObject {
                property color col0: "#000000"
                property color col5: "#0E1117"
                property color col10: "#191C22"
                property color col15: "#23262C"
                property color col20: "#2E3037"
                property color col25: "#393B42"
                property color col30: "#44474D"
                property color col35: "#505259"
                property color col40: "#5C5E65"
                property color col50: "#75777E"
                property color col60: "#8E9098"
                property color col70: "#A9ABB3"
                property color col80: "#C5C6CE"
                property color col90: "#E1E2EA"
                property color col95: "#EFF0F9"
                property color col98: "#F9F9FF"
                property color col99: "#FDFBFF"
                property color col100: "#FFFFFF"
            }
        }

        //........
        property color colsecondary: "#36343B"
        property color colsecondary_hover: "#5a5762"
        property color coltertiary: "#414148"
        property color colprimaryicon: "#e0d5e0"
        //property color colprimarytext: "#e0d5e0"
        property color colprimarytext: "#E2E2E9"
        property color colsecondarytext: "#8393a6"
        property color colglassmorphism: "#ffffff"
        property color coltooltip: "#3C4043"
        property color colOnText: "white"
        property color colMSymbol: "white"
        property color coloutlined: "white"
        property color colshadow: "#000000"
    }*/
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
            property string main: "Rubik"
            property string title: "Gabarito"
            property string iconMaterial: "Material Symbols Rounded"
            property string iconNerd: "JetBrains Mono NF"
            property string monospace: "JetBrains Mono NF"
            property string reading: "Readex Pro"
            property string expressive: "Space Grotesk"
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
        property real barHeight: 40
        property real dockHeight: 40
        property real sidebarWidth: 380
        property real sidebarWidthExtended: 750
        property real sidebarLeftWidth: 460
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
