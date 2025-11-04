import qs 
import qs.configs
import qs.modules.overview
import qs.widgets 
import qs.services

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

Item {
    id: root
    required property var styledWindow
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(styledWindow.screen)
    readonly property var toplevels: ToplevelManager.toplevels
    readonly property int workspacesShown: 2 * 5
    readonly property int workspaceGroup: Math.floor(((monitor?.activeWorkspace?.id ?? 1) - 1) / workspacesShown)
    property bool monitorIsFocused: (Hyprland.focusedMonitor?.name == monitor?.name)
    property var windows: HyprlandData.windowList
    property var windowByAddress: HyprlandData.windowByAddress
    property var windowAddresses: HyprlandData.addresses
    property var monitorData: HyprlandData.monitors.find(m => m.id === root.monitor?.id)
    property real scale: 0.14
    property color activeBorderColor: Appearance.colors.colsecondary

    property real workspaceImplicitWidth: (monitorData?.transform % 2 === 1) ? 
        ((monitor?.height ?? 0 - (monitorData?.reserved[0] ?? 0) - (monitorData?.reserved[2] ?? 0)) * root.scale / (monitor?.scale ?? 1)) :
        ((monitor?.width ?? 0 - (monitorData?.reserved[0] ?? 0) - (monitorData?.reserved[2] ?? 0)) * root.scale / (monitor?.scale ?? 1))
    property real workspaceImplicitHeight: (monitorData?.transform % 2 === 1) ? 
        ((monitor?.width ?? 0 - (monitorData?.reserved[1] ?? 0) - (monitorData?.reserved[3] ?? 0)) * root.scale / (monitor?.scale ?? 1)) :
        ((monitor?.height ?? 0 - (monitorData?.reserved[1] ?? 0) - (monitorData?.reserved[3] ?? 0)) * root.scale / (monitor?.scale ?? 1))

    property real workspaceNumberMargin: 80
    property real workspaceNumberSize: Math.min(workspaceImplicitHeight, workspaceImplicitWidth) * (monitor?.scale ?? 1)
    property int workspaceZ: 0
    property int windowZ: 1
    property int windowDraggingZ: 99999
    property real workspaceSpacing: 5

    property int draggingFromWorkspace: -1
    property int draggingTargetWorkspace: -1

    property Component windowComponent: OverviewWindow {}
    property list<OverviewWindow> windowWidgets: []

    implicitWidth: overviewBackground.implicitWidth + overviewBackground.padding * 2
    implicitHeight: overviewBackground.implicitHeight + overviewBackground.padding * 2

    Rectangle {
        id: overviewBackground
        property real padding: 10
        anchors.fill: parent
        anchors.margins: 10

        implicitWidth: workspaceColumnLayout.implicitWidth + padding * 2
        implicitHeight: workspaceColumnLayout.implicitHeight + padding * 2
        color: "transparent"
    
        ColumnLayout {
            id: workspaceColumnLayout
            z: 0 
            anchors.centerIn: parent
            spacing: root.workspaceSpacing
            Repeater {
                model: 2
                delegate: RowLayout {
                    id: row
                    property int rowIndex: index
                    spacing: root.workspaceSpacing
                    Repeater {
                        model: 5
                        ClippingRectangle {
                            id: workspace
                            property int colIndex: index
                            property int workspaceValue: root.workspaceGroup * workspacesShown + rowIndex * 5 + colIndex + 1
                            property bool hoveredWhileDragging: false
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            implicitWidth: root.workspaceImplicitWidth
                            implicitHeight: root.workspaceImplicitHeight - Appearance.margins.panelMargin
                            color: "transparent"
                            radius: Appearance.rounding.small
                            Image {
                                anchors.fill: parent
                                source: Config.options.background.wallpaperPath
                                fillMode: Image.PreserveAspectCrop
                            }
                        
                            Text {
                                anchors.centerIn: parent
                                text: workspaceValue
                                color: "white"
                                font.pixelSize: Appearance.font.pixelSize.normal
                            }

                            MouseArea {
                                id: workspaceArea
                                anchors.fill: parent 
                                acceptedButtons: Qt.LeftButton
                                onClicked: {
                                    if (root.draggingTargetWorkspace === -1) {
                                        GlobalStates.overviewOpen = false
                                        Hyprland.dispatch(`workspace ${workspace.workspaceValue}`)
                                    }
                                }
                            }

                            DropArea {
                                anchors.fill: parent
                                onEntered: {
                                    root.draggingTargetWorkspace = workspaceValue
                                    if (root.draggingFromWorkspace == root.draggingTargetWorkspace) return;
                                    hoveredWhileDragging = true
                                }
                                onExited: {
                                    hoveredWhileDragging = false
                                    if (root.draggingTargetWorkspace == workspaceValue) root.draggingTargetWorkspace = -1
                                }
                            }
                        }
                    }
                }
            }
        }

        Item {
            id: windowSpace 
            anchors.centerIn: parent
            implicitWidth: workspaceColumnLayout.implicitWidth
            implicitHeight: workspaceColumnLayout.implicitHeight
            Repeater {
                model: ScriptModel {
                    values: {
                        return ToplevelManager.toplevels.values.filter((toplevel) => {
                            const address = `0x${toplevel.HyprlandToplevel.address}`
                            var win = windowByAddress[address]
                            if (!win) return false
                            const inWorkspaceGroup = (root.workspaceGroup * root.workspacesShown < win?.workspace?.id && win?.workspace?.id <= (root.workspaceGroup + 1) * root.workspacesShown)
                            const inMonitor = root.monitor?.id === win?.monitor
                            return inWorkspaceGroup && inMonitor;
                        })
                    }
                }
                delegate: OverviewWindow {
                    id: window
                    required property var modelData
                    property var address: `0x${modelData.HyprlandToplevel.address}`
                    windowData: windowByAddress[address]
                    toplevel: modelData
                    monitorData: HyprlandData.monitors[monitorId]
                    scale: root.scale
                    availableWorkspaceWidth: root.workspaceImplicitWidth
                    availableWorkspaceHeight: root.workspaceImplicitHeight

                    property int monitorId: windowData?.monitor ?? -1
                    property var monitor: HyprlandData.monitors[monitorId]

                    property int workspaceColIndex: (windowData?.workspace.id - 1) % 5
                    property int workspaceRowIndex: Math.floor((windowData?.workspace.id - 1) % root.workspacesShown / 5)
                    xOffset: (root.workspaceImplicitWidth + root.workspaceSpacing + 1) * workspaceColIndex
                    yOffset: (root.workspaceImplicitHeight + root.workspaceSpacing - 3) * workspaceRowIndex

                    property bool atInitPosition: true

                    Timer {
                        id: updateWindowPosition
                        interval: 20
                        repeat: false
                        running: false
                        onTriggered: {
                            window.x = Math.round(Math.max((windowData?.at[0] - (monitor?.x ?? 0) - (monitorData?.reserved[0] ?? 0)) * root.scale, 0) + xOffset)
                            window.y = Math.round(Math.max((windowData?.at[1] - (monitor?.y ?? 0) - (monitorData?.reserved[1] ?? 0)) * root.scale, 0) + yOffset)
                        }
                    }

                    z: atInitPosition ? root.windowZ : root.windowDraggingZ
                    Drag.hotSpot.x: targetWindowWidth / 2
                    Drag.hotSpot.y: targetWindowHeight / 2

                    MouseArea {
                        id: dragArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: hovered = true
                        onExited: hovered = false
                        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                        drag.target: parent
                        onPressed: (mouse) => {
                            root.draggingFromWorkspace = windowData?.workspace.id
                            window.pressed = true
                            window.Drag.active = true
                            window.Drag.source = window
                            window.Drag.hotSpot.x = mouse.x
                            window.Drag.hotSpot.y = mouse.y
                            window.atInitPosition = false
                        }
                        onReleased: {
                            const targetWorkspace = root.draggingTargetWorkspace
                            window.pressed = false
                            window.Drag.active = false
                            root.draggingFromWorkspace = -1
                            if (targetWorkspace !== -1 && targetWorkspace !== windowData?.workspace.id) {
                                Hyprland.dispatch(`movetoworkspacesilent ${targetWorkspace}, address:${window.windowData?.address}`)
                                updateWindowPosition.restart()
                                HyprlandData.updateAll()
                            }
                            else {
                                window.x = window.initX
                                window.y = window.initY
                                window.atInitPosition = true
                            }
                        }
                        onClicked: (event) => {
                            if (!windowData) return;

                            if (event.button === Qt.LeftButton) {
                                GlobalStates.overviewOpen = false
                                Hyprland.dispatch(`focuswindow address:${windowData.address}`)
                                event.accepted = true
                            } else if (event.button === Qt.MiddleButton) {
                                Hyprland.dispatch(`closewindow address:${windowData.address}`)
                                event.accepted = true
                            }
                        }
                    }
                }
            }
            
            Rectangle { // Focused workspace indicator
                id: focusedWorkspaceIndicator 
                property int activeWorkspaceInGroup: (monitor?.activeWorkspace?.id ?? 1) - (root.workspaceGroup * root.workspacesShown)
                property int activeWorkspaceRowIndex: Math.floor((activeWorkspaceInGroup - 1) / 5)
                property int activeWorkspaceColIndex: (activeWorkspaceInGroup - 1) % 5
                x: (root.workspaceImplicitWidth + workspaceSpacing + 1) * activeWorkspaceColIndex
                y: (root.workspaceImplicitHeight + workspaceSpacing - 3) * activeWorkspaceRowIndex
                z: 9999
                width: root.workspaceImplicitWidth
                height: root.workspaceImplicitHeight - Appearance.margins.panelMargin
                color: "transparent"
                radius: 10
                border.width: 1
                border.color: Appearance.colors.colPrimary
            }
        }
    }
    Connections {
        target: GlobalStates ?? null
        function onOverviewOpenChanged() {
            if (GlobalStates?.overviewOpen)
                root.forceActiveFocus()
        }
    }

}
