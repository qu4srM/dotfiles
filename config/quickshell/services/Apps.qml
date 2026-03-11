pragma Singleton

import qs
import qs.configs
import qs.services
import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

Singleton {
    id: root
    
    property bool visibleOptions: false
    property var lastClickApp
    property real lastClickedPositionApp
    property var options: ({
        "New Window": {
            execute: function() {
                lastClickApp.app?.execute()
                visibleOptions = false
            }
        },
        "Move to Special Workspace": {
            execute: function() {
                console.log("Special Workspace")
            }
        },
        "Show Overview": {
            execute: function() {
                console.log(HyprlandData.windowByAddress[`0x${lastClickApp.windows[0].HyprlandToplevel.address}`].workspace.id)
            }
        },
        /*
        "Close Window": {
            execute: function() {
                if (!lastClickApp?.windows?.length)
                    return

                let win = lastClickApp.windows[lastClickApp.windows.length - 1]
                win.close()

                visibleOptions = false
                let res
                for (let win of lastClickApp.windows) {
                    console.log(win.HyprlandToplevel.address)
                }
                console.log(Object.keys(HyprlandData.windowByAddress[`0x${lastClickApp.windows[0].HyprlandToplevel.address}`]))
            }
        },*/
        "Close All Windows": {
            execute: function() {
                if (!lastClickApp?.windows?.length)
                    return

                for (let win of lastClickApp.windows) {
                    win.close()
                }

                visibleOptions = false
            }
        }
    })

    property list<var> apps: {
        let result = []

        /* === NORMALIZER === */
        function normalizeId(id) {
            return id
                ?.toLowerCase()
                .replace(".desktop", "")
                .trim()
        }

        /* === 1. LAUNCHER === */
        result.push({
            type: "launcher",
            icon: "arch-symbolic.svg",
            name: "Launcher"
        })

        /* === MAPA DE APPS ABIERTAS === */

        let openApps = new Map()

        for (const tl of ToplevelManager.toplevels.values) {
            if (!tl.appId) continue

            let id = normalizeId(tl.appId)

            if (!openApps.has(id))
                openApps.set(id, [])

            openApps.get(id).push(tl)
        }

        /* === PINNED === */
        let pinned =
            (Config.options.dock.pinnedApps || [])
                .map(p => normalizeId(p))

        let apps = DesktopEntries.applications.values
        let usedIds = new Set()

        for (let p of pinned) {
            let app = apps.find(a => {
                if (!a || !a.icon) return false

                let name = normalizeId(a.name)
                let id = normalizeId(a.id)

                return p === name || p === id
            })

            if (app) {
                let appId = normalizeId(app.id)

                if (appId) usedIds.add(appId)

                let windows = openApps.get(appId) || []

                result.push({
                    type: "app",
                    app: app,
                    appId: appId,
                    running: windows.length > 0,
                    windows: windows,
                    windowTitles: windows.map(w => w.title),
                    appTitle: windows.length > 0 ? windows[0].title : ""
                })
            }
        }

        /* === RUNNING (NO PINNED) === */
        for (const [appId, windows] of openApps) {
            if (usedIds.has(appId)) continue

            let app = apps.find(a =>
                normalizeId(a?.id) === appId
            )

            if (app && app.icon) {
                result.push({
                    type: "app",
                    app: app,
                    appId: appId,
                    running: true,
                    temporary: true,
                    windows: windows,
                    windowTitles: windows.map(w => w.title),
                    appTitle: windows.length > 0 ? windows[0].title : ""
                })
            }
        }

        return result
            
    }

    function setLastApp(name) {
        lastClickApp = name
    }

    function addClickedPosition(item) {
        lastClickedPositionApp = item.x
    }
    
}