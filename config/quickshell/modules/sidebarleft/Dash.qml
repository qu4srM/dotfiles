import qs
import qs.configs
import qs.modules.sidebarleft 
import "./dash/calendarLayout.js" as CalendarLayout
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

    property int monthShift: 0
    property var viewingDate: CalendarLayout.getDateInXMonthsTime(monthShift)
    property var calendarLayout: CalendarLayout.getCalendarLayout(viewingDate, monthShift === 0)
    Rectangle {
        anchors.fill: parent 
        color: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
    
    /*
    Item {
        id: start 
        anchors.top: parent.top
        implicitHeight: 240
        implicitWidth: root.implicitWidth
        
        RowLayout {
            spacing: 10

            Rect {
                width: 3 + columnSliders.implicitWidth * 3
                height: columnSliders.implicitHeight
                color: Appearance.colors.colsecondary
                radius: Appearance.rounding.small

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2
                    StyledText { text: "OS: Arch Linux"; font.pixelSize: 12 }
                    StyledText { text: "Terminal: Kitty"; font.pixelSize: 12 }
                    StyledText { text: "Uptime: 120 min"; font.pixelSize: 12 }
                }
            }
            ColumnLayout {
                id: columnSliders
                spacing: 10
                Rect {
                    width: root.implicitWidth / 4
                    height: 60
                    color: Appearance.colors.colsecondary
                    radius: Appearance.rounding.small

                    StyledText {
                        anchors.centerIn: parent
                        text: "10°"
                        font.pixelSize: 40
                    }
                }
                Rect {
                    width: root.implicitWidth / 4
                    height: 140
                    color: Appearance.colors.colsecondary
                    radius: Appearance.rounding.small

                    Row {
                        anchors.centerIn: parent 
                        spacing: 10 
                        ProgressBarV { implicitHeight: 100 }
                        ProgressBarV { implicitHeight: 100 }
                        ProgressBarV { implicitHeight: 100 }
                    }
                }
            }
            
        }
    }
    Rect {
        id: center
        anchors.top: start.bottom
        implicitHeight: 300
        implicitWidth: root.implicitWidth
        color: "black"
    }

    Rect {
        id: end
        anchors.top: center.bottom
        implicitWidth: root.implicitWidth
        implicitHeight: phrase.implicitHeight + phrase.anchors.margins * 2
        color: Appearance.colors.colsecondary
        radius: Appearance.rounding.small

        StyledText {
            id: phrase
            anchors.fill: parent
            anchors.margins: 8
            wrapMode: Text.Wrap
            text: "No permitas que tus miedos y debilidades te alejen de tus objetivos. Mantén tu corazón ardiendo. Recuerda que el tiempo no espera a nadie, no te hará compañía."
            color: "#ffffff"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
    }*/ ColumnLayout {
            anchors.fill: parent 
            anchors.margins: 10
            spacing: 10
            Rect {
                id: content2
                implicitWidth: parent.width 
                Layout.fillHeight: true
                color: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainerHigh : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
            }
            Rect {
                id: calendar
                implicitWidth: parent.width
                implicitHeight: 260
                clip: true
                color: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainerHigh : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
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
                ColumnLayout {
                    anchors.fill: parent 
                    anchors.margins: 10
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
                            Layout.fillHeight: false
                            
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
                        width: parent.implicitWidth
                        Layout.alignment: Qt.AlignHCenter
                        Layout.fillHeight: false
                        spacing: 30
                        Repeater {
                            model: CalendarLayout.weekDays
                            delegate: StyledText {
                                font.weight: Appearance.font.weight.bold
                                text: Translation.tr(modelData.day)
                            }
                        }
                    }
                    Repeater {
                        model: 5
                        delegate: RowLayout {
                            required property var modelData
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 25
                            Repeater {
                                model: Array(7).fill(modelData)
                                delegate: Rectangle { 
                                    property int isToday: calendarLayout[modelData][index].today
                                    implicitWidth: 30
                                    implicitHeight: 30
                                    color: isToday === 1 ? Appearance.colors.colPrimary : "transparent"
                                    radius: Appearance.rounding.full
                                    StyledText {
                                        anchors.centerIn: parent
                                        text: root.calendarLayout[modelData][index].day
                                        color: (isToday === 1) ? "white" : 
                                            (isToday === 0) ? "white" : 
                                            Appearance.colors.colOutline
                                    }
                                }
                            }
                        }
                    }

                }
            }
        }
    }
    component Rect: Rectangle {
        radius: Appearance.rounding.small
    }
}
