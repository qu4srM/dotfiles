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
    property var onHovered
    property var onUnhovered  


    property string colBackground
    property string colBackgroundHover
    property color colText: Appearance.colors.colprimarytext
    property color colTextHovered: Appearance.colors.colprimarytext



    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onEntered: {
            if (root.onHovered) root.onHovered()
        }
        onExited: {
            if (root.onUnhovered) root.onUnhovered()
        }
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
        implicitHeight: parent.height

        topLeftRadius: root.buttonRadius > 0 ? 0 : root.buttonRadiusTopLeft
        topRightRadius: root.buttonRadius > 0 ? 0 : root.buttonRadiusTopRight
        bottomLeftRadius: root.buttonRadius > 0 ? 0 : root.buttonRadiusBottomLeft
        bottomRightRadius: root.buttonRadius > 0 ? 0 : root.buttonRadiusBottomRight

        color: mouseArea.containsMouse ? root.colBackgroundHover : root.colBackground

        Behavior on color {
            ColorAnimation {
                duration: 300
                easing.type: Easing.InOutQuad
            }
        }
    }
    contentItem: StyledText {
        text: root.buttonText
        color: mouseArea.containsMouse ? root.colTextHovered : root.colText
    }
}