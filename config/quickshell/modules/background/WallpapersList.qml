import "root:/"
import "root:/modules/common/"
import "root:/modules/bar/components/"
import "root:/modules/drawers/"
import "root:/modules/sidebar/"
import "root:/modules/background/"
import "root:/widgets/"
import "root:/utils/"

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import Quickshell.Io
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

PathView {
    id: root
    required property var wallpapers
    property int lastIndex: 0


    implicitWidth: 190 * 5
    implicitHeight: 140
    pathItemCount: 5
    cacheItemCount: 4
    snapMode: PathView.SnapToItem
    preferredHighlightBegin: 0.5
    preferredHighlightEnd: 0.5
    highlightRangeMode: PathView.StrictlyEnforceRange

    focus: true
    activeFocusOnTab: true
    Keys.priority: Keys.BeforeItem

    function next()  { currentIndex = (currentIndex + 1) % count }
    function prev()  { currentIndex = (currentIndex - 1 + count) % count }

    Keys.onLeftPressed:  { prev();  event.accepted = true }
    Keys.onRightPressed: { next();  event.accepted = true }

    Keys.onReturnPressed: {
        if (currentItem && currentItem.apply) {
            currentItem.apply();
            event.accepted = true;
        } else {
            const path = Paths.expandTilde(model[currentIndex]);
            Wallpapers.actualCurrent = path;
            Quickshell.execDetached([
                "bash", "-c",
                `echo "${Paths.strip(path)}" > ${Paths.strip(Wallpapers.currentNamePath)}`
            ])

        }
    }
    Keys.onEnterPressed: Keys.onReturnPressed(event)

    Component.onCompleted: {
        forceActiveFocus();
        const expandedList = wallpapers.map(w => Paths.expandTilde(w));
        const idx = expandedList.indexOf(Wallpapers.actualCurrent);
        if (idx !== -1)
            currentIndex = idx;
    }
    Component.onDestruction: {
        lastIndex = currentIndex;
    }

    model: root.wallpapers.map(w => w.path)

    delegate: WallpaperItem {
        id: wallpaper
    }

    path: Path {
        startY: root.height / 2
        PathAttribute { name: "z"; value: 0 }
        PathLine { x: root.width / 2; relativeY: 0 }
        PathAttribute { name: "z"; value: 1 }
        PathLine { x: root.width; relativeY: 0 }
    }
}
