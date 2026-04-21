import qs
import qs.configs
import qs.configs.utils
import qs.widgets
import qs.services

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: stopwatch

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    ColumnLayout {
        id: layout
        spacing: 6

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: Translation.tr("Stopwatch")
            font.pixelSize: Appearance.font.pixelSize.normal
            color: Appearance.colors.colOutline
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: 40
            color: Appearance.colors.colOnSurface

            text: {
                let t = Math.floor(TimerService.stopwatchTime)

                let minutes = Math.floor(t/6000).toString().padStart(2,'0')
                let seconds = Math.floor((t/100)%60).toString().padStart(2,'0')
                let ms = (t%100).toString().padStart(2,'0')

                return `${minutes}:${seconds}.${ms}`
            }
        }
        ListView {
            width: 240
            height: 80
            orientation: ListView.Horizontal
            clip: true
            spacing: 10

            model: TimerService.stopwatchLaps

            delegate: Rectangle {
                id: lap
                required property var modelData
                required property int index

                implicitWidth: 90
                implicitHeight: 70

                radius: Appearance.rounding.normal
                color: "transparent"

                border.width: 1
                border.color: index === TimerService.stopwatchLaps.length - 1 ? "white" : "#232323"

                Column {
                    anchors.centerIn: parent
                    spacing: 4

                    StyledText {
                        text: `Lap ${index + 1}`
                        horizontalAlignment: Text.AlignHCenter
                        color: "white"
                    }

                    // Tiempo de la vuelta
                    StyledText {
                        horizontalAlignment: Text.AlignHCenter
                        color: "#aaaaaa"
                        font.pixelSize: Appearance.font.pixelSize.small

                        text: {
                            let lapTime

                            if (index === 0)
                                lapTime = 0
                            else
                                lapTime = modelData - TimerService.stopwatchLaps[index - 1]

                            let minutes = Math.floor(lapTime/6000).toString().padStart(2,'0')
                            let seconds = Math.floor((lapTime/100)%60).toString().padStart(2,'0')
                            let ms = (lapTime%100).toString().padStart(2,'0')

                            return `+${minutes}:${seconds}.${ms}`
                        }
                    }

                    // Tiempo total
                    StyledText {
                        horizontalAlignment: Text.AlignHCenter
                        color: "white"
                        font.pixelSize: Appearance.font.pixelSize.small

                        text: {
                            let t = modelData

                            let minutes = Math.floor(t/6000).toString().padStart(2,'0')
                            let seconds = Math.floor((t/100)%60).toString().padStart(2,'0')
                            let ms = (t%100).toString().padStart(2,'0')

                            return `${minutes}:${seconds}.${ms}`
                        }
                    }
                }
            }
        }


        ActionButtonIcon {
            Layout.fillWidth: true
            implicitHeight: 50

            colBackground: Appearance.colors.colPrimary
            colBackgroundHover: Appearance.colors.colPrimaryHover

            iconMaterial: TimerService.stopwatchRunning
                        ? "pause"
                        : "play_arrow"

            materialIconFill: true
            iconSize: 20
            buttonRadius: TimerService.stopwatchRunning ? Appearance.rounding.unsharpenmore : Appearance.rounding.normal

            changeColor: true
            iconColor: Appearance.colors.colOnPrimary

            onClicked: TimerService.toggleStopwatch()
        }

        ActionButtonIcon {
            Layout.fillWidth: true
            implicitHeight: 30

            colBackground: Appearance.colors.colSurfaceContainerLow
            colBackgroundHover: Appearance.colors.colPrimaryHover

            iconMaterial: TimerService.stopwatchRunning
                        ? "flag"
                        : "restart_alt"

            materialIconFill: true
            iconSize: 20
            buttonRadius: Appearance.rounding.normal

            changeColor: true
            iconColor: Appearance.colors.colPrimary

            onClicked: {
                if (TimerService.stopwatchRunning)
                    TimerService.stopwatchRecordLap()
                else
                    TimerService.stopwatchReset()
            }
        }

        
    }

}
