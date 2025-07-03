import QtQuick
import Quickshell
import QtQuick.Effects


Item {
    id: root
    implicitWidth: 250
    implicitHeight: implicitHeightRect
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter

    property real implicitWidthRect: 180
    property real implicitHeightRect: 24
    property real widthRect: 40
    property real heightRect: 10
    property int margin: -5
    property string themeColorRect: "#ffffff"
    property string themeColorMain: "#975f5f"


    Rectangle {
        id: rect
        implicitWidth: root.implicitWidthRect
        implicitHeight: root.implicitHeightRect
        anchors.centerIn: parent
        color: root.themeColorMain
        visible: true
        radius: 10
    }


    Rectangle {
        id: rectleft
        implicitWidth: root.widthRect
        implicitHeight: root.heightRect
        color: root.themeColorRect
        visible: false
    }

    Item {
        id: maskleft
        implicitWidth: root.widthRect
        implicitHeight: root.heightRect
        layer.enabled: true
        visible: false
        Rectangle {
            implicitWidth: 50
            implicitHeight: 50
            radius: 10
            x: -20
        }
    }

    MultiEffect {
        implicitWidth: root.widthRect
        implicitHeight: root.heightRect
        anchors.left: parent.left
        anchors.leftMargin: -root.margin
        maskEnabled: true
        maskInverted: true
        maskSource: maskleft
        source: rectleft
        maskThresholdMin: 0.5
        maskSpreadAtMin: 1
    }

    Rectangle {
        id: rectright
        implicitWidth: root.widthRect
        implicitHeight: root.heightRect
        color: root.themeColorRect
        visible: false
    }

    Item {
        id: maskright
        implicitWidth: root.widthRect
        implicitHeight: root.heightRect
        layer.enabled: true
        visible: false
        Rectangle {
            implicitWidth: 50
            implicitHeight: 50
            radius: 10
            x: 10
        }
    }

    MultiEffect {
        implicitWidth: root.widthRect
        implicitHeight: root.heightRect
        anchors.right: parent.right
        anchors.rightMargin: -root.margin
        maskEnabled: true
        maskInverted: true
        maskSource: maskright
        source: rectright
        maskThresholdMin: 0.5
        maskSpreadAtMin: 1
    }

}


