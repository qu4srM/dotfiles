import qs
import qs.configs
import qs.widgets

import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Wayland

Item {
    id: root

    signal moveToWorkspace(int workspaceId)
    signal focusWindow()
    signal requestCloseWindow()

    property var toplevel
    property var windowData
    property var monitorData

    property real scale: 1

    property real workspaceWidth: 0
    property real workspaceHeight: 0
    property real workspaceSpacing: 0

    property int draggingTargetWorkspace: -1

    property int workspaceColumn:
        ((windowData?.workspace?.id ?? 1) - 1) % 5

    property int workspaceRow:
        Math.floor(
            (((windowData?.workspace?.id ?? 1) - 1) % 10)
            / 5
        )

    property real workspaceOffsetX:
        workspaceColumn
        * (workspaceWidth + workspaceSpacing)

    property real workspaceOffsetY:
        workspaceRow
        * (workspaceHeight + workspaceSpacing)

    property real localX:
        Math.max(
            (
                (windowData?.at?.[0] ?? 0)
                - (monitorData?.x ?? 0)
                - (monitorData?.reserved?.[0] ?? 0)
            ) * scale,
            0
        )

    property real localY:
        Math.max(
            (
                (windowData?.at?.[1] ?? 0)
                - (monitorData?.y ?? 0)
                - (monitorData?.reserved?.[1] ?? 0)
            ) * scale,
            0
        )

    x: workspaceOffsetX + localX
    y: workspaceOffsetY + localY

    width: (windowData?.size?.[0] ?? 100) * scale
    height: (windowData?.size?.[1] ?? 100) * scale

    z: mouseArea.drag.active ? 99999 : 1

    layer.enabled: true

    layer.effect: OpacityMask {
        maskSource: Rectangle {
            width: root.width
            height: root.height
            radius: 10
        }
    }

    ScreencopyView {
        anchors.fill: parent

        captureSource: root.toplevel
        live: GlobalStates.overviewOpen

        Rectangle {
            anchors.fill: parent

            radius: 10

            color:
                mouseArea.pressed
                ? Appearance.colors.colPrimary
                : "transparent"

            border.width: 1
            border.color: Appearance.colors.colOutline
        }

        StyledIcon {
            anchors.centerIn: parent

            source: Quickshell.iconPath(
                windowData?.class ?? "",
                "image-missing"
            )

            width: 22
            height: 22
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true

        acceptedButtons:
            Qt.LeftButton | Qt.MiddleButton

        drag.target: root

        onReleased: {

            if (
                root.draggingTargetWorkspace !== -1
                && root.draggingTargetWorkspace
                !== windowData?.workspace?.id
            ) {

                root.moveToWorkspace(
                    root.draggingTargetWorkspace
                )

            } else {

                root.x = root.workspaceOffsetX + root.localX
                root.y = root.workspaceOffsetY + root.localY
            }
        }

        onClicked: event => {

            if (event.button === Qt.LeftButton) {
                root.focusWindow()
            }

            if (event.button === Qt.MiddleButton) {
                root.closeWindow()
            }
        }
    }
}