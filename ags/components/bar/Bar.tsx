import { App } from "astal/gtk3"
import { Variable, GLib, bind } from "astal"
import { Astal, Gtk, Gdk } from "astal/gtk3"
import { interval,timeout } from "astal/time"
import Hyprland from "gi://AstalHyprland"

// ----------Utils-----------
import { safeExecAsync } from "../../utils/manage"


// ----------------import function-------
import CalendarConfig from "../calendar/Calendar"

// -----------------import variables------

import { artist } from "../../utils/initvars"
import { title } from "../../utils/initvars"
import { iconApp } from "../../utils/initvars"
import { percentageFloat } from "../../utils/initvars"
import { percentageBattery } from "../../utils/initvars"
import { iconBattery } from "../../utils/initvars"
import { date } from "../../utils/initvars"
import { point } from "../../utils/initvars"
import { calendar } from "../../utils/initvars"
import { iconWifi } from "../../utils/initvars"
import { iconBluetooth } from "../../utils/initvars"
import { stateBattery } from "../../utils/initvars"


// ------------ Gestiones -----------------

import { buttonOnSideBar } from "../../utils/initvars"
import { buttonOnMediaPanel } from "../../utils/initvars"
import { buttonOnCalendarPanel } from "../../utils/initvars"


function Clock() {
    return <button  className="clock"  cursor="pointer" onClicked={
        () => {
            if (buttonOnCalendarPanel.get() === false) {
                buttonOnCalendarPanel.set(true)
                buttonOnSideBar.set(false)
                buttonOnMediaPanel.set(false)
            } else {
                buttonOnCalendarPanel.set(false)
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
                icon="color-picker-2"
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
            } else {
                buttonOnMediaPanel.set(false)
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
                    safeExecAsync(["bash", "-c", "~/.config/ags/scripts/network-info.sh listupdate"])
                } else {
                    buttonOnSideBar.set(false)
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
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

    return <window
        className="bar"
        name="bar"
        application={App}
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