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
import Quickshell.Wayland
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
            visible: !GlobalStates.screenLock
            screen: modelData
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
            property bool anyFloating: false

            property bool reveal: root.pinned
                || (Config.options?.dock.hoverToReveal && dockMouseArea.containsMouse)
                || (!GlobalStates.wallSelectorOpen && !ToplevelManager.activeToplevel?.activated)

            implicitHeight: 70 + content.anchors.bottomMargin
            exclusiveZone: root.pinned ? dock.implicitHeight - 18 : 0
            mask: Region { item: dockMouseArea }

            MouseArea {
                id: dockMouseArea
                hoverEnabled: !root.pinned
                height: parent.height - content.anchors.bottomMargin - 14 - 1
                propagateComposedEvents: true
                anchors {
                    bottom: parent.bottom
                    bottomMargin: dock.reveal ? -1
                                              : (Config.options.dock.hoverToReveal
                                                  ? -content.implicitHeight - content.anchors.bottomMargin
                                                  : (content.implicitHeight))
                    horizontalCenter: parent.horizontalCenter
                }
                implicitWidth: content.implicitWidth

                Behavior on anchors.bottomMargin {
                    animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
                }
                
                StyledRectangularShadow {
                    visible: Config.options.bar.showBackground ? Config.options.appearance.shape ? false : true : false
                    target: content
                }

                Rectangle {
                    id: content
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 4
                    implicitWidth: list.width + 14
                    implicitHeight: list.height - dock.implicitHeight / 3
                    color: Config.options.bar.showBackground ? Config.options.appearance.shape ? "transparent" : Appearance.colors.colbackground : Config.options.appearance.shape ? "transparent" : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                    radius: Appearance.rounding.small
                    border.width: Config.options.bar.showBackground ? 0 : Config.options.appearance.shape ? 0 : 1
                    border.color: Colors.setTransparency(Appearance.colors.colglassmorphism, 0.7)
                    ListView {
                        id: list
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 4
                        width: contentWidth
                        height: dock.implicitHeight
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
                            anchors.bottom: parent.bottom

                            property real hoverScale: 1.0
                            property real baseSize: dock.implicitHeight / 2

                            implicitWidth: baseSize * hoverScale
                            implicitHeight: baseSize * hoverScale

                            Behavior on implicitWidth {
                                animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
                            }
                            Behavior on implicitHeight {
                                animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
                            }
                        }
                    }
                    MouseArea {
                        id: magnifyMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        propagateComposedEvents: true
                        property real maxDist: 100
                        property real maxBoost: 0.7

                        onPositionChanged: function(mouse) {
                            let nearest = null
                            let best = 1e9
                            for (let i = 0; i < list.count; i++) {
                                let item = list.itemAtIndex(i)
                                if (item) {
                                    let centerX = item.x + item.implicitWidth / 2
                                    let dist = Math.abs(mouse.x - centerX)
                                    if (dist < best) { best = dist; nearest = item }
                                    let scaleFactor = 1 + Math.max(0, (maxDist - dist) / maxDist) * maxBoost
                                    item.hoverScale = scaleFactor
                                }
                            }
                        }


                        onExited: {
                            for (let i = 0; i < list.count; i++) {
                                let item = list.itemAtIndex(i)
                                if (item) item.hoverScale = 1.0
                            }
                            root.lastHoveredItem = null
                        }
                    }
                }
            }
        }
    }
}
