import "root:/modules/bar/components/"
import "root:/modules/drawers/"
import "root:/widgets/"
import "root:/utils/"

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
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
    property string pinnedAppsPath: "~/.config/quickshell/utils/data/pinned_apps.json"

    ListModel { id: appModel }
    property var activeAppSet: new Set()
    property var activeAppCount: ({})

    implicitHeight: h
    implicitWidth: parent.width
    anchors.horizontalCenter: parent.horizontalCenter
    color: colorMain

    FileView {
        id: fileView
        path: pinnedAppsPath
        watchChanges: true
        onAdapterUpdated: writeAdapter()

        JsonAdapter {
            id: pinnedStore
            property list<string> pinnedApps: []
        }
    }

    Rectangle {
        id: dockContainer
        color: root.colorDock
        border.width: 1
        border.color: "#44ffffff"
        radius: 15
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        implicitHeight: root.h
        implicitWidth: row.implicitWidth + 6

        Row {
            id: row
            anchors.centerIn: parent
            spacing: 0

            // Apps fijadas
            Repeater {
                model: pinnedStore.pinnedApps
                delegate: Item {
                    width: root.h
                    height: root.h

                    ButtonIcon {
                        id: btn
                        anchors.horizontalCenter: parent.horizontalCenter
                        iconSystem: Icons.getIcon(modelData)
                        command: modelData
                        size: root.h - 10
                    }

                    Row {
                        spacing: 2
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom

                        Repeater {
                            model: Math.min(root.activeAppCount[modelData] || 0, 5)
                            delegate: Rectangle {
                                width: 3
                                height: 3
                                radius: 3
                                color: "#000753"
                            }
                        }
                    }
                }
            }
            Separator {
                implicitWidth: 6
                height: root.h

                Rectangle {
                    visible: appModel.count > 0 && pinnedStore.pinnedApps.length > 0
                    anchors.centerIn: parent
                    width: 2
                    height: parent.height - 10
                    color: "#000753"
                }

            }

            // Apps activas no fijadas
            Repeater {
                model: appModel
                delegate: Item {
                    width: root.h
                    height: root.h

                    ButtonIcon {
                        id: iconBtn
                        iconSystem: Icons.getIcon(modelData)
                        command: model.icon
                        size: root.h - 10
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        acceptedButtons: Qt.RightButton | Qt.LeftButton
                        onPressed: (mouse) => {
                            if (mouse.button === Qt.RightButton) {
                                const app = model.icon
                                const list = [...pinnedStore.pinnedApps]
                                if (!list.includes(app)) {
                                    list.push(app)
                                    pinnedStore.pinnedApps = list
                                }
                            }
                        }
                    }
                }
            }
        }
    }


    // Obtener apps activas y contarlas
    Process {
        id: fetchApps
        command: ["bash", "-c",
            "hyprctl clients -j | jq -r '.[].class' | sort | uniq -c | awk '{print $2\":\"$1}' | paste -sd '|' -"
        ]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                appModel.clear()
                const raw = this.text.trim()
                const parts = raw.split("|")

                let countMap = {}
                let classSet = new Set()

                for (let i = 0; i < parts.length; ++i) {
                    const entry = parts[i].trim()
                    const [className, countStr] = entry.split(":")
                    const count = parseInt(countStr)
                    if (!className) continue

                    classSet.add(className)
                    countMap[className] = count

                    if (!pinnedStore.pinnedApps.includes(className)) {
                        appModel.append({ icon: className })
                    }
                }

                root.activeAppSet = classSet
                root.activeAppCount = countMap
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
