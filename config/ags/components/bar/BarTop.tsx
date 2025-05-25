import { App } from "astal/gtk3"
import { Variable, GLib, bind } from "astal"
import { Astal, Gtk, Gdk } from "astal/gtk3"
import { interval,timeout } from "astal/time"
import Hyprland from "gi://AstalHyprland"
import { LEFT, RIGHT, TOP, EXCLUSIVE, START, CENTER, END } from "../../utils/initvars"
import { countMinutes, countSeconds, countHours } from "../../utils/initvars"

// ----------Utils-----------
import { safeExecAsync } from "../../utils/exec"

// ----------------import function-------
//import CalendarConfig from "../calendar/Calendar"


// -------------Hyprland Vars---------------
const hypr = Hyprland.get_default()
export const workspaceNumber = bind(hypr, "focusedWorkspace").as(ws => ws.id.toString())
export const nameWindowHypr = bind(hypr, "focusedClient").as(client => client?.class ?? "Desktop")


// -----------------Vars---------------------
export const time = Variable("").poll(countMinutes(1), ["bash", "-c", `date +"%H:%M"`])
export const dateAll = Variable("").poll(countHours(10), ["bash", "-c", `date +"%A, %d/%m/%4Y"`])

export const logo = "./assets/img/archlinux.png"
export const artist = Variable("").poll(countSeconds(5), ["bash", "-c", "~/.config/ags/scripts/music.sh getartist"])
export const title = Variable("").poll(countSeconds(5), ["bash", "-c", "~/.config/ags/scripts/music.sh gettitle"])
export const iconApp = Variable("").poll(countSeconds(5), ["bash", "-c", "~/.config/ags/scripts/music.sh geticon"])
export const percentageFloat = Variable("").poll(countMinutes(1), ["bash", "-c", "~/.config/ags/scripts/battery-info.sh getsum"])
export const percentageBattery = Variable("").poll(countMinutes(1), ["bash", "-c", "~/.config/ags/scripts/battery-info.sh getpercentage"])
export const iconBattery = Variable("").poll(countMinutes(1), ["bash", "-c", "~/.config/ags/scripts/battery-info.sh geticon"])
export const iconWifi = Variable("").poll(countSeconds(5), ["bash", "-c", "~/.config/ags/scripts/network-info.sh geticon"])
export const iconBluetooth = Variable("").poll(countSeconds(5), ["bash", "-c", "~/.config/ags/scripts/bluetooth-info.sh geticon"])
export const stateBattery = Variable().poll(countMinutes(1), ["bash", "-c", "~/.config/ags/scripts/battery-info.sh getstate"])
export const stateHTB = Variable("").poll(countSeconds(1), ["bash", "-c", "~/.config/ags/scripts/htb-status.sh status"])



function Clock() {
    return <button  className="clock"  cursor="pointer">
        <box>
            <label className="clock-time" label={bind(time)} />
            <label className="clock-point" label=" · " />
            <label className="clock-calendar" label={bind(dateAll)} />
        </box>
    </button>
}
function BatteryHealth() {
    return <box className="battery-box">
        <label label={bind(percentageBattery)} />
        <label label="% " />
        <icon
            className="battery-box-btn-icon"
            icon={bind(iconBattery)}
        />
    </box>
}
function createButton(iconName: string, onClickCommand: string) {
    return (
        <button className="menu-shortcuts-btn" cursor="pointer" onClicked={() => safeExecAsync(["bash", "-c", onClickCommand])}>
            <icon className="menu-shortcuts-btn-icon" icon={iconName} />
        </button>
    );
}
function MenuShortcuts() {
    return (
        <box className="menu-shortcuts">
            {createButton("cut-screenshot-symbolic", "~/.config/ags/launch.sh screenshot")}
            {createButton("picker-symbolic", "hyprpicker -f hex | cat | wl-copy")}
            {createButton("input-keyboard-symbolic", "whoami")}
        </box>
    );
}
function AppLauncher() {
    return <box className="app-launcher-box" vertical={true}>
        <label className="app-launcher-label" halign={Gtk.Align.START}  label={bind(nameWindowHypr)} />
        <button className="app-launcher-btn" halign={Gtk.Align.START} cursor="pointer" onClicked={
            () => {
                safeExecAsync(["bash", "-c", "~/.config/rofi/launcher/launch.sh"])
            }
        } >
            <box>
                <label label="Workspace " />
                <label label={bind(workspaceNumber)} />
            </box>
        </button>
    </box>
}
function MediaBar() {
    return <box className="media">
        <label label={bind(title)} maxWidthChars={16} truncate={true}/>
        <label label=" · " />
        <label label={bind(artist)} maxWidthChars={18} truncate={true}/>
        <icon
            className="media-icon"
            icon={bind(iconApp)}
        />
    </box>
}
function MediaFocus () {
    return <button className="media-btn" cursor="pointer" onClicked={
        () => {
            safeExecAsync(["bash", "-c", "~/.config/ags/launch.sh media"])
        }
    } >
        <MediaBar />
    </button>
}
function Menu() {
    return <box className="menu-box">
        <button className="menu-btn" cursor="pointer" onClicked={
            () => {
                safeExecAsync(["bash", "-c", "~/.config/ags/launch.sh sidebar"])
            }
        } >
            <box>

                <icon
                    className="menu-btn-icon"
                    icon={bind(iconWifi)}
                />
                <icon
                    className="menu-btn-icon medium"
                    icon={bind(iconBluetooth)}
                />
                <icon
                    className="menu-btn-icon"
                    icon="notification-symbolic"
                />
            </box>
        </button>
    </box>
}
function Workspaces() {

    return <box className="workspaces">
        {bind(hypr, "workspaces").as(wss => wss
            .filter(ws => !(ws.id >= -99 && ws.id <= -2)) // filter out special workspaces
            .sort((a, b) => a.id - b.id)
            .map(ws => (
                <button
                    className={bind(hypr, "focusedWorkspace").as(fw =>
                        ws === fw ? "focused" : "")}
                    onClicked={() => ws.focus()}
                    cursor="pointer">
                    {ws.id}
                </button>
            ))
        )}
    </box>
}
function Hack () {
    return <box>
        <button className="hack-btn" cursor="pointer" onClicked={
            () => {
                safeExecAsync(["bash", "-c", "~/.config/ags/launch.sh hack"])
            }
        } >
            <label label={bind(stateHTB)} />
        </button>
    </box>
}
function ToggleBar () {
    return <button className="togglebar-btn" halign={CENTER} cursor="pointer" onClicked={
        () => {
            safeExecAsync(["bash", "-c", "~/.config/ags/launch.sh barleft"])
        }
    } >
        <icon icon="bar-left-symbolic" />
    </button>
}
export default function BarTop(monitor: Gdk.Monitor) {
    if (!monitor) {
        const display = Gdk.Display.get_default()
        monitor = display?.get_primary_monitor()
    }

    return <window
        className="bar"
        name="bar"
        application={App}
        gdkmonitor={monitor}
        exclusivity={EXCLUSIVE}
        anchor={TOP | LEFT | RIGHT}
        >
            
        <centerbox>
            <box hexpand halign={START}>
                <AppLauncher />
                <MediaFocus/>
                <Hack />
            </box>
            <box>
                <Workspaces />
            </box>
            <box hexpand halign={END}>
                <Clock/>
                <MenuShortcuts />
                <BatteryHealth />
                <Menu />
                <ToggleBar />
            </box>
        </centerbox>
    </window>
}