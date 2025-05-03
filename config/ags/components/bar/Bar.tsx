import { App } from "astal/gtk3"
import { Variable, GLib, bind } from "astal"
import { Astal, Gtk, Gdk } from "astal/gtk3"
import { readFile, readFileAsync, writeFile, writeFileAsync, monitorFile, } from "astal/file"
import { interval,timeout } from "astal/time"
import Hyprland from "gi://AstalHyprland"


import { LEFT, RIGHT, TOP } from "../../utils/initvars"
import { EXCLUSIVE } from "../../utils/initvars"
import { START, CENTER, END } from "../../utils/initvars"

// ----------Utils-----------
import { safeExecAsync } from "../../utils/manage"


// ----------------import function-------
import CalendarConfig from "../calendar/Calendar"

// -----------------import variables------

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

export const workspaceNumber = Variable("").poll(100, ["bash", "-c", "~/.config/ags/scripts/hypr-status.sh workspacenumber"])



function Clock() {
    return <button  className="clock"  cursor="pointer">
        <box>
            <label className="clock-time" label={bind(date)} />
            <label className="clock-point" label={bind(point)} />
            <label className="clock-calendar" label={bind(calendar)} />
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
function MenuShortcuts() {
    return <box className="menu-shortcuts">
        <button className="menu-shortcuts-btn" cursor="pointer" onClicked={
            () => {
                safeExecAsync(["bash", "-c", "whoami"])
            }
        } >
            <icon
                className="menu-shortcuts-btn-icon"
                icon="scanner-symbolic"
            />
        </button>
        <button className="menu-shortcuts-btn" cursor="pointer" onClicked={
            () => {
                safeExecAsync(["bash", "-c", "hyprpicker -f hex | cat | wl-copy"])
            }
        } >
            <icon
                className="menu-shortcuts-btn-icon"
                icon="picker"
            />
        </button>
        <button className="menu-shortcuts-btn" cursor="pointer" onClicked={
            () => {
                safeExecAsync(["bash", "-c", "whoami"])
            }
        } >
            <icon
                className="menu-shortcuts-btn-icon"
                icon="input-keyboard-symbolic"
            />
        </button>
    </box>
}
function AppLauncher() {
    return <box className="app-launcher-box" homogeneus={false} vertical={true}>
        <label className="app-launcher-label" halign={Gtk.Align.START}  label="org.gnome.Settings" />
        <button className="app-launcher-btn" halign={Gtk.Align.START} cursor="pointer" onClicked={
            () => {
                safeExecAsync(["bash", "-c", "bash ~/.config/rofi/launcher/launch.sh"])
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
        <label label={bind(title)} maxWidthChars={20} truncate={true}/>
        <label label={bind(point)} />
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
                safeExecAsync(["bash", "-c", "~/.config/ags/scripts/network-info.sh listupdate"])
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
                    icon="notification-indicator-normal"
                />
            </box>
        </button>
    </box>
}
function Workspaces() {
    const hypr = Hyprland.get_default()

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

// ----------------------------------Charging-------------------------------

/*

function ChargingOn() {
    return <box visible={(stateBattery === true) ? true : false}>
        <overlay>
            <box heightRequest={40} widthRequest={40}>
                <levelbar value={bind(percentageFloat)} widthRequest={100} />
            </box>
            <box css="color: black;" className="overlay" valign={Gtk.Align.CENTER} halign={Gtk.Align.CENTER}>{bind(percentageBattery)}</box>
        </overlay>
    </box>
}*/



export default function Bar(monitor: Gdk.Monitor) {

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
                <BatteryHealth />
                <MediaFocus/>
            </box>
            <box hexpand halign={CENTER}>
                <Workspaces />
            </box>
            <box hexpand halign={END} >
                <Clock/>
                <MenuShortcuts />
                <Menu />
            </box>
        </centerbox>
    </window>
}
/*
export function CalendarPanel(monitor: Gdk.Monitor) {
    const {TOP} = Astal.WindowAnchor
    const visible = buttonOnCalendarPanel

    return <window
        className="calendarpanel"
        gdkmonitor={monitor}
        exclusivity={Astal.Exclusivity.NORMAL}
        anchor={TOP}
        iconTheme="Papirus"
        keymode={Astal.Keymode.ON_DEMAND}
        onKeyPressEvent={(self, event: Gdk.Event) => {
            if (event.get_keyval()[1] === Gdk.KEY_Escape) {
                self.hide()
            }
        }}
        marginTop="12"
        >
        <CalendarConfig config={buttonOnCalendarPanel} />
    </window>
}
export function Charging(monitor: Gdk.Monitor) {
    const { BOTTOM } = Astal.WindowAnchor

    return <window
        className="charging"
        gdkmonitor={monitor}
        exclusivity={Astal.Exclusivity.NORMAL}
        anchor={BOTTOM}
        iconTheme="Papirus"
        keymode={Astal.Keymode.ON_DEMAND}
        onKeyPressEvent={(self, event: Gdk.Event) => {
            if (event.get_keyval()[1] === Gdk.KEY_Escape) {
                self.hide()
            }
        }}
        marginBottom="12"
        >
        <ChargingOn />
    </window>
}*/