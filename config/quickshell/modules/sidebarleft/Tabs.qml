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

ColumnLayout {
    id: root
    spacing: 0
    required property real animWidth
    required property var tabButtonList
    signal currentIndexChanged(int index)
    implicitWidth: Math.max(tabBar.implicitWidth, 600)

    TabBar {
        id: tabBar
        Layout.fillWidth: true
        spacing: 0
        currentIndex: GlobalStates.currentTabDashboard
        onCurrentIndexChanged: {
            root.onCurrentIndexChanged(currentIndex)
        }
        background: null
        Repeater {
            model: root.tabButtonList
            delegate: PrimaryTabButton {
                required property var modelData
                iconName: modelData.icon
                labelText: modelData.name
                count: root.tabButtonList.length
                implicitWidth: 120 
                implicitHeight: 50
            }
        }
    }
    Item {
        id: indicator
        Layout.fillWidth: true
        implicitHeight: 3
        /*
        x: {
            const tab = navBar.currentItem;
            const width = (root.animWidth - navBar.spacing * (root.count - 1)) / root.count;
            const index = navBar.currentIndex;
            const extraOffset = index * navBar.spacing;

            return extraOffset + width * index + (width - tab.implicitWidth) / 2;

        }
        */
        clip: true


        Rectangle {
            id: indicatorItem
            property int tabCount: root.tabButtonList.length
            property real fullTabSize: root.width / tabCount;
            //property real targetWidth: tabBar.contentItem?.children[0]?.children[tabBar.currentIndex]?.tabContentWidth ?? 0
            property real targetWidth: (root.animWidth - tabBar.spacing * (tabCount - 1)) / tabCount;
            anchors {
                top: parent.top
                bottom: parent.bottom
            }
            implicitWidth: targetWidth
            //implicitWidth: tabBar.currentItem.implicitWidth

            color: Appearance.colors.colprimary_hover
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
    Rectangle {
        id: tabBarBottomBorder
        Layout.fillWidth: true
        implicitHeight: 1
        color: "white"
    }
}
