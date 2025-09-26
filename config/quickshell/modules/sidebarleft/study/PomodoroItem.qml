import qs
import qs.configs
import qs.utils 
import qs.widgets
import qs.services

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

Rectangle {
    anchors.fill: parent
    anchors.topMargin: 40
    color: "transparent"
    clip: true
    ColumnLayout {
        anchors.fill: parent 
        spacing: 4
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 8

            TextField {
                id: input
                placeholderText: Translation.tr("Hours")
                placeholderTextColor: Appearance.colors.colOutline
                width: 120
                inputMethodHints: Qt.ImhDigitsOnly
                renderType: Text.NativeRendering
                background: Rectangle {
                    anchors.fill: parent 
                    color: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainerHighest : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                    radius: Appearance.rounding.verysmall
                    border.width: input.activeFocus ? 1 : 0
                    border.color: Appearance.colors.colPrimary
                }
                color: Appearance.colors.colInverseSurface
                
                cursorDelegate: Rectangle {
                    width: 3
                    color: input.activeFocus ? Appearance.colors.colPrimary : "transparent"
                    radius: 1
                }
            }

            ActionButton {
                buttonText: "Configurar"
                implicitWidth: 100
                implicitHeight: 30
                colBackground: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainerLow : "transparent"
                colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colPrimaryHover : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                buttonRadius: Appearance.rounding.verylarge
                textColor: Appearance.colors.colPrimary
                onClicked: {
                    if (input.text.length > 0) {
                        Timers.configurePomodoro(parseInt(input.text))
                        Quickshell.execDetached([
                            "notify-send",
                            "Pomodoro",
                            `${Timers.cyclesBeforeLongBreak} ciclos de ${(Timers.focusTime/60)} min trabajo + ${(Timers.breakTime/60)} min descanso`,
                            "-a", "Shell"
                        ])
                    }
                }
            }
        }
        StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: Timers.pomodoroLongBreak ? Translation.tr("Long break") : Timers.pomodoroBreak ? Translation.tr("Break") : Translation.tr("Focus")
            font.pixelSize: Appearance.font.pixelSize.normal
            color: Appearance.colors.colOutline
        }
        CircularProgress {
            Layout.alignment: Qt.AlignHCenter
            w: 160
            h: 160
            strokeWidth: 7
            value: {
                return Timers.pomodoroSecondsLeft / Timers.pomodoroLapDuration;
            }
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 0

                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    text: {
                        let minutes = Math.floor(Timers.pomodoroSecondsLeft / 60).toString().padStart(2, '0');
                        let seconds = Math.floor(Timers.pomodoroSecondsLeft % 60).toString().padStart(2, '0');
                        return `${minutes}:${seconds}`;
                    }
                    font.pixelSize: 40
                    color: Appearance.colors.colOnSurface
                }
                ActionButtonIcon {
                    Layout.alignment: Qt.AlignHCenter
                    colBackground: Config.options.bar.showBackground ? "transparent" : "transparent"
                    colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colSecondaryContainerHover : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                    buttonRadius: Appearance.rounding.verylarge
                    implicitWidth: 50
                    implicitHeight: 40
                    iconMaterial: "restart_alt"
                    materialIconFill: true
                    iconSize: 30
                    changeColor: true 
                    iconColor: Appearance.colors.colPrimary
                    onClicked: Timers.resetPomodoro()
                }
            }

            Rectangle {
                radius: Appearance.rounding.full
                color: Appearance.colors.colPrimary
                
                anchors {
                    right: parent.right
                    bottom: parent.bottom
                }
                implicitWidth: 24
                implicitHeight: implicitWidth

                StyledText {
                    id: cycleText
                    anchors.centerIn: parent
                    color: Appearance.colors.colOutline
                    text: Timers.pomodoroCycle + 1
                }
            }
        }
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            width: parent.implicitWidth
            spacing: 5
            ActionButton {
                buttonText: "+1:00"
                colBackground: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainerLow : "transparent"
                colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colPrimaryHover : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                buttonRadius: Appearance.rounding.verylarge
                implicitWidth: 90
                implicitHeight: 50
                changeColor: true 
                textColor: Appearance.colors.colPrimary
                onClicked: Timers.addTimePomodoro(60)
            }
            ActionButtonIcon {
                colBackground: Config.options.bar.showBackground ? Appearance.colors.colPrimary : "transparent"
                colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colPrimaryHover : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                buttonRadius: Appearance.rounding.verylarge
                implicitWidth: 90
                implicitHeight: 50
                iconMaterial: Timers.pomodoroRunning ? "pause" : (Timers.pomodoroSecondsLeft === Timers.focusTime) ? "play_arrow" : "resume"
                materialIconFill: true
                iconSize: 20
                changeColor: true 
                iconColor: Appearance.colors.colOnPrimary
                onClicked: Timers.togglePomodoro()
            }
        }
        StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: `${Timers.cyclesBeforeLongBreak} ciclos de ${(Timers.focusTime/60)} min trabajo + ${(Timers.breakTime/60)} min descanso`
            color: Appearance.colors.colOutline
            font.pixelSize: 13
        }
    }
}