import qs
import qs.modules.background
import qs.modules.background.widgets
import qs.configs
import qs.widgets
import qs.utils
import qs.services

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland

Item {
    anchors.fill: parent

    property int cellSize: 130
    property int gap: 10

    GridLayout {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 46
        anchors.leftMargin: 10

        columns: 4
        rowSpacing: gap
        columnSpacing: gap

        

        Notion {
            Layout.row: 0
            Layout.column: 0
            Layout.columnSpan: 1
            Layout.rowSpan: 1

            Layout.preferredWidth: cellSize
            Layout.preferredHeight: cellSize
        }
        Gallery {
            Layout.row: 0
            Layout.column: 1
            Layout.columnSpan: 1
            Layout.rowSpan: 1

            Layout.preferredWidth: cellSize
            Layout.preferredHeight: cellSize
        }

        Todoist {
            Layout.row: 1
            Layout.column: 0
            Layout.columnSpan: 2

            Layout.preferredWidth: cellSize * 2 + gap
            Layout.preferredHeight: cellSize
        }

        Calendar {
            Layout.row: 2
            Layout.column: 0
            Layout.columnSpan: 2
            Layout.rowSpan: 2

            Layout.preferredWidth: cellSize * 2 + gap
            Layout.preferredHeight: cellSize * 2 + gap
        }
    }
}