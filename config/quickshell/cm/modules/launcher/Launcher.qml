import qs
import qs.configs
import qs.configs.utils
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

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        StyledWindow {
            id: launcher
            required property var modelData
            visible: GlobalStates.launcherOpen
            screen: modelData
            name: "launcher"
            color: "transparent"

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.exclusiveZone: -1
            implicitWidth: Apps.apps.length * Config.options.dock.size + 10
            implicitHeight: (Apps.apps.length * Config.options.dock.size + 40) / 2 
            anchors {
                bottom: true
            }

            // ── Tunables ───────────────────────────────────────────────
            readonly property int iconSize: 50
            readonly property int arcRadius: implicitWidth / 2 - 20
            readonly property int centerX: width / 2
            readonly property int centerY: height

            function hide() {
                GlobalStates.launcherOpen = false
                searchField.text = ""
            }

            HyprlandFocusGrab {
                id: grab
                windows: [ launcher ]
                active: GlobalStates.launcherOpen
                onCleared: { if (!active) launcher.hide() }
            }
            StyledToolTip {
                id: tooltipText
                y: 80
                content: pathView.currentItem ? pathView.currentItem.appData.name : ""
                Behavior on content { SequentialAnimation { 
                    NumberAnimation { target: tooltipText; property: "opacity"; to: 0; duration: 50 }
                    PropertyAction { }
                    NumberAnimation { target: tooltipText; property: "opacity"; to: 1; duration: 150 }
                }}
            }
            Rectangle {
                id: searchContainer
                y: 120
                anchors.margins: 80
                anchors.left: parent.left 
                anchors.right: parent.right
                height: 36
                radius: 25
                color: Config.options.bar.showBackground ? Config.options.appearance.shape ? "transparent" : Appearance.colors.colBackground : Config.options.appearance.shape ? "transparent" : Colors.setTransparency(Appearance.colors.colGlass, 0.7)
                border.color: '#18ffffff'

                RowLayout {
                    anchors.fill: parent; anchors.leftMargin: 20; anchors.rightMargin: 20
                    TextField {
                        id: searchField
                        Layout.fillWidth: true
                        font.pixelSize: Appearance.font.pixelSize.normal
                        color: "white"
                        placeholderText: Translation.tr("Apps")
                        placeholderTextColor: "white"
                        focus: GlobalStates.launcherOpen
                        background: null

                        // PathView maneja el índice actual, nosotros solo lo movemos
                        Keys.onLeftPressed:  pathView.decrementCurrentIndex()
                        Keys.onRightPressed: pathView.incrementCurrentIndex()
                        Keys.onEscapePressed: launcher.hide()
                        Keys.onReturnPressed: {
                            if (pathView.currentItem) {
                                pathView.currentItem.appData.execute()
                                launcher.hide()
                            }
                        }
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: false
                propagateComposedEvents: true
                onWheel: (wheel) => {
                    if (wheel.angleDelta.y > 0) pathView.decrementCurrentIndex();
                    else pathView.incrementCurrentIndex();
                }
                onPressed: (mouse) => mouse.accepted = false
            }

            

            ScriptModel {
                id: appModel
                values: {
                    const stxt = searchField.text.toLowerCase()
                    return DesktopEntries.applications.values
                        .filter(obj => obj.name.toLowerCase().includes(stxt))
                        .sort((a, b) => a.name.localeCompare(b.name))
                }
            }

            // ── El PathView (La Rueda) ─────────────────────────────────
            PathView {
                id: pathView
                anchors.fill: parent
                model: appModel
                focus: true
                interactive: true
                
                // Esto hace que el seleccionado siempre esté en el centro del arco
                pathItemCount: 9
                preferredHighlightBegin: 0.5
                preferredHighlightEnd: 0.5
                highlightRangeMode: PathView.ApplyRange

                snapMode: PathView.SnapToItem
                movementDirection: PathView.Shortest
                flickDeceleration: 1500
                // Soporte para Rueda
                

                delegate: Item {
                    id: delegateItem
                    width: launcher.iconSize; height: launcher.iconSize
                    
                    readonly property var appData: modelData
                    // PathView nos da propiedades automáticas como PathView.isCurrentItem
                    readonly property bool isSelected: PathView.isCurrentItem

                    scale: isSelected ? 1.4 : 0.8
                    opacity: PathView.onPath ? 1.0 : 0.0

                    Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }
                    Behavior on opacity { NumberAnimation { duration: 200 } }

                    IconImage {
                        implicitSize: launcher.iconSize
                        source: Quickshell.iconPath(modelData.icon)
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (isSelected) {
                                modelData.execute()
                                launcher.hide()
                            } else {
                                pathView.currentIndex = index
                            }
                        }
                    }
                }

                // Definición del Arco Geométrico
                path: Path {
                    // Punto de inicio (Izquierda)
                    startX: launcher.centerX - launcher.arcRadius
                    startY: launcher.centerY

                    PathArc {
                        x: launcher.centerX + launcher.arcRadius
                        y: launcher.centerY
                        radiusX: launcher.arcRadius
                        radiusY: launcher.arcRadius * 1 // Un poco elíptico para mejor estética
                        useLargeArc: false
                    }
                }
            }
        }
    }
    GlobalShortcut {
        name: "launcherToggle"
        description: "Launcher toggle"
        onPressed: {
            GlobalStates.launcherOpen = !GlobalStates.launcherOpen
        }
    }
    GlobalShortcut {
        name: "launcherRelease"
        description: "Launcher on release"
        onPressed: {
            GlobalStates.superReleaseMightTrigger = true;
        }
        onReleased: {
            if (!GlobalStates.superReleaseMightTrigger) {
                GlobalStates.superReleaseMightTrigger = true;
                return;
            }
            GlobalStates.launcherOpen = !GlobalStates.launcherOpen
        }
    }
    GlobalShortcut {
        name: "launcherReleaseInterrupt"
        onPressed: {
            GlobalStates.superReleaseMightTrigger = false;
        }

    }
}