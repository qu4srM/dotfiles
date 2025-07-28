pragma Singleton

import "root:/utils/"

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root 

    property var allWallpapers: []
    property int numItems: 0
    property string actualCurrent
    readonly property string currentNamePath: Paths.expandTilde("~/.config/quickshell/utils/data/path.txt")


    function setWallpaper(path: string): void {
        actualCurrent = path
    }

    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: scan.running = true
    }

    Process {
        id: scan
        command: [
            "bash", "-c",
            "dir=\"$HOME/Pictures/Wallpapers\"; " +
            "find \"$dir\" -maxdepth 1 -type f \\( -iname \"*.jpg\" -o -iname \"*.jpeg\" -o -iname \"*.png\" \\) " +
            "-printf '%f::%p\\n' | sort"
        ]

        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().length ? text.trim().split('\n') : [];
                root.numItems = lines.length;
                root.allWallpapers = lines.map(l => {
                    const [name, abs] = l.split("::");
                    return { name, path: "file://" + abs };
                });
            }
        }
    }
    FileView {
        path: root.currentNamePath
        watchChanges: true
        onFileChanged: this.reload()
        onLoaded: {
            root.actualCurrent = text().trim()
        }
    }
    Component.onCompleted: scan.start()
}