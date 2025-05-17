import { App } from "astal/gtk3"
import { Variable, bind } from "astal"
import { interval,timeout } from "astal/time"

import { sidebarWindowName } from "../components/sidebar/Sidebar"
import { visibleSideBar } from "../components/sidebar/Sidebar"

export function ToggleWindow(windowName: string, visible: Variable<boolean>) {
    const window = App.get_windows().find(w => w.name === windowName)

    if (!window) {
        print(`Ventana "${windowName}" no encontrada`)
        return
    }

    const currentlyVisible = visible.get()

    if (!currentlyVisible) {
        window.show()
        visible.set(true)
    } else {
        visible.set(false)

        timeout(200, () => {
            window.hide()
        })
    }
}
export function hideAllWindows() {
    const windows = App.get_windows().filter((window) => {
        return window.name === sidebarWindowName
    })
    windows.forEach((window) => {
        window.hide()
    })
}