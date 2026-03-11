import qs
import qs.configs
import qs.modules.capsule
import qs.utils
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

    property var tabButtonList: [
        //{ "icon": "dashboard", "name": Translation.tr("Dashboard") },
        //{ "icon": "book", "name": Translation.tr("Study") },
        //{ "icon": "deployed_code", "name": Translation.tr("Hacking") },
        { "icon": "person", "name": Translation.tr("Dashboard") },
        { "icon": "queue_music", "name": Translation.tr("Media") },
        { "icon": "palette", "name": Translation.tr("Backgrounds") },
    ]
    property var sizeWidth: [640, 400, 645]
    property var sizeHeight: [160, 200, 280]

    property int currentTab: Persistent.states.sidebarleft.currentTab

    function focusActiveItem() {
        stackLayout.currentItem.forceActiveFocus()
    }
    width: sizeWidth[root.currentTab] ?? sizeWidth[0]
    height: sizeHeight[root.currentTab] ?? sizeHeight[0]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 10
        Item {
            Layout.fillWidth: true 
            implicitHeight: 40

            Rectangle {
                implicitWidth: (100 * 3) + 10
                implicitHeight: parent.implicitHeight
                radius: Appearance.rounding.full
                color: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainerHigh : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                RectangleRing {
                    anchors.fill: parent 
                    radius: parent.radius
                    source: ShaderEffectSource {
                        anchors.fill: parent 
                        sourceRect: Qt.rect(0,0,200,400)
                        hideSource: true
                        live: true
                        visible: true
                    }
                }
                PrimaryTabBar {
                    id: tabBar
                    anchors.fill: parent
                    anchors.margins: 0
                    externalTrackedTab: root.currentTab
                    tabButtonList: root.tabButtonList
                    function onCurrentIndexChanged(currentIndex) {
                        Persistent.states.sidebarleft.currentTab = currentIndex
                    }
                }
            }
            RowLayout {
                anchors.right: parent.right
                height: parent.implicitHeight
                spacing: 6
                ActionButtonIcon {
                    anchors.verticalCenter: parent.verticalCenter
                    colBackground: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainerHigh : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                    colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colPrimary : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                    iconMaterial: "restart_alt"
                    iconSize: 20
                    implicitWidth: implicitHeight
                    implicitHeight: parent.height - 2
                    buttonRadiusTopLeft: 30
                    buttonRadiusTopRight: 30
                    buttonRadiusBottomLeft: 30
                    buttonRadiusBottomRight: 30
                    onPressed: {
                        Quickshell.execDetached(["bash", "-c", "~/.config/quickshell/scripts/screenshot.sh"])
                    }
                    StyledToolTip {
                        content: Translation.tr("Reboot") + " Hyprland"
                    }
                    RectangleRing {
                        anchors.fill: parent 
                        radius: parent.radius
                        source: ShaderEffectSource {
                            anchors.fill: parent 
                            sourceRect: Qt.rect(0,0,200,400)
                            hideSource: true
                            live: true
                            visible: true
                        }
                    }
                }
                ActionButtonIcon {
                    anchors.verticalCenter: parent.verticalCenter
                    colBackground: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainerHigh : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                    colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colPrimary : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                    iconMaterial: "settings"
                    iconSize: 16
                    implicitWidth: implicitHeight
                    implicitHeight: parent.height - 2
                    buttonRadiusTopLeft: 30
                    buttonRadiusTopRight: 30
                    buttonRadiusBottomLeft: 30
                    buttonRadiusBottomRight: 30
                    onPressed: {
                        GlobalStates.sidebarRightOpen = false
                        Quickshell.execDetached(["qs", "-p", Paths.settingsQmlPath])
                    }
                    StyledToolTip {
                        content: Translation.tr("Settings")
                    }
                    RectangleRing {
                        anchors.fill: parent 
                        radius: parent.radius
                        source: ShaderEffectSource {
                            anchors.fill: parent 
                            sourceRect: Qt.rect(0,0,200,400)
                            hideSource: true
                            live: true
                            visible: true
                        }
                    }
                }
                ActionButtonIcon {
                    anchors.verticalCenter: parent.verticalCenter
                    colBackground: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainerHigh : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                    colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colPrimary : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                    iconMaterial: "power_settings_new"
                    iconSize: 16
                    implicitWidth: implicitHeight
                    implicitHeight: parent.height - 2
                    buttonRadiusTopLeft: 30
                    buttonRadiusTopRight: 30
                    buttonRadiusBottomLeft: 30
                    buttonRadiusBottomRight: 30
                    onPressed: {
                        GlobalStates.sessionOpen = true
                    }
                    StyledToolTip {
                        content: Translation.tr("Power Menu")
                    }
                    RectangleRing {
                        anchors.fill: parent 
                        radius: parent.radius
                        source: ShaderEffectSource {
                            anchors.fill: parent 
                            sourceRect: Qt.rect(0,0,200,400)
                            hideSource: true
                            live: true
                            visible: true
                        }
                    }
                }
            }
        }
        ClippingRectangle {
            id: view
            Layout.fillWidth: true 
            Layout.fillHeight: true
            radius: Appearance.rounding.normal
            color: "transparent"

            StackLayout {
                id: stackLayout
                anchors.fill: parent
                currentIndex: root.currentTab
                MediaPanel { Layout.fillWidth: true; Layout.fillHeight: true }
                MediaPanel { Layout.fillWidth: true; Layout.fillHeight: true }
                WallpapersList { id: walls;}

            }
            
        }

        //MusicPanel {}
        //TimerPanel {}
    }
}
