import qs 
import qs.configs
import qs.widgets 
import qs.utils
import qs.services

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

    implicitWidth: columnLayout.implicitWidth + 200
    implicitHeight: columnLayout.implicitHeight + 20
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter

    ColumnLayout {
        id: columnLayout
        anchors.fill: parent

        WallpapersList {
            Layout.alignment: Qt.AlignHCenter
            wallpapers: Wallpapers.allWallpapers
        }

        StyledText {
            id: textItem
            Layout.alignment: Qt.AlignHCenter
            text: `${Translation.tr("Wallpapers")} • ${Wallpapers.numItems}`
        }
    }
}
