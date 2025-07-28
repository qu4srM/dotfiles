import "root:/"
import "root:/modules/common/"
import "root:/modules/sidebar/"
import "root:/modules/bar/components/"
import "root:/modules/bar/popups/"
import "root:/modules/dashboard/"
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

    property Item currentItem: row.children[GlobalStates.currentTabDashboard]

    implicitWidth: flickable.implicitWidth + view.anchors.margins * 2
    implicitHeight: tabs.implicitHeight + tabs.anchors.topMargin + flickable.implicitHeight + view.anchors.margins * 2

    Tabs {
        id: tabs
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right 
        anchors.margins: 10
        animWidth: root.implicitWidth
    }
    ClippingRectangle {
        id: view
        anchors.top: tabs.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10

        radius: Appearance.rounding.normal
        color: "transparent"

        Flickable {
            id: flickable
            anchors.fill: parent
            flickableDirection: Flickable.HorizontalFlick
            clip: true
            implicitWidth: currentItem.implicitWidth
            implicitHeight: currentItem.implicitHeight
            contentWidth: row.implicitWidth
            contentHeight: row.implicitHeight

            contentX: row.children[GlobalStates.currentTabDashboard]?.x || 0

            onDragEnded: {
                const x = contentX - row.children[GlobalStates.currentTabDashboard].x;
                if (x > row.children[GlobalStates.currentTabDashboard].width / 10)
                    GlobalStates.currentTabDashboard = Math.min(GlobalStates.currentTabDashboard + 1, row.children.length - 1);
                else if (x < -row.children[GlobalStates.currentTabDashboard].width / 10)
                    GlobalStates.currentTabDashboard = Math.max(GlobalStates.currentTabDashboard - 1, 0);
                else
                    contentX = Qt.binding(() => row.children[GlobalStates.currentTabDashboard].x);
            }

            RowLayout {
                id: row
                Loader {
                    id: loader1
                    Layout.alignment: Qt.AlignTop
                    active: GlobalStates.currentTabDashboard === 0 ? true : false
                    anchors.fill: parent
                    sourceComponent: Dash {}
                }
                Loader {
                    id: loader2
                    Layout.alignment: Qt.AlignTop
                    active: GlobalStates.currentTabDashboard === 1 ? true : false
                    anchors.fill: parent
                    sourceComponent: Hack {}
                }
                Loader {
                    id: loader3
                    Layout.alignment: Qt.AlignTop
                    active: GlobalStates.currentTabDashboard === 2 ? true : false
                    anchors.fill: parent
                    sourceComponent: Media {}
                }
                Loader {
                    id: loader4
                    Layout.alignment: Qt.AlignTop
                    active: GlobalStates.currentTabDashboard === 3 ? true : false
                    anchors.fill: parent
                    sourceComponent: Performance {}
                }
            }
            Behavior on contentX {
                NumberAnimation {
                    duration: 400
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: [0.2, 0, 0, 1, 1, 1]
                }
            }
        }
    }
    Behavior on implicitWidth {
        NumberAnimation {
            duration: 600
            easing.type: Easing.BezierSpline
            easing.bezierCurve: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
        }
    }

    Behavior on implicitHeight {
        NumberAnimation {
            duration: 600
            easing.type: Easing.BezierSpline
            easing.bezierCurve: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
        }
    }

}