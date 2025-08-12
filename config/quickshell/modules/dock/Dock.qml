import qs 
import qs.configs
import qs.modules.dock
import qs.widgets 
import qs.utils

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
    property bool pinned: Config.options?.dock.pinnedOnStartup ?? false
    property Item lastHoveredItem
    Variants {
        model: Quickshell.screens
        StyledWindow {
            id: dock
            required property var modelData
            screen: modelData
            name: "dock"
            color: "transparent"
            anchors {
                bottom: true
                left: true
                right: true
            }
            margins.bottom: 4
            property string pathIcons: "root:/assets/icons/"
            property string colorMain: "transparent"
            property string colorDock: "#29141414"
            property string pathScripts: "~/.config/quickshell/scripts/"
            property string pinnedAppsPath: "~/.config/quickshell/utils/data/pinned_apps.json"
            /*readonly property var apps: {
                return DesktopEntries.applications.values.filter(app => app?.name && app?.icon)
            }*/

            implicitHeight: 50
            Rectangle {
                anchors.centerIn: parent
                implicitWidth: list.width + 16
                implicitHeight: parent.height
                color: Appearance.colors.colbackground
                radius: Appearance.rounding.normal

                Behavior on implicitWidth { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this);  }

                ListView {
                    id: list
                    width: contentWidth
                    height: parent.height
                    orientation: ListView.Horizontal
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8
                    model: ScriptModel {
                        values: {
                            let pinned = (Config.options.dock.pinnedApps || []).map(p => p.toLowerCase());
                            let apps = DesktopEntries.applications.values.filter(app => {
                                let appName = app?.name?.toLowerCase() || "";
                                let appId = app?.id?.toLowerCase() || "";
                                return (pinned.includes(appName) || pinned.includes(appId)) && app?.icon;
                            });
                            return apps;
                        }
                    }
                    delegate: DockItem {
                        id: dockItem
                        appListRoot: root
                        monitor: Hyprland.monitorFor(dock.screen)
                        toolTipElement: tooltip
                        anchors.verticalCenter: parent.verticalCenter

                        property real hoverScale: 1.0

                        // En vez de solo escalar, cambiamos el tamaño real que ocupa
                        implicitWidth: baseSize * hoverScale
                        implicitHeight: baseSize * hoverScale

                        property real baseSize: 30 // tamaño base del icono
                        Behavior on implicitWidth { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this);  }
                        Behavior on implicitHeight { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this);  }
                    }

                }
                MouseArea {
                    anchors.fill: list
                    hoverEnabled: true
                    propagateComposedEvents: true   
                    onPositionChanged: {
                        for (let i = 0; i < list.count; i++) {
                            let item = list.itemAtIndex(i)
                            if (item) {
                                let centerX = item.x + item.implicitWidth / 2
                                let dist = Math.abs(mouse.x - centerX)
                                let maxDist = 50
                                let scaleFactor = 1 + Math.max(0, (maxDist - dist) / maxDist) * 0.5
                                item.hoverScale = scaleFactor
                            }
                        }
                    }
                    onExited: {
                        for (let i = 0; i < list.count; i++) {
                            let item = list.itemAtIndex(i)
                            if (item) {
                                item.hoverScale = 1.0
                            }
                        }
                    }

                }

                PopupWindow {
                    id: tooltip
                    property var lastHoveredItemName: root.lastHoveredItem?.modelData.name
                    anchor {
                        window: dock
                        rect.y: parentWindow.height - dock.implicitHeight - dock.margins.bottom - tooltip.implicitHeight
                    }
                    visible: root.lastHoveredItem != null 
                    implicitWidth: textLabel.implicitWidth + 16
                    implicitHeight: textLabel.implicitHeight + 8
                    color: "transparent"
                    Rectangle {
                        anchors.fill: parent
                        color: Appearance.colors.colbackground 
                        radius: Appearance.rounding.normal
                        StyledText {
                            id: textLabel
                            anchors.centerIn: parent 
                            text: tooltip.lastHoveredItemName
                            color: "white"
                        }
                    }
                }
            }
        }
    }
}
