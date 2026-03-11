pragma Singleton
pragma ComponentBehavior: Bound

import qs.utils
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string filePath: Paths.configPath + "/sticky_notes.json"

    /*
        Estructura:
        {
            "1": [ {x,y,text,color}, ... ],
            "2": [ ... ]
        }
    */
    property var categoryMap: ({
        '#b3b3b3': "Undefined",
        "#b5ead7": "Productive",
        "#ff9aa2": "Work",
        "#c7ceea": "Study",
        '#8ffd67': "Hacking"
    })
    property var categoryColors: Object.keys(categoryMap)

    property var data: ({})
    property string currentWorkspace: "1"

    function categoryNameFromColor(color) {
        if (!color) return ""

        const hex = color.toString().toLowerCase()
        return categoryMap[hex] || ""
    }


    function setWorkspace(id) {
        currentWorkspace = id.toString()
        if (!data[currentWorkspace])
            data[currentWorkspace] = []
    }

    function notesForCurrentWorkspace() {
        return data[currentWorkspace] || []
    }

    function addNote(note) {
        if (!data[currentWorkspace])
            data[currentWorkspace] = []

        data[currentWorkspace].push(note)
        trigger()
    }

    function updateNote(index, note) {
        if (!data[currentWorkspace]) return
        data[currentWorkspace][index] = note
        trigger()
    }

    function deleteNote(index) {
        if (!data[currentWorkspace]) return
        data[currentWorkspace].splice(index, 1)
        trigger()
    }

    function trigger() {
        data = Object.assign({}, data)
        save()
    }

    function save() {
        fileView.setText(JSON.stringify(data))
    }

    function refresh() {
        fileView.reload()
    }

    Component.onCompleted: refresh()

    FileView {
        id: fileView
        path: Qt.resolvedUrl(root.filePath)

        onLoaded: {
            try {
                root.data = JSON.parse(fileView.text())
            } catch(e) {
                root.data = {}
            }
            console.log("[StickyNotes] Loaded")
        }

        onLoadFailed: (error) => {
            if (error === FileViewError.FileNotFound) {
                root.data = {}
                save()
                console.log("[StickyNotes] Created new file")
            }
        }
    }
}
