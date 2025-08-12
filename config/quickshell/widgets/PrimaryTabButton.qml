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

TabButton {
    id: root
    required property string iconName
    required property string labelText
    required property int count
    readonly property bool current: TabBar.tabBar.currentItem === this
    background: null
    CustomMouseArea {
        id: mouseArea 
        anchors.fill: parent 
        cursorShape: Qt.PointingHandCursor

        onPressed: event => {
            GlobalStates.currentTabDashboard = root.TabBar.index
        }
        function onWheel(event: WheelEvent): void {
            if (event.angleDelta.y < 0)
                GlobalStates.currentTabDashboard = Math.min(GlobalStates.currentTabDashboard + 1, root.count- 1);
            else if (event.angleDelta.y > 0)
                GlobalStates.currentTabDashboard = Math.max(GlobalStates.currentTabDashboard - 1, 0);
        }
    }
    contentItem: Item {
        anchors.centerIn: parent
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 0
            StyledMaterialSymbol {
                id: icon
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.iconName
                color: root.current ? Appearance.colors.colprimary_hover : Appearance.colors.colprimaryicon
                fill: root.current ? 1 : 0
                font.pointSize: Appearance.font.size.large

                Behavior on fill {
                    NumberAnimation {
                        duration: 400
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: [0.2, 0, 0, 1, 1, 1]
                    }
                }
            }

            StyledText {
                id: label
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.labelText
                color: root.current ? Appearance.colors.colprimary_hover : Appearance.colors.colprimaryicon
            }
        }
    }
}