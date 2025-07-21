import "root:/"

import Quickshell
import QtQuick
import QtQuick.Controls

MouseArea {
    id: root
    required property ShellScreen screen
    property Item osdVol
    property Item hack
    property Item popups
    property point dragStart
    
    anchors.fill: parent 
    hoverEnabled: true 

    property var edgeMargin: 10
    property bool dragging: false

    function inTopEdge(x, y) {
        return y <= edgeMargin;
    }
    function inBottomEdge(x, y) {
        return y >= root.height - edgeMargin;
    }
    function inLeftEdge(x, y) {
        return x <= edgeMargin;
    }
    function inRightEdge(x, y) {
        return x >= root.width - edgeMargin;
    }

    onPressed: event => {
        dragStart = Qt.point(event.x, event.y);
        dragging = inLeftEdge(event.x, event.y);
    }
    onPositionChanged: event => {
        if (!dragging) return;
        const dragX = event.x - dragStart.x;
        if (dragX > 30) {
            GlobalStates.onScreenVolumeOpen = true;
            dragging = false;
        }
    }
    onReleased: () => dragging = false
    onCanceled: () => dragging = false
}