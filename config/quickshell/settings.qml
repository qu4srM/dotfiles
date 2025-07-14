
import "root:/services/"
import "root:/modules/common/"
import "root:/widgets/"


import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

ApplicationWindow {
    id: root

    property var pages: [
        {
            name: "Style",
            icon: "palette",
            component: "modules/settings/StyleConfig.qml"
        },
        {
            name: "Interface",
            icon: "cards",
            component: "modules/settings/InterfaceConfig.qml"
        },
        {
            name: "Services",
            icon: "settings",
            component: "modules/settings/ServicesConfig.qml"
        },
        {
            name: "Advanced",
            icon: "construction",
            component: "modules/settings/AdvancedConfig.qml"
        },
        {
            name: "About",
            icon: "info",
            component: "modules/settings/About.qml"
        }
    ]

    visible: true
    onClosing: Qt.quit()
    title: "shell Settings"

    minimumWidth: 600
    minimumHeight: 400
    width: 1100
    height: 600
    color: "#111111"
    ColumnLayout {
        anchors {
            fill: parent
            margins: contentPadding
        }
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: false
            implicitHeight: 40
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: "Settings"
                color: "white"
            }

        }
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10
            Item {
                id: navRailWrapper
                Layout.fillHeight: true
                Layout.margins: 5
                implicitWidth: 100
                NavigationRail {
                    id: navRail 
                    anchors {
                        left: parent.left 
                        top: parent.top 
                        bottom: parent.bottom
                    }
                    spacing: 10
                    expanded: root.width > 900
                    ColumnLayout {
                        Repeater {
                            model: root.pages
                            Text {
                                text: modelData.name
                                color: "white"
                            }
                        }
                    }
                }
            }
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#303030"
                radius: 10
                ActionButtonIcon {
                    iconImage: "picker-symbolic.svg"
                }
            }
        }
    }
}
