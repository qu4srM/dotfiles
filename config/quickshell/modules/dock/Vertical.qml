import qs
import qs.configs
import qs.modules.dock
import qs.widgets
import qs.utils

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland


Rectangle {
    id: root
    required property Item area
    required property bool ready
    required property bool isLeft
    Layout.alignment: Qt.AlignVCenter
    implicitWidth: area.width - 2
    implicitHeight: list.contentHeight + 10
    radius: Appearance.rounding.small

    color: Config.options.bar.showBackground
        ? (Config.options.appearance.shapes.enable
            ? "transparent"
            : Appearance.colors.colBackground)
        : (Config.options.appearance.shapes.enable
            ? "transparent"
            : Colors.setTransparency(
                Appearance.colors.colglassmorphism, 0.95))

    RectangleRing {
        anchors.fill: parent
        radius: parent.radius
        source: ShaderEffectSource {
            anchors.fill: parent
            hideSource: true
            live: true
        }
    }
    ListView {
        id: list
        anchors.left: root.isLeft ? parent.left : undefined
        //anchors.right: root.isLeft ? undefined : parent.right
        anchors.margins: 6
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: parent.implicitWidth
        implicitHeight: contentHeight
        orientation: ListView.Vertical
        model: ScriptModel {
            values: Apps.apps
        }

        Component.onCompleted: forceLayout()
        onCountChanged: Qt.callLater(() => forceLayout())
            
        delegate: DockItem {
            anchors.left: root.isLeft ? parent.left : undefined
            //anchors.right: !root.isLeft ? parent.right : undefined
            baseSize: list.width - 10
            implicitWidth: baseSize * hoverScale
            implicitHeight: baseSize * hoverScale
        }
    }

    Magnification {
        anchors.fill: parent
        enabled: ready
        hoverEnabled: ready
        list: list
    }
}
