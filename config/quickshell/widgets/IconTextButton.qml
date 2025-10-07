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
    property bool toggle 
    property string buttonText 
    property string buttonIcon 
    property string command     
    property string commandText: "" 
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

    implicitHeight: rowLayout.implicitHeight
    implicitWidth: rowLayout.implicitWidth + 20

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

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: 4 

        StyledMaterialSymbol {
            text: root.buttonIcon
            size: Appearance.font.pixelSize.normal
            color: root.changeColor ? root.colTextHovered : root.colText
            fill: 0
        }

        StyledText {
            id: targetText
            text: root.buttonText ? root.buttonText : root.commandText
        }
    }

    Process {
        id: getText
        command: root.command ? [ "bash", "-c", root.command ] : []
        running: root.command !== ""

        stdout: StdioCollector {
            onStreamFinished: {
                root.commandText = this.text
            }
        }
    }

    Timer {
        interval: 1000
        running: root.command !== "" && !root.buttonText
        repeat: true
        onTriggered: getText.running = true
    }

    Component.onCompleted: {
        if (root.command && !root.buttonText)
            getText.running = true
    }
}
