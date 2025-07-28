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

import "root:/"
import "root:/modules/common/"
import "root:/modules/sidebar/"
import "root:/modules/bar/components/"
import "root:/modules/bar/popups/"
import "root:/modules/dashboard/"
import "root:/modules/drawers/"
import "root:/widgets/"
import "root:/services/"
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
            text: `Wallpaper Selector • ${Wallpapers.numItems} encontrados`
        }
    }
}
