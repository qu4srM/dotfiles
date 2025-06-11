import { App } from "astal/gtk3"
import { Variable, GLib, bind } from "astal"
import { Astal, Gtk, Gdk } from "astal/gtk3"
import { interval,timeout } from "astal/time"
import Hyprland from "gi://AstalHyprland"
import { LEFT, RIGHT, TOP, BOTTOM, EXCLUSIVE, START, CENTER, END } from "../../utils/initvars"
import { countMinutes, countSeconds } from "../../utils/initvars"

// ----------Utils-----------
import { safeExecAsync } from "../../utils/exec"
import { activeBar } from "../../utils/initvars"

const hypr = Hyprland.get_default()

// ----------------import function-------
//import CalendarConfig from "../calendar/Calendar"
export const barleftWindowName = "barleft"

export const percentageBattery = Variable("").poll(countMinutes(1), ["bash", "-c", "~/.config/ags/scripts/battery-info.sh getpercentage"])
export const iconApp = Variable("").poll(countSeconds(10), ["bash", "-c", "~/.config/ags/scripts/music.sh geticon"])
export const iconBattery = Variable("").poll(countMinutes(1), ["bash", "-c", "~/.config/ags/scripts/battery-info.sh geticon"])

export const hours = Variable("").poll(countMinutes(1), ["bash", "-c", `date +"%H"`])
export const minutes = Variable("").poll(countMinutes(1), ["bash", "-c", `date +"%M"`])

const colors = ['#FF5555', '#F1FA8C', '#50FA7B', '#8BE9FD', '#BD93F9'];
const currentColor = Variable(colors[0]);

let i = 0;
setInterval(() => {
  i = (i + 1) % colors.length;
  currentColor.set(colors[i]);
}, 1000);


function AppLauncher() {
    return <button className="app-launcher-btn" halign={CENTER} cursor="pointer" onClicked={
        () => {
            safeExecAsync(["bash", "-c", "~/.config/rofi/launcher/launch.sh"])
        }
    } >
        <icon icon="redhat" tooltipText="Lanzador de aplicaciones" />
    </button>
}
function Workspaces() {
    return <box className="workspaces" halign={CENTER} orientation={1}>
  {bind(hypr, "workspaces").as(wss =>
    wss
      .filter(ws => !(ws.id >= -99 && ws.id <= -2)) // ignorar especiales
      .sort((a, b) => a.id - b.id)
      .map(ws => (
        <button
            className={bind(hypr, "focusedWorkspace").as(fw => {
                if (ws === fw) return "focused";
                else if ((ws.clients?.length ?? 0) > 0) return "active";
                else return "";
            })}
            onClicked={() => ws.focus()}
            cursor="pointer"
            >
            <icon
                icon={bind(hypr, "focusedWorkspace").as(fw =>
                ws === fw
                    ? "pacm-symbolic"
                    : (ws.clients?.length ?? 0) > 0
                    ? "ghost-symbolic"
                    : "circle-symbolic"
                )}
            />
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
        <icon icon="hackthebox-symbolic" />
    </button>
}
function Info() {
    return <box className="info" halign={CENTER} orientation={1}>
        <icon icon={bind(iconBattery)} tooltipText={bind(percentageBattery).as(b => `La bateria es: ${b}%`)} />
        <label label={bind(hours)}/>
        <label label={bind(minutes)}/>
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
function ToggleBar () {
    return <button className="togglebar-btn" halign={CENTER} cursor="pointer" onClicked={
        () => {
            safeExecAsync(["bash", "-c", "~/.config/ags/launch.sh bartop"])
        }
    } >
        <icon icon="bar-top-symbolic" />
    </button>
}
function Picker () {
    return <button className="picker-btn" halign={CENTER} cursor="pointer" onClicked={
        () => {
            safeExecAsync(["bash", "-c", "hyprpicker -f hex | cat | wl-copy"])
        }
    } >
        <icon icon="picker-symbolic" />
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
        marginTop="14"
        marginLeft="14"
        marginBottom="14"
        >
            
        <centerbox orientation={1}>
            <box hexpand halign={CENTER} valign={START} orientation={1}>
                <AppLauncher />
                <Workspaces />
            </box>
            <box>
            </box>
            <box hexpand halign={CENTER} valign={END} orientation={1}>
                <Picker />
                <Hack />
                <Info />
                <Sidebar />
                <Media />
                <ToggleBar />
            </box>
        </centerbox>
    </window>
}