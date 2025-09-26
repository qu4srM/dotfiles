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
    required property bool active
    background: null 
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onReleased: (event) => {
            root.click()
        }
    }
    contentItem: Item {
        anchors.centerIn: parent
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 4
            StyledMaterialSymbol {
                id: icon 
                Layout.alignment: Qt.AlignHCenter
                text: root.iconName
                color: root.active ? Appearance.colors.colPrimary : Appearance.colors.colOutline
                fill: root.active ? 1 : 0
                font.pointSize: Appearance.font.pixelSize.small
                Behavior on fill {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: [0.2, 0, 0, 1, 1, 1]
                    }
                }
            }

            StyledText {
                id: label
                Layout.alignment: Qt.AlignHCenter
                text: root.labelText
                font.pixelSize: 13
                color: root.active ? Appearance.colors.colPrimary : Appearance.colors.colOutline
            }
        }
    }
}