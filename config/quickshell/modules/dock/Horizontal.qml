import qs
import qs.configs
import qs.modules.dock
import qs.widgets
import qs.utils
import qs.services

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland


Rectangle {
    id: root
    required property Item area
    required property bool ready
    Layout.alignment: Qt.AlignHCenter
    implicitWidth: list.contentWidth + 10
    implicitHeight: area.height - 2
    radius: Appearance.rounding.small

    color: Config.options.bar.showBackground
        ? (Config.options.appearance.shapes.enable
            ? "transparent"
            : Appearance.colors.colBackground)
        : (Config.options.appearance.shapes.enable
            ? "transparent"
            : Colors.setTransparency(
                Appearance.colors.colglassmorphism, 0.7))

    border.width: 1
    border.color: '#18ffffff'
    ListView {
        id: list
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 6
        anchors.horizontalCenter: parent.horizontalCenter
        implicitWidth: contentWidth
        implicitHeight: parent.implicitHeight
        orientation: ListView.Horizontal
        model: ScriptModel {
            values: Apps.apps
        }

        Component.onCompleted: forceLayout()
        onCountChanged: Qt.callLater(() => forceLayout())
            
        delegate: DockItem {
            id: dockItem
            anchors.bottom: parent.bottom
            baseSize: list.height - 10

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
