import qs
import qs.configs
import qs.utils 
import qs.widgets
import qs.services
import qs.modules.sidebarleft.study

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: root
    property bool collapsed: Persistent.states.sidebarleft.timers.collapsed
    property int selectedTab: Persistent.states.sidebarleft.timers.tab
    property var tabs: [
        { "type": "pomodoro", "name": Translation.tr("Pomodoro"), "icon": "schedule", "widget": pomodoroItem },
        { "type": "stopwatch", "name": Translation.tr("Stopwatch"), "icon": "timer", "widget": stopwatchItem }
    ]

    color: Config.options.bar.showBackground 
           ? Appearance.colors.colSurfaceContainer 
           : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
    clip: true
    radius: Appearance.rounding.normal

    function setCollapsed() {
        Persistent.states.sidebarleft.timers.collapsed = !Persistent.states.sidebarleft.timers.collapsed
    }

    StyledText {
        anchors.left: parent.left
        anchors.top: parent.top 
        anchors.topMargin: 40 / 2 - font.pixelSize + 6
        anchors.leftMargin: 10
        text: "Timers"
        color: Appearance.colors.colPrimary
        font.pixelSize: 16
    }

    ActionButtonIcon {
        anchors.top: parent.top
        anchors.right: parent.right 
        anchors.margins: 5
        colBackground: Config.options.bar.showBackground 
                       ? Appearance.colors.colSecondaryContainer 
                       : "transparent"
        colBackgroundHover: Config.options.bar.showBackground 
                            ? Appearance.colors.colSecondaryContainerHover 
                            : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
        iconMaterial: root.collapsed ? "keyboard_arrow_up" : "keyboard_arrow_down"
        materialIconFill: true
        iconSize: 20
        changeColor: true 
        iconColor: Appearance.colors.colOnSecondaryContainer
        implicitWidth: 30
        implicitHeight: 30
        buttonRadius: Appearance.rounding.full
        onClicked: root.setCollapsed()
    }

    RowLayout {
        anchors.fill: parent 
        height: 100
        opacity: collapsed ? 1 : 0
        visible: opacity > 0

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: false
            Layout.leftMargin: 10
            Layout.topMargin: 10
            width: tabBar.width + 20

            // Navigation rail buttons
            NavigationRailTabArray {
                id: tabBar
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 5
                currentIndex: root.selectedTab
                expanded: false
                Repeater {
                    model: root.tabs
                    NavigationRailButton {
                        showToggledHighlight: false
                        toggled: root.selectedTab == index
                        buttonText: modelData.name
                        buttonIcon: modelData.icon
                        onClicked: {
                            root.selectedTab = index
                            Persistent.states.sidebarleft.timers.tab = index
                        }
                    }
                }
            }
        }

        StackLayout {
            id: tabStack 
            Layout.fillWidth: true
            height: 100 
            Layout.alignment: Qt.AlignVCenter
            property int realIndex: root.selectedTab
            currentIndex: root.selectedTab

            Repeater {
                model: tabs
                Item {
                    id: tabItem
                    property int tabIndex: index
                    property int animDistance: 5
                    // Opacity: show up only when being animated to
                    opacity: (tabStack.currentIndex === tabItem.tabIndex 
                              && tabStack.realIndex === tabItem.tabIndex) ? 1 : 0
                    // Y: starts animating when user selects a different tab
                    y: (tabStack.realIndex === tabItem.tabIndex) 
                        ? 0 
                        : (tabStack.realIndex < tabItem.tabIndex) ? animDistance : -animDistance

                    Loader {
                        id: tabLoader
                        anchors.fill: parent
                        sourceComponent: modelData.widget
                        focus: root.selectedTab === tabItem.tabIndex
                    }
                }
            }
        }
    }

    Behavior on implicitHeight {
        NumberAnimation {
            duration: Appearance.animation.elementMove.duration
            easing.type: Appearance.animation.elementMove.type
            easing.bezierCurve: Appearance.animation.elementMove.bezierCurve
        }
    }

    Component {
        id: pomodoroItem
        PomodoroItem {
            anchors.fill: parent
        }
    }

    Component {
        id: stopwatchItem
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            StyledText {
                anchors.centerIn: parent
                text: "Nothing for here"
            }
        }
    }
}
