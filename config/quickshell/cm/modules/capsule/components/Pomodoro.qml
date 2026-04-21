import qs
import qs.configs
import qs.configs.utils
import qs.widgets
import qs.services

import QtQuick
import QtQuick.Layouts

Item {
    id: pomodoro

    implicitWidth: pomodoroLayout.implicitWidth + 70
    implicitHeight: pomodoroLayout.implicitHeight

    ColumnLayout {
        id: pomodoroLayout
        anchors.centerIn: parent
        StyledText {
            Layout.alignment: Qt.AlignHCenter 
            text: Translation.tr("Timers")
            font.pixelSize: Appearance.font.pixelSize.normal
            color: Appearance.colors.colOutline
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: TimerService.pomodoroLongBreak
                ? Translation.tr("Long break")
                : TimerService.pomodoroBreak
                    ? Translation.tr("Break")
                    : Translation.tr("Focus")

            font.pixelSize: Appearance.font.pixelSize.normal
            color: Appearance.colors.colOutline
        }

        CircularProgress {
            Layout.alignment: Qt.AlignHCenter
            w: 160
            h: 160
            strokeWidth: 5

            value: TimerService.pomodoroSecondsLeft / TimerService.pomodoroLapDuration

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 0

                StyledText {
                    Layout.alignment: Qt.AlignHCenter

                    text: {
                        let m = Math.floor(TimerService.pomodoroSecondsLeft / 60).toString().padStart(2,'0')
                        let s = Math.floor(TimerService.pomodoroSecondsLeft % 60).toString().padStart(2,'0')
                        return `${m}:${s}`
                    }

                    font.pixelSize: 30
                    color: Appearance.colors.colOnSurface
                }

                ActionButtonIcon {
                    Layout.alignment: Qt.AlignHCenter

                    colBackground: "transparent"
                    buttonRadius: Appearance.rounding.verylarge

                    implicitWidth: 50
                    implicitHeight: 40

                    iconMaterial: "restart_alt"
                    materialIconFill: true
                    iconSize: 30

                    changeColor: true
                    iconColor: Appearance.colors.colPrimary

                    onClicked: TimerService.resetPomodoro()
                }
            }

            Rectangle {
                radius: Appearance.rounding.full
                color: Appearance.colors.colPrimary

                anchors.right: parent.right
                anchors.bottom: parent.bottom

                implicitWidth: 24
                implicitHeight: implicitWidth

                StyledText {
                    anchors.centerIn: parent
                    color: Appearance.colors.colOnText
                    text: TimerService.pomodoroCycle + 1
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 5

            ActionButton {
                buttonText: "+1:00"
                colBackground: Appearance.colors.colSurfaceContainerLow
                colBackgroundHover: Appearance.colors.colPrimaryHover

                buttonRadius: Appearance.rounding.verylarge

                implicitWidth: 80
                implicitHeight: 40

                changeColor: true
                textColor: Appearance.colors.colPrimary

                onClicked: TimerService.addTimePomodoro(60)
            }

            ActionButtonIcon {
                colBackground: Appearance.colors.colPrimary
                colBackgroundHover: Appearance.colors.colPrimaryHover

                buttonRadius: TimerService.pomodoroRunning ? Appearance.rounding.unsharpenmore : Appearance.rounding.normal

                implicitWidth: 80
                implicitHeight: 40

                iconMaterial: TimerService.pomodoroRunning ? "pause" : "play_arrow"

                materialIconFill: true
                iconSize: 20

                changeColor: true
                iconColor: Appearance.colors.colOnPrimary

                onClicked: TimerService.togglePomodoro()
            }
        }
        /*
        StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: `${TimerService.cyclesBeforeLongBreak} ciclos de ${(TimerService.focusTime/60)} min trabajo + ${(TimerService.breakTime/60)} min descanso`
            color: Appearance.colors.colOutline
            font.pixelSize: 13
        }*/
    }

}
