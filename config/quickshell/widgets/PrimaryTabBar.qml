import qs
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
    required property var tabButtonList
    required property var externalTrackedTab
    signal currentIndexChanged(int index)
    Item {
        id: indicator
        anchors.horizontalCenter: parent.horizontalCenter
        implicitWidth: parent.width
        implicitHeight: 26
        clip: true
        Rectangle {
            id: indicatorItem
            property int tabCount: root.tabButtonList.length
            property real fullTabSize: parent.implicitWidth / tabCount;
            property real targetWidth: 50;
            
            anchors {
                top: parent.top
                bottom: parent.bottom
            }
            implicitWidth: targetWidth

            color: Appearance.colors.colSecondaryContainer
            radius: Appearance?.rounding.full ?? 9999
            x: tabBar.currentIndex * fullTabSize + (fullTabSize - targetWidth) / 2
        

            //Behavior on x {
            //    animation: Appearance?.animation.elementMove.numberAnimation.createObject(this)
            //}
            Behavior on x {
                NumberAnimation {
                    duration: Appearance.animationDurations.expressiveFastSpatial
                    easing.type: Appearance.animation.elementMove.type
                    easing.bezierCurve: Appearance.animationCurves.expressiveFastSpatial
                }
            }
        }
    }
    TabBar {
        id: tabBar
        anchors.horizontalCenter: parent.horizontalCenter
        currentIndex: root.externalTrackedTab
        onCurrentIndexChanged: {
            root.onCurrentIndexChanged(currentIndex)
        }
        background: Item {
            WheelHandler {
                onWheel: (event) => {
                    if (event.angleDelta.y < 0)
                        tabBar.currentIndex = Math.min(tabBar.currentIndex + 1, root.tabButtonList.length - 1)
                    else if (event.angleDelta.y > 0)
                        tabBar.currentIndex = Math.max(tabBar.currentIndex - 1, 0)
                }
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            }
        }
        Repeater {
            model: root.tabButtonList
            delegate: PrimaryTabButton {
                required property var modelData
                required property var index
                iconName: modelData.icon
                labelText: modelData.name
                count: root.tabButtonList.length
                active: root.externalTrackedTab === index ? true : false
                state: root.state
                implicitWidth: (root.width / root.tabButtonList.length)
                implicitHeight: 40
                anchors.top: parent.top
                anchors.topMargin: 4
            }
        }
    }
    
}
