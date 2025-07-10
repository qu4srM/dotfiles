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



Scope {
    id: root
    Variants {
        model: Quickshell.screens
        StyledWindow {
            id: dock
            required property ShellScreen screen
            screen: screen
            name: "dock"
            color: "transparent"
            anchors {
                bottom: true
                left: true
                right: true
            }
            property string pathIcons: "root:/assets/icons/"
            property string colorMain: "transparent"
            property string colorDock: "#29141414"
            property string pathScripts: "~/.config/quickshell/scripts/"
            property string pinnedAppsPath: "~/.config/quickshell/utils/data/pinned_apps.json"

            ListModel { id: appModel }
            property var activeAppSet: new Set()
            property var activeAppCount: ({})


            implicitHeight: 40

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
                color: dock.colorDock
                border.width: 1
                border.color: "#445b5b5b"
                radius: 15
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                implicitHeight: dock.implicitHeight
                implicitWidth: row.implicitWidth + 6

                Row {
                    id: row
                    anchors.centerIn: parent
                    spacing: 0

                    // Apps fijadas
                    Repeater {
                        model: pinnedStore.pinnedApps
                        delegate: Item {
                            width: dock.implicitHeight
                            height: dock.implicitHeight

                            ButtonIcon {
                                id: btn
                                anchors.horizontalCenter: parent.horizontalCenter
                                iconSystem: Icons.getIcon(modelData)
                                command: modelData
                                size: dock.implicitHeight - 12
                                //hoverItem: tooltip
                            }

                            Rectangle {
                                visible: false
                                id: tooltip
                                color: "#a5141414"
                                width: tooltipText.width + 20
                                height: 20
                                anchors.horizontalCenter: parent.horizontalCenter
                                radius: 10
                                y: -0

                                Text {
                                    id: tooltipText
                                    anchors.centerIn: parent
                                    text: modelData
                                    color: "white"
                                    font.family: "Roboto"
                                    font.pixelSize: 12
                                    font.weight: Font.Medium
                                }
                            }

                            Row {
                                spacing: 2
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 2

                                Repeater {
                                    model: Math.min(dock.activeAppCount[modelData] || 0, 5)
                                    delegate: Rectangle {
                                        width: 3
                                        height: 3
                                        radius: 3
                                        color: "#55677D"
                                    }
                                }
                            }
                        }
                    }
                    Separator {
                        implicitWidth: 10
                        height: dock.implicitHeight

                        Rectangle {
                            visible: appModel.count > 0 && pinnedStore.pinnedApps.length > 0
                            anchors.centerIn: parent
                            width: 2
                            height: parent.height - 10
                            color: "#55677D"
                        }

                    }

                    // Apps activas no fijadas
                    Repeater {
                        model: appModel
                        delegate: Item {
                            width: dock.implicitHeight
                            height: dock.implicitHeight

                            ButtonIcon {
                                id: iconBtn
                                iconSystem: Icons.getIcon(modelData)
                                command: model.icon
                                size: dock.implicitHeight - 10
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
    }
}
