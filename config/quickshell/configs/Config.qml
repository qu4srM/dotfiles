pragma Singleton
pragma ComponentBehavior: Bound

import qs.utils

import QtQuick
import Quickshell
import Quickshell.Io


Singleton {
    id: root
    property string filePath: Paths.config + "/quickshell/config.json"
    property alias options: configOptionsJsonAdapter
    property bool ready: false

    FileView {
        path: root.filePath
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        onLoaded: root.ready = true
        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                writeAdapter();
            }
        }
        JsonAdapter {
            id: configOptionsJsonAdapter

            property JsonObject appearance: JsonObject {
                property bool extraBackgroundTint: true
                property int fakeScreenRounding: 2 // 0: None | 1: Always | 2: When not fullscreen
                property JsonObject transparency: JsonObject {
                    property bool enable: false
                    property bool automatic: true
                    property real backgroundTransparency: 0.11
                    property real contentTransparency: 0.57
                }
                property JsonObject wallpaperTheming: JsonObject {
                    property bool enableAppsAndShell: true
                    property bool enableQtApps: true
                    property bool enableTerminal: true
                }
                property JsonObject palette: JsonObject {
                    property string type: "auto" // Allowed: auto, scheme-content, scheme-expressive, scheme-fidelity, scheme-fruit-salad, scheme-monochrome, scheme-neutral, scheme-rainbow, scheme-tonal-spot
                }
                property JsonObject shapes: JsonObject {
                    property bool enable: true 
                    property string shape: "circle"
                }
            }

            property JsonObject audio: JsonObject {
                // Values in %
                property JsonObject protection: JsonObject {
                    // Prevent sudden bangs
                    property bool enable: true
                    property real maxAllowedIncrease: 10
                    property real maxAllowed: 90 // Realistically should already provide some protection when it's 99...
                }
            }

            property JsonObject background: JsonObject {
                property bool fixedClockPosition: false
                property real clockX: -500
                property real clockY: -500
                property string wallpaperPath: ""
                property string wallpaperOverlayPath: ""
                property string thumbnailPath: ""
                property JsonObject parallax: JsonObject {
                    property bool enableWorkspace: true
                    property real workspaceZoom: 1.07 // Relative to your screen, not wallpaper size
                    property bool enableSidebar: true
                }
            }

            property JsonObject bar: JsonObject {
                property bool floating: false
                property JsonObject autoHide: JsonObject {
                    property bool enable: false
                    property bool pushWindows: false
                    property JsonObject showWhenPressingSuper: JsonObject {
                        property bool enable: true
                        property int delay: 140
                    }
                }
                property bool bottom: false // Instead of top
                property int cornerStyle: 0 // 0: Hug | 1: Float | 2: Plain rectangle
                property bool borderless: false // true for no grouping of items
                property string topLeftIcon: "spark" // Options: distro, spark
                property bool showBackground: true
                property bool verbose: true
                property JsonObject resources: JsonObject {
                    property bool alwaysShowSwap: true
                    property bool alwaysShowCpu: false
                }
                property list<string> screenList: [] // List of names, like "eDP-1", find out with 'hyprctl monitors' command
                property JsonObject utilButtons: JsonObject {
                    property bool showScreenSnip: true
                    property bool showColorPicker: false
                    property bool showMicToggle: false
                    property bool showKeyboardToggle: true
                    property bool showDarkModeToggle: true
                    property bool showPerformanceProfileToggle: false
                }
                property JsonObject tray: JsonObject {
                    property bool monochromeIcons: true
                }
                property JsonObject workspaces: JsonObject {
                    property bool monochromeIcons: true
                    property int shown: 10
                    property bool showAppIcons: true
                    property bool alwaysShowNumbers: false
                    property int showNumberDelay: 300 // milliseconds
                }
                property JsonObject weather: JsonObject {
                    property bool enable: false
                    property bool enableGPS: true // gps based location
                    property string city: "" // When 'enableGPS' is false
                    property bool useUSCS: false // Instead of metric (SI) units
                    property int fetchInterval: 10 // minutes
                }
            }

            property JsonObject battery: JsonObject {
                property int low: 20
                property int critical: 5
                property bool automaticSuspend: true
                property int suspend: 3
            }

            property JsonObject dock: JsonObject {
                property bool enable: false
                property bool monochromeIcons: false
                property real height: 60
                property real hoverRegionHeight: 2
                property bool pinnedOnStartup: false
                property bool hoverToReveal: true // When false, only reveals on empty workspace
                property list<string> pinnedApps: [ // IDs of pinned entries
                    "org.kde.dolphin", "kitty", "code-oss", "zen", "burpsuite", "steam", "lutris", "discord", "blender", "eclipse", "spotify", "obsidian", "onlyoffice-desktopeditors"]
                property list<string> ignoredAppRegexes: []
            }
            property JsonObject launcher: JsonObject {
                property real rowsApps: 4
                property real columnsApps: 5
            }

            property JsonObject interactions: JsonObject {
                property JsonObject scrolling: JsonObject {
                    property bool fasterTouchpadScroll: true // Enable faster scrolling with touchpad
                    property int mouseScrollDeltaThreshold: 120 // delta >= this then it gets detected as mouse scroll rather than touchpad
                    property int mouseScrollFactor: 120
                    property int touchpadScrollFactor: 450
                }
            }

            property JsonObject language: JsonObject {
                property string engine: "es_CO"
            }

            property JsonObject light: JsonObject {
                property JsonObject night: JsonObject {
                    property bool automatic: true
                    property string from: "19:00" // Format: "HH:mm", 24-hour time
                    property string to: "06:30"   // Format: "HH:mm", 24-hour time
                    property int colorTemperature: 5000
                }
            }

            property JsonObject media: JsonObject {
                // Attempt to remove dupes (the aggregator playerctl one and browsers' native ones when there's plasma browser integration)
                property bool filterDuplicatePlayers: true
            }
            property JsonObject notion: JsonObject {
                property string token: ""
                property string database_id: ""
                property string data_source_id: ""
            }
            property JsonObject notification: JsonObject {
                property int timeout: 7000
            }

            property JsonObject osd: JsonObject {
                property int timeout: 1000
            }

            property JsonObject osk: JsonObject {
                property string layout: "qwerty_full"
                property bool pinnedOnStartup: false
            }

            property JsonObject overview: JsonObject {
                property bool enable: true
                property real scale: 0.18
                property real rows: 2
                property real columns: 5
            }

            property JsonObject time: JsonObject {
                // https://doc.qt.io/qt-6/qtime.html#toString
                property string format: "hh:mm A"
                property string dateFormat: "ddd MMM dd"
                property string hour: "h A"
                property string minutes: "mm"
                property string meridiem: "A"
                property JsonObject pomodoro: JsonObject {
                    property string alertSound: ""
                    property int breakTime: 300
                    property int cyclesBeforeLongBreak: 4
                    property int focus: 1500
                    property int longBreak: 900
                }
            }
            property JsonObject hacking: JsonObject {
                property string platform: "hackthebox" // hackthebox, hacktheboxacademy and tryhackme
                property string vpn: ""
                property string targetIp: ""
                property string folder: ""
            }

            property JsonObject user: JsonObject {
                property string avatar: ""
            }

            property JsonObject windows: JsonObject {
                property bool showTitlebar: true // Client-side decoration for shell apps
                property bool centerTitle: true
            }

            property JsonObject hacks: JsonObject {
                property int arbitraryRaceConditionDelay: 20 // milliseconds
            }

            property JsonObject screenshotTool: JsonObject {
                property bool showContentRegions: true
            }
            property JsonObject sounds: JsonObject {
                property string theme: "freedesktop"
                property bool battery: false
            }
        }
    }
}
