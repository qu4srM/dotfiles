import qs
import qs.configs
import qs.modules.sidebarleft 
import "./calendarLayout.js" as CalendarLayout
import qs.widgets 
import qs.utils


import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

Item {
    id: root 
    property bool collapsed: Persistent.states.sidebarleft.calendar.collapsed
    property int monthShift: 0
    property var viewingDate: CalendarLayout.getDateInXMonthsTime(monthShift)
    property var calendarLayout: CalendarLayout.getCalendarLayout(viewingDate, monthShift === 0)
    implicitWidth: parent.width
    implicitHeight: collapsed ? buttonCollapsed.implicitHeight : columnLayout.implicitHeight + buttonCollapsed.implicitHeight + 10
    Behavior on implicitHeight {
        NumberAnimation {
            duration: Appearance.animation.elementMove.duration
            easing.type: Appearance.animation.elementMove.type
                easing.bezierCurve: Appearance.animation.elementMove.bezierCurve
        }
    }

    function setCollapsed() {
        Persistent.states.sidebarleft.calendar.collapsed = !Persistent.states.sidebarleft.calendar.collapsed
    }
    MouseArea {
        anchors.fill: parent
        onWheel: (event) => {
            if (event.angleDelta.y > 0) {
                monthShift--;
            } else if (event.angleDelta.y < 0) {
                monthShift++;
            }
        }
    }

    

    ActionButtonIcon {
        id: buttonCollapsed
        anchors.right: parent.right 
        anchors.top: parent.top 
        anchors.margins: 10
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
    ColumnLayout {
        id: columnLayout
        anchors.fill: parent 
        anchors.margins: 10
        anchors.topMargin: 50
        spacing: 3
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            ActionButton {
                colBackground: Appearance.colors.colSecondary
                colBackgroundHover: Appearance.colors.colSecondaryHover
                buttonText: `${monthShift != 0 ? "• " : ""}${viewingDate.toLocaleDateString(Qt.locale(), "MMMM yyyy")}`
                implicitHeight: 28
                buttonRadius: Appearance.rounding.full
                onClicked: {
                    monthShift = 0;
                }
                StyledToolTip {
                    visible: monthShift !== 0
                    content: Translation.tr("Jump to current month")
                }
            }
            Item {
                Layout.fillWidth: true
                
            }
            ActionButtonIcon {
                colBackground: Appearance.colors.colSecondary
                colBackgroundHover: Appearance.colors.colSecondaryHover
                iconMaterial: "chevron_left"
                implicitHeight: 28
                buttonRadius: Appearance.rounding.full
                iconSize: 18
                onClicked: {
                    monthShift--;
                }
            }
            ActionButtonIcon {
                colBackground: Appearance.colors.colSecondary
                colBackgroundHover: Appearance.colors.colSecondaryHover
                iconMaterial: "chevron_right"
                implicitHeight: 28
                buttonRadius: Appearance.rounding.full
                iconSize: 18
                onClicked: {
                    monthShift++;
                }
            }
        }
        RowLayout {
            id: weekDaysRow
            Layout.fillHeight: false
            Layout.alignment: Qt.AlignHCenter
            spacing: 30
            Repeater {
                model: CalendarLayout.weekDays
                delegate: Rectangle {
                    implicitWidth: 30 
                    implicitHeight: 30
                    color: "transparent"
                    StyledText {
                        anchors.fill: parent 
                        horizontalAlignment: Text.AlignHCenter
                        font.weight: Appearance.font.weight.bold
                        text: Translation.tr(modelData.day)
                    }
                }
            }
        }
        Repeater {
            model: 6
            delegate: RowLayout {
                required property var modelData
                Layout.alignment: Qt.AlignHCenter
                spacing: 30
                Repeater {
                    model: Array(7).fill(modelData)
                    delegate: Rectangle { 
                        property int isToday: calendarLayout[modelData][index].today
                        implicitWidth: 30
                        implicitHeight: 30
                        color: isToday === 1 ? Appearance.colors.colPrimary : "transparent"
                        radius: Appearance.rounding.full
                        StyledText {
                            anchors.fill: parent 
                            horizontalAlignment: Text.AlignHCenter
                            text: root.calendarLayout[modelData][index].day
                            color: (isToday === 1) ? Appearance.colors.colOnPrimary : 
                                (isToday === 0) ? "white" : 
                                Appearance.colors.colOutline
                            Behavior on color {
                                animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
                            }
                        }
                    }
                }
            }
        }

    }
}