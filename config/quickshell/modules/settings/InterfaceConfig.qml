import qs
import qs.configs
import qs.widgets 

import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Widgets

Flickable {
    id: root
    //anchors.fill: parent
    //anchors.rightMargin: 10
    //forceWidth: true

    maximumFlickVelocity: 3500

    anchors.fill: parent 
    anchors.rightMargin: 10
    contentHeight: content.implicitHeight + 100
    clip: true
    ColumnLayout {
        id: content
        width: parent.width
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            margins: 20
        }
        spacing: 30
    
        ContentSection{
            id: appearance
            title: Translation.tr("Appearance")
            icon: "palette"
            ContentSubsection {
                title: Translation.tr("Wallpapers")
                icon: "emoji_symbols"
                Layout.leftMargin: 10
                ConfigSwitch {
                    Layout.fillWidth: true
                    implicitHeight: 40
                    text: Translation.tr("Wallpaper overlay")
                    checked: Config.options.appearance.shapes.enable
                    onCheckedChanged: {
                        Config.options.appearance.shapes.enable = checked;
                    }
                }
                ActionButton {
                    colBackground: Appearance.colors.colBackground
                    colBackgroundHover: Appearance.colors.colPrimaryHover
                    buttonText: Translation.tr("Wallpapers")
                    Layout.fillWidth: true
                    implicitHeight: 40
                    releaseAction: () => Quickshell.execDetached(["bash", "-c", "qs ipc call wallpaperSelector toggle"])
                }
            }
            ContentSubsection {
                title: Translation.tr("Icons")
                icon: "emoji_symbols"
                Layout.leftMargin: 10
                ConfigSwitch {
                    Layout.fillWidth: true
                    implicitHeight: 40
                    text: Translation.tr("Tematic icons")
                    checked: Config.options.appearance.shapes.enable
                    onCheckedChanged: {
                        Config.options.appearance.shapes.enable = checked;
                    }
                }
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 80
                    color: Appearance.colors.colBackground
                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 20

                        Repeater  {
                            model: [
                                "circle",
                                "square",
                                "4sidedcookie",
                                "7sidedcookie",
                                "arch"
                            ]
                            delegate: Rectangle {
                                required property var modelData
                                width: 60
                                height: width 
                                color: Appearance.colors.colSurfaceContainer
                                radius: Config.options.appearance.shapes.shape === modelData ? Appearance.rounding.normal : Appearance.rounding.full
                                ShapesIcons {
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    useSystemShape: false 
                                    shape: parent.modelData
                                }
                                MouseArea {
                                    anchors.fill: parent 
                                    hoverEnabled: true 
                                    onPressed: () => {
                                        Config.options.appearance.shapes.shape = parent.modelData
                                    }
                                }
                                Behavior on radius {
                                    animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) 
                                }
                            }
                        }
                    }
                }
            }  
        }
        ContentSection{
            id: dock
            width: root.width
            title: "Dock"
            icon: "dock_to_bottom"
            spacing: 5
            ConfigSwitch {
                implicitWidth: root.width
                implicitHeight: 40
                text: Translation.tr("Enable")
                checked: Config.options.dock.enable
                onCheckedChanged: {
                    Config.options.dock.enable = checked;
                }
            }
            ConfigSwitch {
                implicitWidth: root.width
                implicitHeight: 40
                text: Translation.tr("Hover to reveal")
                checked: Config.options.dock.hoverToReveal
                onCheckedChanged: {
                    Config.options.dock.hoverToReveal = checked;
                }
            }
            ConfigSwitch {
                implicitWidth: root.width
                implicitHeight: 40
                text: Translation.tr("Pinned on startup")
                checked: Config.options.dock.pinnedOnStartup
                onCheckedChanged: {
                    Config.options.dock.pinnedOnStartup = checked;
                }
            }
            ConfigSwitch {
                implicitWidth: root.width
                implicitHeight: 40
                text: Translation.tr("Monochrome Icons")
                checked: Config.options.dock.monochromeIcons
                onCheckedChanged: {
                    Config.options.dock.monochromeIcons = checked;
                }
            }
        }
        ContentSection{
            width: root.width
            title: "Launcher"
            icon: "dock_to_bottom"
            spacing: 5
            ConfigSwitch {
                implicitWidth: root.width
                implicitHeight: 40
                text: Translation.tr("Enable")
                checked: Config.options.dock.enable
                onCheckedChanged: {
                    Config.options.dock.enable = checked;
                }
            }
            ConfigSpinBox {
                icon: "add_column_right"
                text: Translation.tr("Columns (Int)")
                value: Config.options.launcher.columnsApps
                from: 1
                to: 10
                stepSize: 1
                onValueChanged: {
                    Config.options.launcher.columnsApps = value;
                }
            }
            
            ConfigSpinBox {
                icon: "add_row_below"
                text: Translation.tr("Rows (Int)")
                value: Config.options.launcher.rowsApps
                from: 1
                to: 10
                stepSize: 1
                onValueChanged: {
                    Config.options.launcher.rowsApps = value;
                }
            }
        }
    }
}