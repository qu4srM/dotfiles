import qs
import qs.configs
import qs.modules.dock
import qs.widgets
import qs.utils
import qs.services

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

Scope {
    id: root

    property bool pinned: Config.options?.dock.pinnedOnStartup ?? false
    property bool ready: false
    property bool dockEnabled: Config.options?.dock.enable ?? false
    property string currentPosition: Config.options.dock.position
    /*
    function hide() {
        dockEnabled = !dockEnabled
    }
    function triggerOsd() {
        dockEnabled = !dockEnabled
        changeTimeout.restart();
    }
    Timer {
        id: osdTimeout
        interval: 3000
        repeat: false
        onTriggered: root.hide()
    }
    Connections {
        target: Config
        function onOptionsChanged() {
            root.currentPosition = Config.options.dock.position
            console.log("Nueva posición:", root.currentPosition)
            root.osdTimeout.restart();
        }
    }*/
    Component.onCompleted: Qt.callLater(() => root.ready = true)
    
    Variants {
        model: Quickshell.screens 

        LazyLoader {
            id: dockLoader
            active: dockEnabled
            required property ShellScreen modelData

            component: StyledWindow {
                id: dock
                property bool isLeft: root.currentPosition === "left"
                property bool isRight: root.currentPosition === "right"
                property bool isBottom: root.currentPosition === "bottom"
                property bool isVertical: isLeft || isRight
                property bool isHorizontal: isBottom
                property bool hovered: false
                property real mouseX: 0

                screen: dockLoader.modelData
                name: "dock"
                color: "transparent"
                visible: !GlobalStates.screenLock
                //exclusiveZone: 0
            
                anchors {
                    top: (isLeft || isRight)
                    left: (isLeft || isBottom)
                    right: (isRight || isBottom)
                    bottom: true
                }

                implicitHeight: Config.options.dock.size * 2
                implicitWidth: Config.options.dock.size * 2
                exclusiveZone:  root.pinned
                                ? (isVertical
                                    ? implicitWidth - 60
                                    : implicitHeight - 60)
                                : 0
                //exclusiveZone: 0
                //exclusionMode: ExclusionMode.Ignore
                mask: Region {
                    x: 0
                    y: 0
                    width: dock.width
                    height: dock.height
                    intersection: Intersection.Xor
                    regions: regions.instances
                }
                
                Variants {
                    id: regions

                    model: docks.children

                    Region {
                        required property Item modelData

                        x: modelData.x
                        y: modelData.y
                        width: modelData.width
                        height: modelData.height
                        intersection: Intersection.Subtract
                    }
                }

                property bool reveal: root.pinned
                    || (Config.options.dock.hoverToReveal && dock.hovered)
                    || ((!GlobalStates.wallSelectorOpen && !GlobalStates.launcherOpen)
                        && !ToplevelManager.activeToplevel?.activated)
                
                
                /*Item {
                    id: dockArea
                    enabled: root.ready

                    width: isHorizontal
                        ? loader.item?.implicitWidth
                        : parent.width - 50 
                    height: isVertical
                        ? 400
                        : parent.height - 50

                    anchors {
                        left: isLeft ? parent.left : undefined 
                        right: isRight ? parent.right : undefined
                        bottom: isBottom ? parent.bottom : undefined
                        verticalCenter: isVertical ? parent.verticalCenter : undefined
                        horizontalCenter: isHorizontal ? parent.horizontalCenter : undefined
                        
                        leftMargin: isLeft
                            ? (dock.reveal
                                ? 0
                                : (Config.options.dock.hoverToReveal
                                    ? -loader.item?.implicitWidth - 2
                                    : loader.item?.implicitWidth))
                            : undefined
                        rightMargin: isRight
                            ? (dock.reveal
                                ? 0
                                : (Config.options.dock.hoverToReveal
                                    ? -loader.item?.implicitWidth - 2
                                    : loader.item?.implicitWidth))
                            : undefined
                        bottomMargin: isBottom
                            ? (dock.reveal
                                ? 0
                                : (Config.options.dock.hoverToReveal
                                    ? -loader.item?.implicitHeight - 8
                                    : loader.item?.implicitHeight))
                            : undefined
                    }

                    Behavior on anchors.leftMargin {
                        enabled: isLeft
                        animation: Appearance.animation.elementMoveFast
                            .numberAnimation.createObject(this)
                    }

                    Behavior on anchors.rightMargin {
                        enabled: isRight
                        animation: Appearance.animation.elementMoveFast
                            .numberAnimation.createObject(this)
                    }

                    Behavior on anchors.bottomMargin {
                        enabled: isBottom
                        animation: Appearance.animation.elementMoveFast
                            .numberAnimation.createObject(this)
                    }

                    HoverHandler {
                        id: dockHover
                        enabled: root.ready && !root.pinned
                    }
                    Rectangle {
                        anchors.fill: parent 
                    }

                    Loader {
                        id: loader
                        anchors.verticalCenter: isVertical ? parent.verticalCenter : undefined
                        anchors.horizontalCenter: isHorizontal ? parent.horizontalCenter : undefined

                        anchors.left: isLeft ? parent.left : undefined 
                        anchors.right: isRight ? parent.right : undefined 
                        anchors.bottom: isBottom ? parent.bottom : undefined
                        anchors.margins: 2

                        sourceComponent: isVertical ? verticalComponent : horizontalComponent
                    }
                    Component {
                        id: verticalComponent

                        Vertical {
                            id: columnItems
                            area: dockArea
                            ready: root.ready
                            isLeft: dock.isLeft
                        }
                    }

                    Component {
                        id: horizontalComponent

                        Horizontal {
                            id: rowItems
                            area: dockArea
                            ready: root.ready
                        }
                    }
                    
                }*/
                /**/
                    
                
                    
                Item {
                    id: docks
                    anchors.fill: parent 
                    
                    DockOptions {
                        scope: root
                        window: dock
                        anchor.window: dock
                        anchor.rect.x: dockBottom.x + Apps.lastClickedPositionApp + 80 - (widthC / 2)
                        anchor.rect.y: dock.height
                    }

                    Loader {
                        id: dockBottom
                        active: dock.isBottom 
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        sourceComponent: DockArea {
                            id: dockArea
                            dockApps: dockApps
                            width: dockApps.implicitWidth
                            height: Config.options.dock.size
                            anchors {
                                bottom: parent.bottom
                                horizontalCenter: parent.horizontalCenter
                            }
                            
                            
                            Horizontal {
                                id: dockApps
                                anchors.bottom: parent.bottom
                                area: dockArea
                                ready: root.ready
                            }
                        }
                    }
                    Loader {
                        id: dockLeft
                        active: dock.isLeft
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        sourceComponent: DockArea {
                            id: dockArea
                            dockApps: dockApps
                            implicitWidth: Config.options.dock.size
                            implicitHeight: dockApps.implicitHeight
                            anchors {
                                left: parent.left
                                verticalCenter: parent.verticalCenter
                            }
                            
                            Vertical {
                                id: dockApps
                                area: dockArea
                                ready: root.ready
                                isLeft: dock.isLeft
                            } 
                        }
                    }
                }

                component DockArea: Item {
                    id: dockAreaComponent
                    property Item dockApps
                    enabled: root.ready
                    Binding {
                        target: dockAreaComponent
                        property: "anchors.bottomMargin"
                        when: isBottom
                        value: dock.reveal
                            ? 0
                            : (Config.options.dock.hoverToReveal
                                ? -dockApps.implicitHeight
                                : dockApps.implicitHeight)
                    }
                    Binding {
                        target: dockAreaComponent
                        property: "anchors.leftMargin"
                        when: isLeft
                        value: dock.reveal
                            ? 0
                            : (Config.options.dock.hoverToReveal
                                ? -dockApps.implicitWidth
                                : dockApps.implicitWidth)
                    }
                    HoverHandler {
                        id: dockHover
                        enabled: root.ready && !root.pinned
                        onHoveredChanged: dock.hovered = hovered
                    }

                    Behavior on anchors.leftMargin {
                        enabled: isLeft
                        animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
                    }

                    Behavior on anchors.rightMargin {
                        enabled: isRight
                        animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
                    }

                    Behavior on anchors.bottomMargin {
                        enabled: isBottom
                        animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
                    }

                }
                
            }
        }
    }
}
