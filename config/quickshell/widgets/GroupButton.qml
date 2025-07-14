
import "root:/services/"
import "root:/modules/common/"
import "root:/widgets/"


import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Button {
    id: root

    property string buttonText: "Hola"
    property bool toggle

    property var downAction 
    property var releaseAction 
    property var altAction 
    property var middleClickAction 

    implicitWidth: 100
    implicitHeight: 20

    MouseArea {
        anchors.fill: parent
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
            root.click() // Because the MouseArea already consumed the event
        }
        onCanceled: (event) => {
            root.down = false
        }
    }
    background: Rectangle {
        id: btnBackground
        implicitHeight: ṕarent.height
        topLeftRadius: 10
        topRightRadius: 10
        bottomLeftRadius: 10
        bottomRightRadius: 10
    }
    contentItem: Text {
        text: root.buttonText
    }
}
