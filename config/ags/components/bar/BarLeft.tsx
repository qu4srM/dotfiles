import { App } from "astal/gtk3"
import { Variable, GLib, bind } from "astal"
import { Astal, Gtk, Gdk } from "astal/gtk3"
import { interval,timeout } from "astal/time"
import Hyprland from "gi://AstalHyprland"
import { LEFT, RIGHT, TOP, BOTTOM, EXCLUSIVE, START, CENTER, END } from "../../utils/initvars"

// ----------Utils-----------
import { safeExecAsync } from "../../utils/exec"
const hypr = Hyprland.get_default()

// ----------------import function-------
//import CalendarConfig from "../calendar/Calendar"
export const barleftWindowName = "barleft"

export const percentageBattery = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/battery-info.sh getpercentage"])
export const iconApp = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/music.sh geticon"])
export const iconBattery = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/battery-info.sh geticon"])

// ---------------------Time-------------------
const currentDate: Date = new Date()

export const hours: string = String(currentDate.getHours()).padStart(2, '0')
export const minutes: string = String(currentDate.getMinutes()).padStart(2, '0')


function AppLauncher() {
    return <button className="app-launcher-btn" halign={CENTER} cursor="pointer" onClicked={
        () => {
            safeExecAsync(["bash", "-c", "bash ~/.config/rofi/launcher/launch.sh"])
        }
    } >
        <icon icon="redhat" />
    </button>
}
function Workspaces() {

    return <box className="workspaces" halign={CENTER} orientation={1}>
        {bind(hypr, "workspaces").as(wss => wss
            .filter(ws => !(ws.id >= -99 && ws.id <= -2)) // filter out special workspaces
            .sort((a, b) => a.id - b.id)
            .map(ws => (
                <button
                    className={bind(hypr, "focusedWorkspace").as(fw =>
                        ws === fw ? "focused" : "")}
                    onClicked={() => ws.focus()}
                    cursor="pointer">
                    <icon icon={bind(hypr, "focusedWorkspace").as(fw => 
                        ws === fw ? "pacm-symbolic" : "circle-symbolic"
                    )} />
                </button>
            ))
        )}
    </box>
}
function Hack () {
    return <button className="hack-btn" halign={CENTER} cursor="pointer" onClicked={
        () => {
            safeExecAsync(["bash", "-c", "~/.config/ags/launch.sh hack"])
        }
    } >
        <icon icon="hackthebox" />
    </button>
}
function Info() {
    return <box className="info" halign={CENTER} orientation={1}>
        <icon icon={bind(iconBattery)} />
        <label label={hours}/>
        <label label={minutes}/>
    </box>
}
function Sidebar () {
    return <button className="sidebar-btn" halign={CENTER} cursor="pointer" onClicked={
        () => {
            safeExecAsync(["bash", "-c", "~/.config/ags/launch.sh sidebar"])
        }
    } >
        <icon icon="notification-symbolic" />
    </button>
}
function Media () {
    return <button className="media-btn" halign={CENTER} cursor="pointer" onClicked={
        () => {
            safeExecAsync(["bash", "-c", "~/.config/ags/launch.sh media"])
        }
    } >
        <icon icon={bind(iconApp)} />
    </button>
}

export default function BarLeft(monitor: Gdk.Monitor) {
    if (!monitor) {
        const display = Gdk.Display.get_default()
        monitor = display?.get_primary_monitor()
    }

    return <window
        className={barleftWindowName}
        name={barleftWindowName}
        application={App}
        gdkmonitor={monitor}
        exclusivity={EXCLUSIVE}
        anchor={TOP | LEFT | BOTTOM}
        marginTop="6"
        marginLeft="6"
        marginBottom="6"
        >
            
        <centerbox orientation={1}>
            <box hexpand halign={CENTER} valign={START} orientation={1}>
                <AppLauncher />
                <Workspaces />
            </box>
            <box>
            </box>
            <box hexpand halign={CENTER} valign={END} orientation={1}>
                <Hack />
                <Info />
                <Sidebar />
                <Media />
            </box>
        </centerbox>
    </window>
}