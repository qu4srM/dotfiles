import qs
import qs.configs
import qs.modules.dock
import qs.widgets
import qs.utils

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

MouseArea {
    id: root
    required property ListView list
    propagateComposedEvents: true

    property real maxDist: Config.options.dock.magnification.maxDist
    property real maxBoost: Config.options.dock.magnification.maxBoost
    property real lastUpdateTime: 0

    property bool isVertical: list.orientation === ListView.Vertical

    onPositionChanged: function(mouse) {
        if (list.count <= 0) return

        const now = Date.now()
        if (now - lastUpdateTime < 16) return
        lastUpdateTime = now

        for (let i = 0; i < list.count; i++) {
            const item = list.itemAtIndex(i)
            if (!item) continue

            let center
            let dist

            if (isVertical) {
                center = item.mapToItem(parent, 0, item.height / 2)
                dist = Math.abs(mouse.y - center.y)
            } else {
                center = item.mapToItem(parent, item.width / 2, 0)
                dist = Math.abs(mouse.x - center.x)
            }

            const scale =
                1 + Math.max(
                    0,
                    (maxDist - dist) / maxDist
                ) * maxBoost

            item.hoverScale = scale
        }
    }

    onExited: {
        for (let i = 0; i < list.count; i++) {
            const item = list.itemAtIndex(i)
            if (item) item.hoverScale = 1.0
        }
    }
}