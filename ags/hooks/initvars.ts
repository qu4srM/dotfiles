import { Variable} from "astal"
import { Astal} from "astal/gtk3"

// Export variables config
export const password = Variable("").poll(1000, ["bash", "-c", "cat ~/.config/ags/password.txt"])
export const logo = Variable("./assets/img/archlinux.png")
export const artist = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/music.sh getartist"])
export const title = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/music.sh gettitle"])
export const iconApp = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/music.sh geticon"])
export const percentageFloat = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/battery-info.sh getsum"])
export const percentageBattery = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/battery-info.sh getpercentage"])
export const iconBattery = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/battery-info.sh geticon"])
export const date = Variable("").poll(1000, ["bash", "-c", 'date "+%H:%M"'])
export const point = Variable(" · ")
export const calendar = Variable("").poll(1000, ["bash", "-c", 'date "+%A, %d/%m"'])
export const iconWifi = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/network-info.sh geticon"])
export const iconBluetooth = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/bluetooth-info.sh geticon"])
export const stateBattery = Variable().poll(1000, ["bash", "-c", "~/.config/ags/scripts/battery-info.sh getstate"])

// Media Panel 
export const lengthMusic = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/music.sh getlength"])
export const position = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/music.sh getposition"])
export const image = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/music.sh getimage"]) // NO DELETE
export const url = Variable("./assets/img/coverArt.jpg")

// Panels

export const buttonOnSideBar = Variable(false)
export const buttonOnMediaPanel = Variable(false)
export const buttonOnCalendarPanel = Variable(false)

// Sidebar
export const visibleSound = Variable(false)
export const visibleNotification = Variable(true)
export const visibleKeybind = Variable(false)
export const nameSideBar = Variable("Notification")
export const visibleWifi = Variable(false)
export const visibleBluetooth = Variable(false)

// Windows
export const { TOP, LEFT, RIGHT, BOTTOM } = Astal.WindowAnchor
export const sidebarName = "sidebar"
export const mediaName = "mediapanel"
export const calendarName = "calendar"