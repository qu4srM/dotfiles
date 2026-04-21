import qs 
import qs.configs
import qs.services
import qs.widgets 

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

Item {
    id: root 
    property real batteryLevel: BatteryData.batteryLevel
    property bool isCharging: BatteryData.isCharging
    property bool isLow: batteryLevel < 0.2
    property bool showIcon: isCharging || isLow
    property color fillColor: batteryLevel > 0.2 ? (isCharging ? Appearance.colors.colPrimary : Appearance.colors.colprimarytext) : "red"
    
    implicitWidth: showIcon ? 55 : 40
    implicitHeight: parent.height

    Behavior on implicitWidth  {
        animation: Appearance?.animation.elementMove.numberAnimation.createObject(this)
    }
    Rectangle {
        id: background
        anchors.fill: parent
        color: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : Appearance.colors.colGlass
        radius: Appearance.rounding.full
    }
    ClippingRectangle {
        anchors.fill: parent 
        color: "transparent"
        radius: height
        Rectangle {
            implicitWidth: Math.floor(root.batteryLevel * parent.width)
            implicitHeight: parent.height 
            color: root.fillColor
            Behavior on implicitWidth {
                animation: Appearance?.animation.elementMove.numberAnimation.createObject(this)
            }
        }
    }
    Item {
        anchors.centerIn: parent
        width: icon.width + text.implicitWidth
        height: icon.size + 2

        
        StyledMaterialSymbol {
            id: icon
            anchors.left: parent.left
            visible: root.showIcon
            width: visible ? size : 0
            text: root.isCharging ? "bolt" : "exclamation"
            size: 16
            color: Config.options.bar.showBackground ? Appearance.colors.colText : Appearance.colors.colOnText
            fill: 1
        }
        StyledText {
            id: text
            anchors.right: parent.right
            text: BatteryData.batteryLevelStr
            font.weight: Font.Bold
            font.pixelSize: 16
            color: Config.options.bar.showBackground ? Appearance.colors.colText : Appearance.colors.colOnText
        }

        
    }

}