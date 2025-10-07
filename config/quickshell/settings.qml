//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

// Adjust this to make the app smaller or larger
//@ pragma Env QT_SCALE_FACTOR=1

import qs
import qs.configs
//import qs.modules.settings
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

ApplicationWindow {
    id: root

    /*property var pages: [
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
    ]*/
    property var pages: [
        {
            name: Translation.tr("Interface"),
            icon: "cards",
            component: "modules/settings/InterfaceConfig.qml"
        },
        {
            name: Translation.tr("Bar"),
            icon: "toolbar",
            component: "modules/settings/BarConfig.qml"
        },
        {
            name: Translation.tr("Themes"),
            icon: "format_paint",
            component: "modules/settings/ThemesConfig.qml"
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
    property int currentPage: 0

    visible: true
    onClosing: Qt.quit()
    title: "shell Settings"

    minimumWidth: 300 // 600
    minimumHeight: 200 // 400
    width: 600
    height: 468
    color: Config.options.bar.showBackground ? Appearance.colors.colSurface : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
    
    ColumnLayout {
        anchors {
            fill: parent
            margins: contentPadding
        }
        spacing: 0
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: false
            implicitHeight: 40
            Text {
                id: labelSettings
                anchors.left: parent.left 
                anchors.margins: 14
                anchors.verticalCenter: parent.verticalCenter
                text: Translation.tr("Settings")
                color: "white"
            }

            Text {
                anchors.left: labelSettings.right
                anchors.margins: 152
                anchors.verticalCenter: parent.verticalCenter
                text: Translation.tr("Display")
                color: "white"
            }

        }
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0
            Item {
                id: navRailWrapper
                Layout.fillHeight: true
                Layout.margins: 10
                Layout.topMargin: 0
                implicitWidth: 200
                NavigationRail {
                    id: navRail 
                    anchors {
                        left: parent.left 
                        top: parent.top 
                        //bottom: parent.bottom
                    }
                    spacing: 10
                    expanded: root.width > 900
                    ClippingRectangle {
                        width: navRailWrapper.implicitWidth
                        height: columnLayoutNavRail.implicitHeight
                        radius: Appearance.rounding.normal
                        color: "transparent"
                        ColumnLayout {
                            id: columnLayoutNavRail
                            spacing: 2
                            Repeater {
                                model: root.pages
                                delegate: Rectangle {
                                    required property var index
                                    required property var modelData
                                    implicitWidth: navRailWrapper.implicitWidth
                                    implicitHeight: 30
                                    color: Appearance.colors.colSurfaceContainer
                                    radius: Appearance.rounding.unsharpen
                                    MouseArea {
                                        anchors.fill: parent 
                                        hoverEnabled: true 
                                        onClicked: root.currentPage = index;
                                    }
                                    RowLayout {
                                        anchors.fill: parent 
                                        StyledMaterialSymbol {
                                            anchors.left: parent.left 
                                            anchors.margins: 10
                                            text: modelData.icon
                                            color: "white"
                                        }
                                        Text {
                                            anchors.centerIn: parent
                                            text: modelData.name
                                            color: "white"
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Loader{
                    id: pageLoader 
                    anchors.fill: parent
                    opacity: 1.0
                    active: Config.ready
                    Component.onCompleted: {
                        source = root.pages[0].component
                    }
                    Connections {
                        target: root
                        function onCurrentPageChanged() {
                            if (pageLoader.sourceComponent !== root.pages[root.currentPage].component) {
                                switchAnim.complete();
                                switchAnim.start();
                            }
                        }
                    }
                    SequentialAnimation {
                        id: switchAnim

                        NumberAnimation {
                            target: pageLoader
                            properties: "opacity"
                            from: 1
                            to: 0
                            duration: 100
                            easing.type: Appearance.animation.elementMoveExit.type
                            easing.bezierCurve: Appearance.animationCurves.emphasizedFirstHalf
                        }
                        ParallelAnimation {
                            PropertyAction {
                                target: pageLoader
                                property: "source"
                                value: root.pages[root.currentPage].component
                            }
                            PropertyAction {
                                target: pageLoader
                                property: "anchors.topMargin"
                                value: 20
                            }
                        }
                        ParallelAnimation {
                            NumberAnimation {
                                target: pageLoader
                                properties: "opacity"
                                from: 0
                                to: 1
                                duration: 200
                                easing.type: Appearance.animation.elementMoveEnter.type
                                easing.bezierCurve: Appearance.animationCurves.emphasizedLastHalf
                            }
                            NumberAnimation {
                                target: pageLoader
                                properties: "anchors.topMargin"
                                to: 0
                                duration: 200
                                easing.type: Appearance.animation.elementMoveEnter.type
                                easing.bezierCurve: Appearance.animationCurves.emphasizedLastHalf
                            }
                        }
                    }
                }
            }
        }
    }
}
