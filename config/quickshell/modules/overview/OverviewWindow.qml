import qs 
import qs.configs
import qs.widgets

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
    property var scale: 1
    property var availableWorkspaceWidth: 0
    property var availableWorkspaceHeight: 0
    property bool restrictToWorkspace: true

    // Coordenadas iniciales protegidas contra valores undefined
    property real initX: Math.max(
        (((windowData?.at?.[0] ?? 0) - (monitorData?.x ?? 0) - (monitorData?.reserved?.[0] ?? 0)) * root.scale),
        0
    ) + xOffset

    property real initY: Math.max(
        (((windowData?.at?.[1] ?? 0) - (monitorData?.y ?? 0) - (monitorData?.reserved?.[1] ?? 0)) * root.scale),
        0
    ) + yOffset

    property real xOffset: 0
    property real yOffset: 0
    
    // Tamaños protegidos
    property var targetWindowWidth: (windowData?.size?.[0] ?? 100) * scale
    property var targetWindowHeight: (windowData?.size?.[1] ?? 100) * scale

    property bool hovered: false
    property bool pressed: false

    property var iconToWindowRatio: 0.35
    property var xwaylandIndicatorToIconRatio: 0.35
    property var iconToWindowRatioCompact: 0.6
    property var iconPath: Quickshell.iconPath(windowData?.class ?? "", "image-missing")
    property bool compactMode: (Appearance.font.pixelSize.smaller * 4 > (targetWindowHeight ?? 1))
                               || (Appearance.font.pixelSize.smaller * 4 > (targetWindowWidth ?? 1))

    property bool indicateXWayland: windowData?.xwayland ?? false
    
    x: initX
    y: initY
    width: (windowData?.size?.[0] ?? 100) * root.scale
    height: (windowData?.size?.[1] ?? 100) * root.scale
    

    layer.enabled: true
    layer.effect: OpacityMask {
        maskSource: Rectangle {
            width: root.width
            height: root.height
            radius: 10
        }
    }

    ScreencopyView {
        id: windowPreview
        anchors.fill: parent
        captureSource: root.toplevel
        live: GlobalStates.overviewOpen

        Rectangle {
            anchors.fill: parent
            anchors.centerIn: parent
            radius: 10 * root.scale
            color: pressed ? Appearance.colors.colPrimary : "transparent"
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
