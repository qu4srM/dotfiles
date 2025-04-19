import { App } from "astal/gtk3"
import { Variable, bind } from "astal"
import { interval,timeout } from "astal/time"

import { sidebarWindowName } from "../components/sidebar/Sidebar"
import { visibleSideBar } from "../components/sidebar/Sidebar"


export function ToggleWindow(windowName: string, visible: Variable) {
    const window = App.get_windows().find((window) => window.name === windowName)
    if (window !== undefined && !window.visible) {
        print("si")
        window.show()
        timeout(100, ()=> {
            visible.set(true)
        })

    } else if (window?.visible) {
        print("no")
        visible.set(false)
        timeout(400,()=>{
            window?.hide()
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