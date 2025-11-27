import qs 
import qs.configs
import qs.modules.dock
import qs.widgets
import qs.utils

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

Scope {
    id: root
    property bool pinned: Config.options?.dock.pinnedOnStartup ?? false
    property Item lastHoveredItem

    Variants {
        model: Quickshell.screens
        LazyLoader {
            id: dockLoader 
            active: Config.options?.dock.enable ?? false
            required property ShellScreen modelData 
            component: StyledWindow {
                id: dock
                visible: !GlobalStates.screenLock
                screen: dockLoader.modelData
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

                property real listHeight: dock.implicitHeight - 60

                property bool reveal: root.pinned
                    || (Config.options?.dock.hoverToReveal && dockMouseArea.containsMouse)
                    || ((!GlobalStates.wallSelectorOpen && !GlobalStates.launcherOpen) && !ToplevelManager.activeToplevel?.activated)


                implicitHeight: 110
                exclusiveZone: root.pinned ? dock.implicitHeight - 56 : 0
                mask: Region { item: dockMouseArea }
                MouseArea {
                    id: dockMouseArea
                    hoverEnabled: !root.pinned
                    height: parent.height - 50
                    propagateComposedEvents: true
                    anchors {
                        bottom: parent.bottom
                        bottomMargin: dock.reveal ? 0
                                                : (Config.options.dock.hoverToReveal
                                                    ? -rowItems.implicitHeight - 8
                                                    : (rowItems.implicitHeight))
                        horizontalCenter: parent.horizontalCenter
                    }
                    implicitWidth: rowItems.implicitWidth

                    Behavior on anchors.bottomMargin {
                        animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
                    }
                    /*
                    StyledRectangularShadow {
                        visible: Config.options.bar.showBackground ? Config.options.appearance.shapes.enable ? false : true : false
                        target: content
                    }*/
                    RowLayout{
                        id: rowItems
                        anchors.bottom: parent.bottom 
                        anchors.bottomMargin: Appearance.margins.panelMargin
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: Appearance.margins.panelMargin
                        
                        Rectangle {
                            id: content
                            implicitWidth: list.width + 14
                            implicitHeight: list.height 
                            color: Config.options.bar.showBackground ? Config.options.appearance.shapes.enable ? "transparent" : Appearance.colors.colBackground : Config.options.appearance.shapes.enable ? "transparent" : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                            radius: Appearance.rounding.small
                            border.width: Config.options.bar.showBackground ? 0 :  Config.options.appearance.shapes.enable ? 0 : 1
                            border.color: Colors.setTransparency(Appearance.colors.colglassmorphism, 0.7)
                            ListView {
                                id: list
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 6
                                width: contentWidth
                                height: dock.listHeight
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
                                    baseSize: list.height - 10

                                    implicitWidth: baseSize * hoverScale
                                    implicitHeight: baseSize * hoverScale
                                }
                            }
                            MouseArea {
                                id: magnifyMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                propagateComposedEvents: true
                                property real maxDist: 100
                                property real maxBoost: 0.7

                                property real lastUpdateTime: 0
                                onPositionChanged: function(mouse) {
                                    const now = Date.now()
                                    if (now - lastUpdateTime < 16) return // limita a ~60fps
                                    lastUpdateTime = now

                                    for (let i = 0; i < list.count; i++) {
                                        const item = list.itemAtIndex(i)
                                        if (!item) continue

                                        const centerX = item.x + item.implicitWidth / 2
                                        const dist = Math.abs(mouse.x - centerX)
                                        const scaleFactor = 1 + Math.max(0, (maxDist - dist) / maxDist) * maxBoost

                                        // Evita recalcular si no hay cambios notables
                                        if (Math.abs(item.hoverScale - scaleFactor) > 0.05)
                                            item.hoverScale = scaleFactor
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
                        Rectangle {
                            id: apps
                            implicitWidth: parent.implicitHeight
                            implicitHeight: parent.implicitHeight
                            color: Config.options.bar.showBackground ? Config.options.appearance.shapes.enable ? "transparent" : Appearance.colors.colBackground : Config.options.appearance.shapes.enable ? "transparent" : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                            radius: Appearance.rounding.small
                            CustomIcon {
                                colorize: true 
                                color: hoverArea.containsMouse
                                    ? Appearance.colors.colPrimary
                                    : Appearance.colors.colOutline 
                                anchors.centerIn: parent 
                                source: "arch-symbolic"
                                size: parent.height - 20
                                Behavior on color {
                                    ColorAnimation { duration: 120 }
                                }
                            }
                            MouseArea {
                                id: hoverArea
                                anchors.fill: parent
                                hoverEnabled: true
                                propagateComposedEvents: true
                                onClicked: () => {
                                    GlobalStates.launcherOpen = true
                                }
                            }
                            Rectangle {
                                visible: opacity > 0
                                opacity: hoverArea.containsMouse
                                anchors.top: parent.top
                                anchors.topMargin: -35
                                anchors.horizontalCenter: parent.horizontalCenter
                                implicitWidth: tooltipTextObject.width + 2 * 5
                                implicitHeight: tooltipTextObject.height + 2 * 5
                                color: Config.options.bar.showBackground ? Appearance.colors.colOnTooltip : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                                radius: Appearance?.rounding.verysmall ?? 7
                                StyledText {
                                    id: tooltipTextObject
                                    anchors.centerIn: parent
                                    text: Translation.tr("Apps")
                                    font.pixelSize: Appearance?.font.pixelSize.smaller ?? 14
                                    font.hintingPreference: Font.PreferNoHinting // Prevent shaky text
                                    color: Appearance?.colors.colTooltip ?? "#FFFFFF"
                                    wrapMode: Text.Wrap
                                } 
                            }
                        }
                    }
                }
            }
        }
    }
}
