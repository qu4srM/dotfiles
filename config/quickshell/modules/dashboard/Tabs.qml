import "root:/"
import "root:/modules/common/"
import "root:/modules/sidebar/"
import "root:/modules/bar/components/"
import "root:/modules/bar/popups/"
import "root:/modules/drawers/"
import "root:/widgets/"
import "root:/utils/"

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
    required property real animWidth
    readonly property alias count: navBar.count

    implicitHeight: navBar.implicitHeight + indicator.implicitHeight + indicator.anchors.topMargin + 2

    TabBar {
        id: navBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        spacing: 20
        currentIndex: GlobalStates.currentTabDashboard
        background: null

        Tab {
            iconName: "dashboard"
            text: qsTr("Dashboard")
        }
        Tab {
            iconName: "deployed_code"
            text: qsTr("Hacking")
        }
        Tab {
            iconName: "queue_music"
            text: qsTr("Media")
        }
        Tab {
            iconName: "speed"
            text: qsTr("Performance")
        }
    }

    Item {
        id: indicator
        anchors.top: navBar.bottom
        anchors.topMargin: 4
        implicitWidth: navBar.currentItem ? navBar.currentItem.implicitWidth : 0
        implicitHeight: 2
        x: {
            const tab = navBar.currentItem;
            const width = (root.animWidth - navBar.spacing * (root.count - 1)) / root.count;
            const index = navBar.currentIndex;
            const extraOffset = index * navBar.spacing;

            return extraOffset + width * index + (width - tab.implicitWidth) / 2;

        }
        clip: true


        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            implicitHeight: parent.implicitHeight * 2
            color: Appearance.colors.colprimary_hover
            radius: 2
        }

        Behavior on x {
            NumberAnimation {
                duration: 400
                easing.type: Easing.BezierSpline
                easing.bezierCurve: [0.2, 0, 0, 1, 1, 1]
            }
        }

        Behavior on implicitWidth {
            NumberAnimation {
                duration: 400
                easing.type: Easing.BezierSpline
                easing.bezierCurve: [0.2, 0, 0, 1, 1, 1]
            }
        }
    }
    Separator {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: indicator.bottom

        implicitHeight: 1
        color: "white"
    }
    component Tab: TabButton {
        id: tab
        required property string iconName
        readonly property bool current: TabBar.tabBar.currentItem === this
        background: null
        contentItem: CustomMouseArea {
            id: mouseArea
            implicitWidth: Math.max(icon.width, label.width)
            implicitHeight: icon.height + label.height
            cursorShape: Qt.PointingHandCursor

            onPressed: event => {
                GlobalStates.currentTabDashboard = tab.TabBar.index
            }
            function onWheel(event: WheelEvent): void {
                if (event.angleDelta.y < 0)
                    GlobalStates.currentTabDashboard = Math.min(GlobalStates.currentTabDashboard + 1, root.count - 1);
                else if (event.angleDelta.y > 0)
                    GlobalStates.currentTabDashboard = Math.max(GlobalStates.currentTabDashboard - 1, 0);
            }
        }
        StyledMaterialSymbol {
            id: icon

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: label.top

            text: tab.iconName
            color: tab.current ? Appearance.colors.colprimary_hover : Appearance.colors.colprimaryicon
            fill: tab.current ? 1 : 0
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
            anchors.bottom: parent.bottom

            text: tab.text
            color: tab.current ? Appearance.colors.colprimary_hover : Appearance.colors.colprimaryicon
        }
    }

}
