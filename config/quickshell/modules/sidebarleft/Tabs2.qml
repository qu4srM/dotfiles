import qs
import qs.configs
import qs.modules.sidebarleft 
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
    property real animWidth
    required property var tabButtonList
    //required property var externalTrackedTab
    signal currentIndexChanged(int index)
    Item {
        id: indicator
        anchors.top: parent.top 
        anchors.topMargin: 3
        anchors.horizontalCenter: parent.horizontalCenter
        implicitWidth: 80 * root.tabButtonList.length
        implicitHeight: 24
        clip: true
        Rectangle {
            id: indicatorItem
            property int tabCount: root.tabButtonList.length
            property real fullTabSize: parent.implicitWidth / tabCount;
            property real targetWidth: 40;
            anchors {
                top: parent.top
                bottom: parent.bottom
            }
            implicitWidth: targetWidth

            color: Appearance.colors.colSecondaryContainer
            radius: Appearance?.rounding.full ?? 9999
            x: tabBar.currentIndex * fullTabSize + (fullTabSize - targetWidth) / 2
        

            Behavior on x {
                animation: Appearance?.animation.elementMove.numberAnimation.createObject(this)
            }

            Behavior on implicitWidth {
                animation: Appearance?.animation.elementMove.numberAnimation.createObject(this)
            }
        }
    }
    TabBar {
        id: tabBar
        anchors.horizontalCenter: parent.horizontalCenter
        Layout.fillWidth: true
        spacing: 0
        currentIndex: GlobalStates.currentTabDashboard
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
                iconName: modelData.icon
                labelText: modelData.name
                count: root.tabButtonList.length
                implicitWidth: 80
                implicitHeight: 50
            }
        }
    }
    
}
