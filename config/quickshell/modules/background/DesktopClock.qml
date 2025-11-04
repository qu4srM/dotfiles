import qs 
import qs.configs
import qs.widgets 

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    width: parent ? parent.width : 800
    height: parent ? parent.height : 600

    property bool verticalMode: false
    z: clock.editMode ? 10 : 0

    // --- Reloj ---
    Item {
        id: clock
        x: (parent.width - 400) / 2
        y: 100
        width: 400
        height: 200

        property bool editMode: false
        property bool pressed: false

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: "white"
            border.width: 2
            visible: clock.editMode
            z: 1
        }

        // Loader que alterna entre RowLayout y ColumnLayout
        Loader {
            id: clockLoader
            anchors.centerIn: parent
            sourceComponent: root.verticalMode ? verticalClock : horizontalClock
        }

        // --- RowLayout (horizontal) ---
        Component {
            id: horizontalClock
            RowLayout {
                spacing: 0
                StyledText { text: "10"; font.pixelSize: Math.min(clock.width, clock.height) * 0.5; color: "white" }
                StyledText { text: ":";  font.pixelSize: Math.min(clock.width, clock.height) * 0.5; color: "white" }
                StyledText { text: "10"; font.pixelSize: Math.min(clock.width, clock.height) * 0.5; color: "white" }
            }
        }

        // --- ColumnLayout (vertical) ---
        Component {
            id: verticalClock
            Column {
                anchors.centerIn: parent
                spacing: 0
                StyledText { text: "10"; font.pixelSize: Math.min(clock.width, clock.height) * 0.5; color: "white" }
                StyledText { text: "10"; font.pixelSize: Math.min(clock.width, clock.height) * 0.5; color: "white" }
            }
        }

        // --- componente reutilizable para cada handle ---
        Component {
            id: resizeHandleComponent
            Rectangle {
                width: 14; height: 14
                radius: 7
                color: "white"
                visible: clock.editMode
                z: 5

                property bool resizeLeft: false
                property bool resizeRight: false
                property bool resizeTop: false
                property bool resizeBottom: false

                MouseArea {
                    anchors.fill: parent
                    cursorShape: {
                        if (parent.resizeLeft && parent.resizeTop) return Qt.SizeFDiagCursor
                        if (parent.resizeRight && parent.resizeBottom) return Qt.SizeFDiagCursor
                        if (parent.resizeRight && parent.resizeTop) return Qt.SizeBDiagCursor
                        if (parent.resizeLeft && parent.resizeBottom) return Qt.SizeBDiagCursor
                        return Qt.ArrowCursor
                    }

                    property point startPos
                    property size startSize
                    property point startXY

                    onPressed: function(mouse) {
                        startPos = mapToItem(clock.parent, mouse.x, mouse.y)
                        startSize = Qt.size(clock.width, clock.height)
                        startXY = Qt.point(clock.x, clock.y)
                        clock.pressed = true
                    }
                    onReleased: clock.pressed = false

                    onPositionChanged: function(mouse) {
                        if (!clock.pressed) return
                        var cur = mapToItem(clock.parent, mouse.x, mouse.y)
                        var dx = cur.x - startPos.x
                        var dy = cur.y - startPos.y

                        var newX = startXY.x
                        var newY = startXY.y
                        var newW = startSize.width
                        var newH = startSize.height

                        if (parent.resizeLeft) {
                            newX = startXY.x + dx
                            newW = startSize.width - dx
                        }
                        if (parent.resizeRight) {
                            newW = startSize.width + dx
                        }
                        if (parent.resizeTop) {
                            newY = startXY.y + dy
                            newH = startSize.height - dy
                        }
                        if (parent.resizeBottom) {
                            newH = startSize.height + dy
                        }

                        // restricciones mínimas
                        newW = Math.max(100, newW)
                        newH = Math.max(60, newH)

                        // clamp al padre
                        newX = Math.max(0, Math.min(newX, clock.parent.width - newW))
                        newY = Math.max(0, Math.min(newY, clock.parent.height - newH))
                        newW = Math.min(newW, clock.parent.width - newX)
                        newH = Math.min(newH, clock.parent.height - newY)

                        clock.x = newX
                        clock.y = newY
                        clock.width = newW
                        clock.height = newH
                    }
                }
            }
        }

        // --- handles en las 4 esquinas ---
        Loader { sourceComponent: resizeHandleComponent; anchors.left: parent.left; anchors.top: parent.top; anchors.margins: -7;
            onLoaded: { item.resizeLeft = true; item.resizeTop = true } }
        Loader { sourceComponent: resizeHandleComponent; anchors.right: parent.right; anchors.top: parent.top; anchors.margins: -7;
            onLoaded: { item.resizeRight = true; item.resizeTop = true } }
        Loader { sourceComponent: resizeHandleComponent; anchors.left: parent.left; anchors.bottom: parent.bottom; anchors.margins: -7;
            onLoaded: { item.resizeLeft = true; item.resizeBottom = true } }
        Loader { sourceComponent: resizeHandleComponent; anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.margins: -7;
            onLoaded: { item.resizeRight = true; item.resizeBottom = true } }

        // --- drag del reloj ---
        MouseArea {
            id: dragArea
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            z: 10
            property point startDrag
            property point startPos

            onDoubleClicked: clock.editMode = !clock.editMode

            onPressed: function(mouse) {
                if (clock.editMode) {
                    startDrag = mapToItem(clock.parent, mouse.x, mouse.y)
                    startPos = Qt.point(clock.x, clock.y)
                    clock.pressed = true
                    mouse.accepted = true
                }
            }
            onReleased: clock.pressed = false

            onPositionChanged: function(mouse) {
                if (!clock.pressed || !clock.editMode) return
                var cur = mapToItem(clock.parent, mouse.x, mouse.y)
                var dx = cur.x - startDrag.x
                var dy = cur.y - startDrag.y

                var newX = startPos.x + dx
                var newY = startPos.y + dy

                newX = Math.max(0, Math.min(newX, clock.parent.width - clock.width))
                newY = Math.max(0, Math.min(newY, clock.parent.height - clock.height))

                clock.x = newX
                clock.y = newY
            }
        }
    }

    // --- Botón para cambiar entre Row y Column ---
    Button {
        id: switchBtn
        text: root.verticalMode ? "Horizontal" : "Vertical"
        anchors.top: clock.bottom
        anchors.horizontalCenter: clock.horizontalCenter
        anchors.topMargin: 20
        visible: clock.editMode   // 👈 aparece solo en modo edición
        onClicked: root.verticalMode = !root.verticalMode
    }
}
