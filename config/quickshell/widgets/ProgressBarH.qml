import qs.configs

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import Quickshell.Io
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

Item {
    id: root
    property string orientation: "horizontal"
    property real value: 0.6
    property real progress: (root.implicitWidth - 10) * value
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
        HorizontalSlider {}
        DragAreaSlider {
            id: horizontalDragArea
            component: root
            axis: "x"
        }
        Loader{
            anchors.left: parent.left
            anchors.leftMargin: (parent.height / 2) - 10
            anchors.verticalCenter: parent.verticalCenter
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
    component HorizontalSlider: Item {
        width: content.width 
        height: content.height

        Rectangle{
            id: start
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                
            }
            implicitWidth: progress - 8
            implicitHeight: parent.height - 10
            color: root.colorMain
            topLeftRadius: root.radius
            bottomLeftRadius: root.radius
        }

        Item {
            implicitWidth: 12
            implicitHeight: parent.height
            x: start.implicitWidth + 8 - 6
            Rectangle {
                implicitWidth: horizontalDragArea.containsPress ? 2 : 4
                implicitHeight: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                radius: 10
                color: root.colorMain
            }
        }

        Rectangle{
            id: end 
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
                
            }
            implicitWidth: parent.width - progress - 8
            implicitHeight: parent.height - 10
            color: root.colorBg
            topRightRadius: root.radius
            bottomRightRadius: root.radius

        }

        Rectangle {
            opacity: value >= 0.98 ? 0 : 1
            anchors.right: parent.right 
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            width: 4
            height: 4
            radius: Appearance.rounding.full
            z: 9999
            color: root.colorMain
        }
    }
}
