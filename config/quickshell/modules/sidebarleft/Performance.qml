import "root:/"
import "root:/modules/common/"
import "root:/modules/sidebar/"
import "root:/modules/bar/components/"
import "root:/modules/bar/popups/"
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


Item {
    id: root
    implicitWidth: grid.implicitWidth
    implicitHeight: parent.height

    GridLayout {
        id: grid
        columns: 1
        rowSpacing: 8
        columnSpacing: 8
        anchors.margins: 8

        implicitWidth: (
            col0.implicitWidth +
            col1.implicitWidth +
            col2.implicitWidth +
            col3.implicitWidth +
            columnSpacing * 3 + // espacios entre columnas
            anchors.margins * 2
        )
        implicitHeight: Math.max(
            col0.implicitHeight,
            col1.implicitHeight,
            col2.implicitHeight,
            col3.implicitHeight
        ) + anchors.margins * 2

        // RAM
        Rect {
            id: col0
            Layout.row: 0
            Layout.column: 0
            Layout.preferredWidth: 120
            Layout.preferredHeight: 140
            color: Appearance.colors.colsecondary

            Column {
                anchors.fill: parent

                StyledText {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.margins: 8
                    text: "Ram"
                    color: "white"
                }

                CircularProgress {
                    anchors.centerIn: parent
                    value: 0.5
                    w: 90
                    h: 90
                    strokeWidth: 6
                }
            }

            StyledText {
                anchors.centerIn: parent
                text: "5.4GiB"
                color: "white"
                font.pixelSize: 20
            }
        }

        // Storage
        Rect {
            id: col1
            Layout.row: 0
            Layout.column: 1
            Layout.preferredWidth: 120
            Layout.preferredHeight: 140
            color: Appearance.colors.colsecondary

            Column {
                anchors.fill: parent

                StyledText {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.margins: 8
                    text: "Storage"
                    color: "white"
                }

                CircularProgress {
                    anchors.centerIn: parent
                    value: 0.5
                    w: 90
                    h: 90
                    strokeWidth: 6
                }
            }

            StyledText {
                anchors.centerIn: parent
                text: "229GiB"
                color: "white"
                font.pixelSize: 20
            }
        }

        // CPU
        Rect {
            id: col2
            Layout.row: 0
            Layout.column: 2
            Layout.preferredWidth: 120
            Layout.preferredHeight: 140
            color: Appearance.colors.colsecondary

            Column {
                anchors.fill: parent

                StyledText {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.margins: 8
                    text: "CPU"
                    color: "white"
                }

                CircularProgress {
                    anchors.centerIn: parent
                    value: 0.5
                    w: 90
                    h: 90
                    strokeWidth: 6
                }
            }

            StyledText {
                anchors.centerIn: parent
                text: "41°C"
                color: "white"
                font.pixelSize: 20
            }
        }

        // GPU
        Rect {
            id: col3
            Layout.row: 0
            Layout.column: 3
            Layout.preferredWidth: 120
            Layout.preferredHeight: 140
            color: Appearance.colors.colsecondary

            Column {
                anchors.fill: parent

                StyledText {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.margins: 8
                    text: "GPU"
                    color: "white"
                }

                CircularProgress {
                    anchors.centerIn: parent
                    value: 0.5
                    w: 90
                    h: 90
                    strokeWidth: 6
                }
            }

            StyledText {
                anchors.centerIn: parent
                text: "41°C"
                color: "white"
                font.pixelSize: 20
            }
        }

        component Rect: Rectangle {
            radius: Appearance.rounding.small
        }
    }
}
