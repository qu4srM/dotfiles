import qs
import qs.configs
import qs.configs.utils
import qs.modules.capsule
import qs.widgets 

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import Quickshell.Io
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland


Item {
    id: root
    required property bool show

    property var tabs: [
        //{ "icon": "dashboard", "name": Translation.tr("Dashboard") },
        //{ "icon": "book", "name": Translation.tr("Study") },
        //{ "icon": "deployed_code", "name": Translation.tr("Hacking") },
        { "icon": "person", "name": Translation.tr("Dashboard") },
        { "icon": "timer", "name": Translation.tr("Timers") },
        { "icon": "palette", "name": Translation.tr("Backgrounds") },
    ]


    property int currentTab: Persistent.states.capsule.tab


    function focusActiveItem() {
        stackLayout.currentItem.forceActiveFocus()
    }
    width: buttons.implicitWidth + separator.implicitWidth + view.implicitWidth + (content.spacing * 2) + (content.anchors.margins * 2) 
    height: view.implicitHeight + (content.anchors.margins * 2)

    RowLayout {
        id: content
        anchors.fill: parent 
        anchors.margins: 8
        spacing: 8
        Item {
            id: buttons
            implicitWidth: 30
            Layout.fillHeight: true 
            Rectangle {
                implicitWidth: implicitHeight
                implicitHeight: 30
                anchors.horizontalCenter: parent.horizontalCenter 
                color: Appearance.colors.colPrimary
                radius: Appearance.rounding.small
                y: implicitHeight * root.currentTab + (columnButtons.spacing * currentTab)
                Behavior on y {
                    NumberAnimation {
                        duration: Appearance.animationDurations.expressiveFastSpatial
                        easing.type: Appearance.animation.elementMove.type
                        easing.bezierCurve: Appearance.animationCurves.expressiveFastSpatial
                    }
                }
            }

            ColumnLayout {
                id: columnButtons
                anchors.top: parent.top 
                anchors.horizontalCenter: parent.horizontalCenter
                WheelHandler {
                    acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad

                    onWheel: (event) => {
                        if (event.angleDelta.y < 0)
                            root.currentTab = Math.min(root.currentTab + 1, root.tabs.length - 1)

                        else if (event.angleDelta.y > 0)
                            root.currentTab = Math.max(root.currentTab - 1, 0)

                        Persistent.states.capsule.tab = root.currentTab
                    }
                }

                Repeater {
                    model: root.tabs 
                    delegate: MouseArea {
                        id: tabButton
                        required property var modelData 
                        required property int index
                        implicitWidth: implicitHeight 
                        implicitHeight: 30
                        onClicked: {
                            root.currentTab = tabButton.index
                            Persistent.states.capsule.tab = tabButton.index
                        }
                        StyledMaterialSymbol {
                            anchors.centerIn: parent
                            text: tabButton.modelData.icon
                            size: 18
                            color: root.currentTab == tabButton.index ? "black" : "white"
                            fill: 0
                        }
                    }
                }

            }
            Rectangle {
                id: menuButtons
                property bool expanded: false 
                anchors.bottom: parent.bottom 
                implicitWidth: 30
                implicitHeight: expanded ? buttonsSystem.implicitHeight + 6: implicitWidth
                color: Appearance.colors.colPrimary 
                radius: Appearance.rounding.small
                Behavior on implicitHeight {
                    NumberAnimation {
                        duration: Appearance.animationDurations.expressiveFastSpatial
                        easing.type: Appearance.animation.elementMove.type
                        easing.bezierCurve: Appearance.animationCurves.expressiveFastSpatial
                    }
                }
                HoverHandler {
                    id: dockHover
                    enabled: true
                    onHoveredChanged: menuButtons.expanded = hovered
                }
                StyledMaterialSymbol {
                    visible: opacity > 0
                    opacity: menuButtons.expanded ? 0 : 1
                    anchors.centerIn: parent
                    text: "menu"
                    size: 18
                    color: "black"
                    fill: 0
                }
                ColumnLayout {
                    id: buttonsSystem
                    visible: menuButtons.expanded
                    anchors.centerIn: parent
                    PowerButton {
                        iconButton: "restart_alt"
                        textTooltip: Translation.tr("Reboot") + " Hyprland"
                        onPressed: {
                            Quickshell.execDetached(["bash", "-c", "~/.config/quickshell/scripts/screenshot.sh"])
                        }
                    }
                    PowerButton {
                        iconButton: "settings"
                        textTooltip: Translation.tr("Settings") 
                        onPressed: {
                            Quickshell.execDetached(["qs", "-p", Paths.settingsQmlPath])
                        }
                    }
                    PowerButton {
                        iconButton: "power_settings_new"
                        textTooltip: Translation.tr("Power Menu") 
                        onPressed: {
                            GlobalStates.sessionOpen = true
                        }
                    }

                }
            }
        }
        Rectangle {
            id: separator
            Layout.fillHeight: true 
            implicitWidth: 2
            color: Appearance.colors.colCapsuleSurface
        }
        ClippingRectangle {
            id: view
            implicitWidth: swipeView.width
            implicitHeight: swipeView.height
            radius: Appearance.rounding.small
            color: "transparent"
            SwipeView {
                id: swipeView
                implicitWidth: currentItem.implicitWidth
                implicitHeight: currentItem.implicitHeight
                interactive: false
                orientation: Qt.Vertical
                spacing: 10
                clip: true 
                currentIndex: root.currentTab
                Dashboard {
                    show: root.show
                }
                Timers {}
                //MediaPanel {}
                WallpapersList {}   
            }
            
        }
    }
    component PowerButton: ActionButtonIcon {
        id: btn
        property string textTooltip
        property string iconButton
        colBackground: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainerHigh : Appearance.colors.colGlass
        colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colPrimary : Appearance.colors.colGlassHover
        iconMaterial: btn.iconButton
        iconSize: 18
        changeColor: true 
        iconColor: Appearance.colors.colOnText
        implicitWidth: implicitHeight
        implicitHeight: 26
        buttonRadius: 10
        StyledToolTip {
            content: btn.textTooltip
        }
        /*
        RectangleRing {
            anchors.fill: parent 
            radius: parent.buttonRadius
            source: ShaderEffectSource {
                anchors.fill: parent 
                sourceRect: Qt.rect(0,0,200,400)
                hideSource: true
                live: false
                visible: true
            }
        }*/
    }
}
