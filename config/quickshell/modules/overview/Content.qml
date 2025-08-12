import qs 
import qs.configs
import qs.modules.overview
import qs.widgets 
import qs.utils

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
        Item {
            height: 1 // Prevent Wayland protocol error
            width: 1 // Prevent Wayland protocol error
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