pragma Singleton

import qs.configs
import qs.utils

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string token: Config.options.api.todoist
    property var list: []

    function completeTask(id) {
        let uuid = Qt.createQmlObject(
            'import QtQuick; QtObject { property string v: Qt.md5(Math.random().toString()) }',
            root
        ).v

        completeProc.command = [
            "bash",
            "-c",
            `curl -s https://api.todoist.com/api/v1/sync \
            -H "Authorization: Bearer ${root.token}" \
            -d commands='[
            {
                "type": "item_complete",
                "uuid": "${uuid}",
                "args": {
                    "id": "${id}",
                    "date_completed": "${new Date().toISOString()}"
                }
            }]'`
        ]

        completeProc.running = true 
        //todoistProc.running = true
    }
    Process {
        id: completeProc
    }

    Process {
        id: todoistProc

        command: [
            "bash",
            "-c",
            `curl -s https://api.todoist.com/api/v1/sync \
            -H "Authorization: Bearer ${root.token}" \
            -d sync_token='*' \
            -d resource_types='["items"]'`
        ]

        stdout: StdioCollector {
            id: listCollector

            onStreamFinished: {
                try {
                    let data = JSON.parse(listCollector.text)
                    root.list = data.items
                    console.log("Todoist tasks loaded:", root.list.length)
                } catch(e) {
                    console.log("Todoist JSON error:", e)
                }
            }
        }
    }

    Timer {
        interval: 60000
        running: true
        repeat: true

        onTriggered: todoistProc.running = true
    }
    Component.onCompleted: startDelay.start() 
    Timer {
        id: startDelay
        interval: Config.options.widgets.delay
        repeat: false
        onTriggered: {
            todoistProc.running = true
        }
    }
}