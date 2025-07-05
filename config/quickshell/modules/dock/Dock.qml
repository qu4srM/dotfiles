import "root:/modules/bar/components/"
import "root:/modules/drawers/"
import "root:/widgets/"
import "root:/utils/"

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Hyprland

Rectangle {
    id: root
    required property ShellScreen screen
    required property real h
    property string pathIcons: "root:/assets/icons/"
    property string colorMain: "transparent"
    property string colorDock: "#000000"
    property string pathScripts: "~/.config/quickshell/scripts/"

    implicitHeight: h + 10
    implicitWidth: parent.width
    anchors.horizontalCenter: parent.horizontalCenter
    color: colorMain

    ListModel {
        id: appModel
    }

    Rectangle {
        id: dockContainer
        color: root.colorDock
        radius: 15
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        implicitHeight: root.h + 5
        implicitWidth: row.implicitWidth + 20

        Row {
            id: row
            anchors.centerIn: parent
            spacing: 10

            Repeater {
                model: appModel
                delegate: ButtonIcon {
                    iconSystem: model.icon + "-symbolic.svg"
                    command: model.icon
                    size: root.h - 10
                }
            }
        }
    }

    Process {
        id: fetchApps
        command: ["bash", "-c",
            "hyprctl clients -j | jq -r '.[].class' | sort | uniq | paste -sd '|' -"
        ]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                appModel.clear()
                const parts = this.text.trim().split("|")
                for (let i = 0; i < parts.length; ++i) {
                    const app = parts[i].trim()
                    if (app.length > 0) {
                        appModel.append({ icon: app })
                    }
                }
            }
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: fetchApps.running = true
    }

    Component.onCompleted: fetchApps.running = true
}
