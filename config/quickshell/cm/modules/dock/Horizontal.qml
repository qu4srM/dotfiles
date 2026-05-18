import qs
import qs.configs
import qs.configs.utils
import qs.modules.dock
import qs.widgets
import qs.services

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland


DiagonalContainer {
    id: root
    required property Item area
    required property bool ready
    Layout.alignment: Qt.AlignHCenter
    implicitWidth: list.contentWidth + 10
    implicitHeight: area.height - 2
    cornerSize: Appearance.rounding.small

    color: Config.options.bar.showBackground
        ? (Config.options.appearance.shapes.enable
            ? "transparent"
            : Appearance.colors.colBackground)
        : (Config.options.appearance.shapes.enable
            ? "transparent"
            : Appearance.colors.colGlass)

    borderWidth: 1
    borderColor: Appearance.colors.colGlassBorder
    clip: false
    ListView {
        id: list
        anchors.bottom: parent ? parent.bottom : undefined
        anchors.bottomMargin: 6
        anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
        implicitWidth: contentWidth
        implicitHeight: parent.implicitHeight
        orientation: ListView.Horizontal
        interactive: false
        model: ScriptModel { values: Apps.apps }
        
            
        delegate: DockItem {
            id: dockItem
            anchors.bottom: parent ? parent.bottom : undefined
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
