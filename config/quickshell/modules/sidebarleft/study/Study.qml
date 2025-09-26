import qs
import qs.configs
import qs.modules.sidebarleft
import qs.modules.sidebarleft.study
import qs.utils 
import qs.widgets
import qs.services

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
    property int currentTab: 0
    property var tabButtonList: [
        {"name": Translation.tr("Pomodoro"), "icon": "search_activity"},
        {"name": Translation.tr("Stopwatch"), "icon": "timer"}
    ]
    property var taskList: Todo.list
                    .map(function(item, i) { return Object.assign({}, item, {originalIndex: i}); })
                    .filter(function(item) { return !item.done; })

    ColumnLayout {
        anchors.fill: parent 
        spacing: 10
        TimersItem {
            Layout.fillWidth: true
            implicitHeight: collapsed ? 360 : 40
        }
        TodoItem {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
