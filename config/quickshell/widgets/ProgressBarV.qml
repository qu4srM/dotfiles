import qs.configs
import qs.widgets

import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

Item {
    id: root
    property string orientation: "vertical"
    property real value: 0.6
    property real progress: (root.implicitHeight - 10) * value
    property string colorMain: "white"
    property string colorBg: "green"
    property var motionAction
    property real radius: 10
    property real size: 16
    property string icon
    property bool rotateIcon: false

    implicitWidth: parent.width
    implicitHeight: parent.height 
    
    Item {
        id: content
        width: parent.implicitWidth - 10
        height: parent.implicitHeight - 10
        anchors.centerIn: parent
        VerticalSlider{}
        DragAreaSlider {
            id: verticalDragArea
            component: root
            axis: "y"
        }
        Loader{
            anchors.bottom: parent.bottom
            anchors.bottomMargin: (parent.width / 2) - 10
            anchors.horizontalCenter: parent.horizontalCenter
            active: root.icon
            sourceComponent: StyledMaterialSymbol {
                text: root.icon
                size: root.size
                color: Appearance.colors.colBackground
                fill: 1
                rotation: root.rotateIcon ? root.value * 360 : 0
                Behavior on rotation {
                    NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                }
            }
        }
        
    }

    // 🎯 MouseArea para cambiar el valor arrastrando en vertical
    /*
    MouseArea {
        id: dragArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onPressed: (mouse) => updateValue(mouse.y)
        onPositionChanged: (mouse) => {
            if (mouse.buttons & Qt.LeftButton)
                updateValue(mouse.y)
        }
        function updateValue(yPos) {
            let clamped = Math.max(0, Math.min(1, 1 - (yPos / root.height)));
            root.value = clamped;
            if (root.motionAction) root.motionAction(clamped);

        }   
    }*/
    component VerticalSlider: Item {
        width: content.width 
        height: content.height
        Rectangle {
            opacity: value >= 0.98 ? 0 : 1
            anchors.top: parent.top 
            anchors.topMargin: 4
            anchors.horizontalCenter: parent.horizontalCenter
            width: 4
            height: 4
            radius: Appearance.rounding.full
            z: 9999
            color: root.colorMain
        }
        Rectangle{
            id: end 
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                
            }
            implicitWidth: parent.width - 10
            implicitHeight: parent.height - progress - 8
            color: root.colorBg
            topLeftRadius: root.radius
            topRightRadius: root.radius

        }
        Item {
            implicitWidth: parent.width
            implicitHeight: 12
            y: parent.height - start.implicitHeight - 8 - 6
            Rectangle {
                implicitWidth: parent.width
                implicitHeight: verticalDragArea.containsPress ? 2 : 4
                anchors.verticalCenter: parent.verticalCenter
                radius: 10
                color: root.colorMain
            }
        }
        Rectangle{
            id: start
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                
            }
            implicitWidth: parent.width - 10
            implicitHeight: progress - 8
            color: root.colorMain
            bottomLeftRadius: root.radius
            bottomRightRadius: root.radius

        }

    }

}
