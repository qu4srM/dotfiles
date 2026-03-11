pragma Singleton

import qs
import qs.utils
import qs.configs

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string url: Config.options.api.calendar
    property var events: []

    property string month: Qt.formatDate(new Date(), "MMMM")
    property int today: new Date().getDate()

    function eventColor(name) {

        switch(name) {

        case "Devocional":
            return "#E3683E"

        case "Rutina de Activación":
            return "#4B99D2"

        case "Study":
            return "#489160"

        case "Lunch":
            return "#E7BA51"

        case "Hacking":
            return "#489160"

        case "Modo Libre":
            return "#DA5234"

        case "Rutina de desactivación":
            return "#4B99D2"

        case "Aprender Habilidad":
            return "#55B080"

        default:
            return "#aaaaaa"
        }
    }

    function processEvents(list) {

        // ordenar
        list.sort(function(a,b) {
            return a.start.localeCompare(b.start)
        })

        // agregar color
        for (let i = 0; i < list.length; i++) {
            list[i].color = eventColor(list[i].title)
        }

        return list
    }

    Process {
        id: calendarProc

        command: [
            "bash",
            "-c",
            `~/.config/quickshell/scripts/calendar_service.sh "${root.url}"`
        ]

        stdout: StdioCollector {
            onStreamFinished: {

                let data = JSON.parse(text)

                root.events = root.processEvents(data)

                console.log("Events loaded:", root.events.length)

            }
        }
    }

    Timer {
        interval: 300000
        running: true
        repeat: true
        onTriggered: calendarProc.running = true
    }
    Component.onCompleted: startDelay.start() 
    Timer {
        id: startDelay
        interval: Config.options.widgets.delay
        repeat: false
        onTriggered: {
            calendarProc.running = true
        }
    }
}