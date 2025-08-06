import "root:/modules/common/"
import "root:/"
import "root:/widgets/"

import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets

Item {
    id: root
    property var toplevel
    property var windowData
    property var monitorData
    property var scale
    property var availableWorkspaceWidth
    property var availableWorkspaceHeight
    property bool restrictToWorkspace: true
    property real initX: Math.max((windowData?.at[0] - (monitorData?.x ?? 0) - monitorData?.reserved[0]) * root.scale, 0) + xOffset
    property real initY: Math.max((windowData?.at[1] - (monitorData?.y ?? 0) - monitorData?.reserved[1]) * root.scale, 0) + yOffset
    property real xOffset: 0
    property real yOffset: 0
    
    property var targetWindowWidth: windowData?.size[0] * scale
    property var targetWindowHeight: windowData?.size[1] * scale
    property bool hovered: false
    property bool pressed: false

    property var iconToWindowRatio: 0.35
    property var xwaylandIndicatorToIconRatio: 0.35
    property var iconToWindowRatioCompact: 0.6
    property var iconPath: Quickshell.iconPath(windowData?.class, "image-missing")
    property bool compactMode: Appearance.font.pixelSize.smaller * 4 > targetWindowHeight || Appearance.font.pixelSize.smaller * 4 > targetWindowWidth

    property bool indicateXWayland: windowData?.xwayland ?? false
    
    x: initX
    y: initY
    width: windowData?.size[0] * root.scale - 2
    height: windowData?.size[1] * root.scale - 2
    

    layer.enabled: true
    layer.effect: OpacityMask {
        maskSource: Rectangle {
            width: root.width
            height: root.height
            radius: 8
        }
    }
    ScreencopyView {
        id: windowPreview
        anchors.fill: parent
        captureSource: root.toplevel
        live: true
        Rectangle {
            anchors.fill: parent
            radius: 10 * root.scale
            color: pressed ? "white" : "transparent"
            border.color : Appearance.colors.colbackground
            border.width : 1
        }
        StyledIcon {
            id: windowIcon
            anchors.centerIn: parent
            Layout.alignment: Qt.AlignHCenter
            source: root.iconPath
            width: 20
            height: 20

            Behavior on width {
                animation: Appearance.animation.elementMoveEnter.numberAnimation.createObject(this)
            }
            Behavior on height {
                animation: Appearance.animation.elementMoveEnter.numberAnimation.createObject(this)
            }
        }
    }


} 
