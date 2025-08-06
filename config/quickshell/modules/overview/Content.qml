import "root:/"
import "root:/modules/common/"
import "root:/modules/sidebar/"
import "root:/modules/bar/components/"
import "root:/modules/drawers/"
import "root:/modules/overview/"
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


Item {
    id: root 
    required property var styledWindow
    implicitWidth: columnLayout.implicitWidth
    implicitHeight: columnLayout.implicitHeight

    ColumnLayout {
        id: columnLayout
        anchors.top: parent.top 
        anchors.horizontalCenter: parent.horizontalCenter
        Keys.onPressed: event => {
            if (event.key === Qt.Key_Escape) {
                GlobalStates.overviewOpen = false;
            } 
        }

         OverviewWidget {
            styledWindow: root.styledWindow
        }
    }
    /*
          

    GlobalShortcut {
        name: "overviewToggle"
        description: "Toggles overview on press"
        onPressed: GlobalStates.overviewOpen = !GlobalStates.overviewOpen;
    }

    GlobalShortcut {
        name: "overviewOpen"
        description: "Opens overview on press"
        onPressed: GlobalStates.overviewOpen = true;
    }

    GlobalShortcut {
        name: "overviewClose"
        description: "Closes overview on press"
        onPressed: GlobalStates.overviewOpen = false;
    }
    */
}