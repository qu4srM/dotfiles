import qs
import qs.configs
import qs.modules.sidebarleft
import qs.modules.sidebarleft.study
import qs.modules.sidebarleft.hack
import qs.widgets 

import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

Item {
    id: root
    anchors.fill: parent

    property var tabButtonList: [
        { "icon": "dashboard", "name": Translation.tr("Dashboard") },
        { "icon": "book", "name": Translation.tr("Study") },
        { "icon": "deployed_code", "name": Translation.tr("Hacking") },
        { "icon": "queue_music", "name": Translation.tr("Media") },
        //{ "icon": "speed", "name": Translation.tr("Performance") }
    ]

    property int currentTab: Persistent.states.sidebarleft.currentTab

    function focusActiveItem() {
        stackLayout.currentItem.forceActiveFocus()
    }

    Rectangle {
        implicitWidth: parent.width
        implicitHeight: tabBar.implicitHeight
        topLeftRadius: Appearance.rounding.normal
        topRightRadius: Appearance.rounding.normal
        color: Appearance.colors.colSurfaceContainer
    }

    ColumnLayout {
        id: columnLayout
        anchors.fill: parent 
        anchors.margins: 10
        spacing: 0

        PrimaryTabBar {
            id: tabBar
            Layout.fillWidth: true
            Layout.leftMargin: 10
            implicitHeight: 60
            externalTrackedTab: root.currentTab
            tabButtonList: root.tabButtonList
            function onCurrentIndexChanged(currentIndex) {
                Persistent.states.sidebarleft.currentTab = currentIndex
            }
        }

        ClippingRectangle {
            id: view
            Layout.fillWidth: true 
            Layout.fillHeight: true
            radius: Appearance.rounding.normal
            color: "transparent"

            StackLayout {
                id: stackLayout
                anchors.fill: parent
                currentIndex: root.currentTab

                Dash { Layout.fillWidth: true; Layout.fillHeight: true }
                Study { Layout.fillWidth: true; Layout.fillHeight: true }
                Hack { Layout.fillWidth: true; Layout.fillHeight: true }
                Media { Layout.fillWidth: true; Layout.fillHeight: true }
            }
        }
    }
}
