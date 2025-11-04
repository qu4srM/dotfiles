pragma Singleton

import qs.configs
import qs.utils

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root 

    property var allWallpapers: []
    property int numItems: 0
    property string actualCurrent: Config.options.background.wallpaperPath
    property string actualCurrentOverlay
    property string namePathWallpaper

    Process {
        id: setProc
    }

    function updateMaterialColor(mode) {
        const wall = Config.options.background.wallpaperPath
        let selectedMode = mode ? mode : (Theme.options.darkmode ? "dark" : "light")
        const cmd = `python3 ~/.config/quickshell/scripts/generate_colors.py --path "${wall}" --mode ${selectedMode} > ~/.config/quickshell/theme.json`
        setProc.command = ["bash", "-c", cmd]
        setProc.startDetached()
    }



    function updateWallpapers () {
        wallpapersList.running = true
    }

    function updateOverlay (url: string) {
        namePathWallpaper = url
        checkOverlay.running = true
    }

    function updateAll () {
        updateWallpapers();
        updateOverlay(Config.options.background.wallpaperPath);
    }

    Process {
        id: wallpapersList
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

    // --- NUEVO: chequear si ya existe el overlay ---
    Process {
        id: checkOverlay
        property string overlayPath: `${root.namePathWallpaper}-overlay.png`

        command: [
            "bash", "-c",
            `if [ -f ${overlayPath} ]; then echo "EXISTS:${overlayPath}"; else echo "NOTEXISTS"; fi`
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                if (text.startsWith("EXISTS:")) {
                    const path = text.replace("EXISTS:", "").trim()
                    Config.options.background.wallpaperOverlayPath = path
                    console.log("Overlay ya existe:", path)
                } else {
                    console.log("Overlay no existe, creando...")
                    createOverlay.running = true
                }
            }
        }
    }

    Process {
        id: createOverlay
        command: [
            "bash", "-c",
            `~/.local/share/pipx/venvs/rembg/bin/python ~/.config/quickshell/scripts/create_depth_image_rembg.py ${Config.options.background.wallpaperPath} ${root.namePathWallpaper}-overlay.png`
        ]

        stdout: StdioCollector {
            onTextChanged: console.log("stdout:", text)
        }

        stderr: StdioCollector {
            onTextChanged: {
                console.log("stderr:", text)
                if (text.includes("Success")) {
                    let match = text.match(/→ (.*\.png)/)
                    if (match) {
                        Config.options.background.wallpaperOverlayPath = match[1].trim()
                        console.log("Overlay generado en:", Config.options.background.wallpaperOverlayPath)
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        wallpapersList.running = true
    }
}
