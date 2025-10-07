import qs 
import qs.configs
import qs.services
import qs.widgets 
import qs.utils

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland

Item {
    id: root 
    property var iconList: []
    property real iconSize
    property real buttonRadius
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
    property color colText: Appearance.colors.colText
    property color colTextHovered: Appearance.colors.colprimarytext

    implicitHeight: grid.implicitHeight
    implicitWidth: grid.implicitWidth + 20

    Rectangle {
        id: background
        anchors.fill: parent
        color: mouseArea.containsMouse ? root.colBackgroundHover : root.colBackground 
        topLeftRadius: root.buttonRadius > 0 ? root.buttonRadius : root.buttonRadiusTopLeft
        topRightRadius: root.buttonRadius > 0 ? root.buttonRadius : root.buttonRadiusTopRight
        bottomLeftRadius: root.buttonRadius > 0 ? root.buttonRadius : root.buttonRadiusBottomLeft
        bottomRightRadius: root.buttonRadius > 0 ? root.buttonRadius : root.buttonRadiusBottomRight
        Behavior on color {
            ColorAnimation {
                duration: 300
                easing.type: Easing.InOutQuad
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent 
        hoverEnabled: true 
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onEntered: if (root.onHovered) root.onHovered()
        onExited: if (root.onUnhovered) root.onUnhovered()
        onPressed: (event) => { 
            if (event.button === Qt.RightButton) {
                if (root.altAction) root.altAction()
                return
            }
            if (event.button === Qt.MiddleButton) {
                if (root.middleClickAction) root.middleClickAction()
                return
            }
        }
        onReleased: (event) => {
            if (event.button != Qt.LeftButton) return
            if (root.releaseAction) root.releaseAction()
        }
    }

    GridLayout {
        id: grid
        anchors.centerIn: parent
        columns: root.iconList.length
        rowSpacing: 0
        columnSpacing: 5
        Repeater {
            model: root.iconList
            Loader {
                id: iconMaterialLoader 
                sourceComponent: StyledMaterialSymbol {
                    text: modelData
                    size: Appearance.font.pixelSize.normal
                    color: root.changeColor ? root.colTextHovered : root.colText
                    fill: 1
                }
            }
        }
    }
}
