import qs.configs
import qs.services
import QtQuick

/**
 * A convenience MouseArea for handling drag events.
 */
MouseArea {
    id: root
    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

    property bool interactive: true
    property bool automaticallyReset: true

    readonly property real dragDiffX: _dragDiffX
    readonly property real dragDiffY: _dragDiffY

    signal dragPressed(real diffX, real diffY)
    signal dragReleased(real diffX, real diffY)

    property real startX: 0
    property real startY: 0
    property bool dragging: false
    property real _dragDiffX: 0
    property real _dragDiffY: 0

    function resetDrag() {
        _dragDiffX = 0
        _dragDiffY = 0
    }

    onPressed: (mouse) => {
        if (!root.interactive) {
            if (mouse.button === Qt.LeftButton)
                mouse.accepted = false
            return
        }

        if (mouse.button === Qt.LeftButton) {
            startX = mouse.x
            startY = mouse.y
            dragging = false
        }
    }

    onReleased: (mouse) => {
        if (!root.interactive)
            return

        dragging = false
        root.dragReleased(_dragDiffX, _dragDiffY)

        if (root.automaticallyReset)
            root.resetDrag()
    }

    onPositionChanged: (mouse) => {
        if (!root.interactive)
            return

        if (mouse.buttons & Qt.LeftButton) {
            _dragDiffX = mouse.x - startX
            _dragDiffY = mouse.y - startY

            root.dragPressed(_dragDiffX, _dragDiffY)
            dragging = true
        }
    }

    onCanceled: (mouse) => {
        if (!root.interactive)
            return

        dragging = false
        root.dragReleased(_dragDiffX, _dragDiffY)

        if (root.automaticallyReset)
            root.resetDrag()
    }
}