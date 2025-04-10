import { App } from "astal/gtk3"
import { Variable, GLib, bind } from "astal"
import { Astal, Gtk, Gdk } from "astal/gtk3"
import { subprocess, exec, execAsync } from "astal/process"
import { interval,timeout } from "astal/time"
import { readFile, readFileAsync, writeFile, writeFileAsync, monitorFile, } from "astal/file"
import Hyprland from "gi://AstalHyprland"


// ----------------import function-------
import CalendarConfig from "../components/calendar/Calendar"

// -----------------import variables------

import { artist } from "../hooks/initvars"
import { title } from "../hooks/initvars"
import { iconApp } from "../hooks/initvars"
import { percentageFloat } from "../hooks/initvars"
import { percentageBattery } from "../hooks/initvars"
import { iconBattery } from "../hooks/initvars"
import { date } from "../hooks/initvars"
import { point } from "../hooks/initvars"
import { calendar } from "../hooks/initvars"
import { iconWifi } from "../hooks/initvars"
import { iconBluetooth } from "../hooks/initvars"
import { stateBattery } from "../hooks/initvars"


// ------------ Gestiones -----------------

import { buttonOnSideBar } from "../hooks/initvars"
import { buttonOnMediaPanel } from "../hooks/initvars"
import { buttonOnCalendarPanel } from "../hooks/initvars"

function Clock() {
    return <button  className="clock"  cursor="pointer" onClicked={
        () => {
            if (buttonOnCalendarPanel.get() === false) {
                buttonOnCalendarPanel.set(true)
                buttonOnSideBar.set(false)
                buttonOnMediaPanel.set(false)
                console.log(buttonOnCalendarPanel)
            } else {
                buttonOnCalendarPanel.set(false)
                console.log(buttonOnCalendarPanel)
            }
        }
    } >
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
        <label label=" " />
        <circularprogress value={bind(percentageFloat)} startAt={0.75} endAt={0.75}>
            <icon
                className="battery-box-btn-icon"
                icon={bind(iconBattery)}
            />
        </circularprogress>
    </box>
}

function MenuShortcuts() {
    return <box className="menu-shortcuts">
        <button className="menu-shortcuts-btn" cursor="pointer" onClicked={
            () => {
                execAsync(["bash", "-c", "whoami"])
                    .then((out) => console.log(out))
                    .catch((err) => console.error(err))
            }
        } >
            <icon
                className="menu-shortcuts-btn-icon"
                icon="scanner-symbolic"
            />
        </button>
        <button className="menu-shortcuts-btn" cursor="pointer" onClicked={
            () => {
                execAsync(["bash", "-c", "hyprpicker -f hex | cat | wl-copy"])
                    .then((out) => console.log(out))
                    .catch((err) => console.error(err))
            }
        } >
            <icon
                className="menu-shortcuts-btn-icon"
                icon="color-picker-2"
            />
        </button>
        <button className="menu-shortcuts-btn" cursor="pointer" onClicked={
            () => {
                execAsync(["bash", "-c", "whoami"])
                    .then((out) => console.log(out))
                    .catch((err) => console.error(err))
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
            execAsync(["bash", "-c", "bash ~/.config/rofi/launcher/launch.sh"])
                .then((out) => console.log(out))
                .catch((err) => console.error(err))
            }
        } >
            Apps
        </button>
    </box>
}
function MediaFocus () {
    return <button className="media-btn" cursor="pointer" onClicked={
        () => {
            if (buttonOnMediaPanel.get() === false) {
                buttonOnMediaPanel.set(true)
                buttonOnSideBar.set(false)
                buttonOnCalendarPanel.set(false)
                console.log(buttonOnMediaPanel)
            } else {
                buttonOnMediaPanel.set(false)
                console.log(buttonOnMediaPanel)
            }
        }
    } >
        <MediaBar />
    </button>
}

function Menu() {
    return <box className="menu-box">
        <button className="menu-btn" cursor="pointer" onClicked={
            () => {
                //execAsync(["bash", "-c", "~/.config/ags/launch.sh launchsidebar"])
                if (buttonOnSideBar.get() === false) {
                    buttonOnSideBar.set(true)
                    buttonOnMediaPanel.set(false)
                    buttonOnCalendarPanel.set(false)
                    execAsync(["bash", "-c", "~/.config/ags/scripts/network-info.sh listupdate"])
                    console.log(buttonOnSideBar)
                } else {
                    buttonOnSideBar.set(false)
                    console.log(buttonOnSideBar)
                }
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


function MediaBar() {

    return <box className="media">
        <label label={bind(title)} />
        <label label={bind(point)} />
        <label label={bind(artist)} />
        <icon
            className="media-icon"
            icon={bind(iconApp)}
        />

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
                    onClicked={() => ws.focus()}>
                    {ws.id}
                </button>
            ))
        )}
    </box>
}



// ----------------------------------MediaPanel-----------------------------


// ----------------------------------Charging-------------------------------



function ChargingOn() {
    return <box visible={(stateBattery === true) ? true : false}>
        <overlay>
            <box heightRequest={40} widthRequest={40}>
                <levelbar value={bind(percentageFloat)} widthRequest={100} />
            </box>
            <box css="color: black;" className="overlay" valign={Gtk.Align.CENTER} halign={Gtk.Align.CENTER}>{bind(percentageBattery)}</box>
        </overlay>
    </box>
}



export default function Bar(monitor: Gdk.Monitor) {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

    return <window
        className="bar"
        gdkmonitor={monitor}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={TOP | LEFT | RIGHT}
        iconTheme="Papirus"
        
        >
        <centerbox>
            <box hexpand halign={Gtk.Align.START}>
                <AppLauncher />
                <Workspaces />
            </box>
            <box hexpand halign={Gtk.Align.CENTER}>
                <MenuShortcuts />
                <Clock />
                <BatteryHealth />
            </box>
            <box hexpand halign={Gtk.Align.END} >
                <MediaFocus />
                <Menu />
            </box>
        </centerbox>
    </window>
}

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
}