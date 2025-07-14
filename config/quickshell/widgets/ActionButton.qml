import "root:/modules/common/"
import "root:/widgets/"

import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Widgets

Button {
    id: root
    property bool toggle 
    property string buttonText 
    property real buttonRadiusTopLeft
    property real buttonRadiusTopRight
    property real buttonRadiusBottomLeft
    property real buttonRadiusBottomRight

    property var downAction
    property var releaseAction
    property var altAction 
    property var middleClickAction


    property string colBackground
    property string colBackgroundHover



    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onPressed: (event) => { 
            if(event.button === Qt.RightButton) {
                if (root.altAction) root.altAction();
                return;
            }
            if(event.button === Qt.MiddleButton) {
                if (root.middleClickAction) root.middleClickAction();
                return;
            }
            root.down = true
            if (root.downAction) root.downAction();
        }
        onReleased: (event) => {
            root.down = false
            if (event.button != Qt.LeftButton) return;
            if (root.releaseAction) root.releaseAction();
            root.click()
        }
        onCanceled: (event) => {
            root.down = false
        }
    }
    background: Rectangle {
        id: btnBackground
        implicitHeight: ṕarent.height

        topLeftRadius: root.buttonRadius > 0 ? 0 : root.buttonRadiusTopLeft
        topRightRadius: root.buttonRadius > 0 ? 0 : root.buttonRadiusTopRight
        bottomLeftRadius: root.buttonRadius > 0 ? 0 : root.buttonRadiusBottomLeft
        bottomRightRadius: root.buttonRadius > 0 ? 0 : root.buttonRadiusBottomRight

        color: mouseArea.containsMouse ? root.colBackgroundHover : root.colBackground
    }
    contentItem: StyledText {
        text: root.buttonText
    }
}