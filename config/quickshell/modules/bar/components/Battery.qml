import qs 
import qs.configs
import qs.services
import qs.widgets 

import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
    id: root 
    property real batteryLevel: BatteryData.batteryLevel
    property bool isCharging: BatteryData.isCharging
    property color fillColor: batteryLevel > 0.2 ? (isCharging ? Appearance.colors.colPrimary : Appearance.colors.colprimarytext) : "red"
    
    Layout.alignment: Qt.AlignVCenter
    implicitWidth: isCharging ? 50 : 40
    implicitHeight: parent.height

    Behavior on implicitWidth  {
        animation: Appearance?.animation.elementMove.numberAnimation.createObject(this)
    }
    Rectangle {
        id: background
        anchors.fill: parent
        color: Appearance.colors.colOnSecondary
        radius: Appearance.rounding.full
    }
    Rectangle {
        id: fillBar
        anchors.verticalCenter: parent.verticalCenter
        width: Math.floor(root.batteryLevel * parent.width)
        height: parent.height
        color: root.fillColor
        topLeftRadius: Appearance.rounding.full
        bottomLeftRadius: Appearance.rounding.full
        topRightRadius: Math.max(0, Math.min(1, (root.batteryLevel - 0.88) / (0.99 - 0.88))) * Math.min(fillBar.height / 2, fillBar.width / 2)
        bottomRightRadius: Math.max(0, Math.min(1, (root.batteryLevel - 0.88) / (0.99 - 0.88))) * Math.min(fillBar.height / 2, fillBar.width / 2)

        Behavior on width {
            animation: Appearance?.animation.elementMove.numberAnimation.createObject(this)
        }
    }

    Loader {
        id: rowLayout 
        anchors.centerIn: parent
        active: root.isCharging || root.batteryLevel <= 0.2
        sourceComponent: RowLayout {
            spacing: 0
            StyledMaterialSymbol {
                text: root.isCharging ? "bolt" : "exclamation"
                size: 16
                color: Appearance.colors.colBackground
                fill: 1
            }
            StyledText {
                font.weight: Font.Bold
                color: Appearance.colors.colBackground
                text: BatteryData.batteryLevelStr
            }
        }
    }
    Loader {
        anchors.centerIn: parent
        active: !rowLayout.active
        sourceComponent: StyledText {
            font.weight: Font.Bold
            color: Appearance.colors.colBackground
            text: BatteryData.batteryLevelStr
        } 
    }
}