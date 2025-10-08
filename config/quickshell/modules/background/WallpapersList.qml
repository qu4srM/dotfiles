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

PathView {
    id: root
    required property var wallpapers
    property int lastIndex: 0

    implicitWidth: 120 * 7
    implicitHeight: 100
    pathItemCount: 7
    cacheItemCount: 6
    snapMode: PathView.SnapToItem
    preferredHighlightBegin: 0.5
    preferredHighlightEnd: 0.5
    highlightRangeMode: PathView.StrictlyEnforceRange

    focus: true
    activeFocusOnTab: true
    Keys.priority: Keys.BeforeItem

    function changeBackground (path: string): void {
        //Config.options.background.wallpaperPath = Paths.strip(path);
        //Wallpapers.updateOverlay(`${Paths.strip(Paths.cache)}/quickshell/overlay/${Paths.getName(Config.options.background.wallpaperPath)}`)
    }

    function next()  { currentIndex = (currentIndex + 1) % count }
    function prev()  { currentIndex = (currentIndex - 1 + count) % count }

    Keys.onLeftPressed: (event) => {
        prev();
        event.accepted = true;
    }

    Keys.onRightPressed: (event) => {
        next();
        event.accepted = true;
    }

    Keys.onReturnPressed: (event) => {
        if (currentItem && currentItem.apply) {
            currentItem.apply();
            event.accepted = true;
        } else {
            const path = Paths.expandTilde(model[currentIndex]);
            changeBackground(path)
            event.accepted = true;
        }
    }

    Keys.onEnterPressed: (event) => Keys.onReturnPressed(event)
    /*
    Component.onCompleted: {
        forceActiveFocus();
        const expandedList = wallpapers.map(w => Paths.expandTilde(w));
        const idx = expandedList.indexOf(Paths.strip(Config.options.background.wallpaperPath));
        if (idx !== -1)
            currentIndex = idx;
    }*/

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
    Connections {
        target: GlobalStates ?? null
        function onWallSelectorOpenChanged() {
            if (GlobalStates?.wallSelectorOpen)
                root.forceActiveFocus()
        }
    }
}
