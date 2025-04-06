import { App } from "astal/gtk3"
import { Variable, GLib, bind } from "astal"
import { Astal, Gtk, Gdk } from "astal/gtk3"
import { subprocess, exec, execAsync } from "astal/process"
import { interval,timeout } from "astal/time"
import { readFile, readFileAsync, writeFile, writeFileAsync, monitorFile, } from "astal/file"
import Hyprland from "gi://AstalHyprland"


// ----------------import function-------
import SoundConf from "../components/soundconf/SoundConf"
import CalendarConfig from "../components/calendar/Calendar"
import NotificationConfig from "../components/notification/Notification"
import KeybindsConfig from "../components/keybinds/Keybinds"



const password = Variable("").poll(1000, ["bash", "-c", "cat ~/.config/ags/password.txt"])

const logo = Variable("./assets/img/archlinux.png")

const artist = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/music.sh getartist"])
const title = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/music.sh gettitle"])
const iconApp = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/music.sh geticon"])

const percentageFloat = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/battery-info.sh getsum"])
const percentageBattery = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/battery-info.sh getpercentage"])
const iconBattery = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/battery-info.sh geticon"])
const date = Variable("").poll(1000, ["bash", "-c", 'date "+%H:%M"'])
const point = Variable(" · ")
const calendar = Variable("").poll(1000, ["bash", "-c", 'date "+%A, %d/%m"'])
const iconWifi = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/network-info.sh geticon"])
const iconBluetooth = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/bluetooth-info.sh geticon"])

// ------------ Gestiones -----------------
const buttonOnSideBar = Variable(false)



const stateBattery = Variable().poll(1000, ["bash", "-c", "~/.config/ags/scripts/battery-info.sh getstate"])

// -------------MediaPanel--------------
const lengthMusic = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/music.sh getlength"])
const position = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/music.sh getposition"])
const image = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/music.sh getimage"]) // NO DELETE
console.log(image)
const url = Variable("./assets/img/coverArt.jpg")
const buttonOnMediaPanel = Variable(false)

// -------------CalendarPanel-----------
const buttonOnCalendarPanel = Variable(false)







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
                execAsync(["bash", "-c", "whoami"])
                    .then((out) => console.log(out))
                    .catch((err) => console.error(err))
            }
        } >
            <icon
                className="menu-shortcuts-btn-icon"
                icon={bind(iconWifi)}
            />
        </button>
        <button className="menu-btn" cursor="pointer" onClicked={
            () => {
                execAsync(["bash", "-c", "hyprpicker -f hex | cat | wl-copy"])
                    .then((out) => console.log(out))
                    .catch((err) => console.error(err))
            }
        } >
            <icon
                className="menu-shortcuts-btn-icon"
                icon={bind(iconBluetooth)}
            />
        </button>
        <button className="menu-btn" cursor="pointer" onClicked={
            () => {
                //execAsync(["bash", "-c", "~/.config/ags/launch.sh launchsidebar"])
                if (buttonOnSideBar.get() === false) {
                    buttonOnSideBar.set(true)
                    buttonOnMediaPanel.set(false)
                    buttonOnCalendarPanel.set(false)
                    console.log(buttonOnSideBar)
                } else {
                    buttonOnSideBar.set(false)
                    console.log(buttonOnSideBar)
                }
            }
        } >
            <icon
                className="menu-shortcuts-btn-icon"
                icon="notification-indicator-normal"
            />
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


// -------------------------------SIDEBAR----------------------------------
const visibleSound = Variable(false)
const visibleNotification = Variable(true)
const visibleKeybind = Variable(false)
const nameSideBar = Variable("Notification")


function QuickSettings () {
    return <centerbox expand vertical className="revealer-box">
        <box vertical>
            <box className="btn-help">
                <label label="Uptime" />
                <button css="margin-left: 100px;" className="btn-quick-settings">
                    <icon
                    className="menu-shortcuts-btn-icon"
                    icon="org.gnome.Settings-symbolic"
                    />
                </button>
                <button className="btn-quick-settings" onClick={
                    () => {
                        execAsync(["bash", "-c", "wlogout"])
                    }
                }>
                    <icon
                    className="menu-shortcuts-btn-icon"
                    icon="org.gnome.Settings-screen-lock-symbolic"
                    />
                </button>
                <button className="btn-quick-settings" onClick={
                    () => {
                        execAsync(["bash", "-c", `echo "${password.get()}" | sudo -S pacman -Syu --noconfirm`])
                    }
                }>
                    <icon
                    className="menu-shortcuts-btn-icon"
                    icon={bind(logo)}
                    />
                </button>
            </box>
            <box className="btn-quick-settings-box">
                <button className="btn-quick-settings">
                    <icon
                    className="menu-shortcuts-btn-icon"
                    icon={bind(iconWifi)}
                    />
                </button>
                <button className="btn-quick-settings">
                    <icon
                    className="menu-shortcuts-btn-icon"
                    icon={bind(iconWifi)}
                    />
                </button>
                <button className="btn-quick-settings">
                    <icon
                    className="menu-shortcuts-btn-icon"
                    icon={bind(iconWifi)}
                    />
                </button>
                <button className="btn-quick-settings">
                    <icon
                    className="menu-shortcuts-btn-icon"
                    icon={bind(iconWifi)}
                    />
                </button>
            </box>
        </box>
        <box vertical vexpand>
            <box className="btn-settings-box" hexpand>
                <button className="btn-quick-settings" onClicked={
                    () => {
                        //execAsync(["bash", "-c", "~/.config/ags/launch.sh launchsidebar"])
                        if (visibleNotification.get() === false) {
                            visibleNotification.set(true)
                            visibleSound.set(false)
                            visibleKeybind.set(false)
                            console.log(visibleNotification)
                            nameSideBar.set("Notification")
                        } 
                    }
                } >
                    <icon
                    className="menu-shortcuts-btn-icon"
                    icon="org.gnome.Settings-notifications-symbolic"
                    />
                </button>
                <button className="btn-quick-settings" onClicked={
                    () => {
                        //execAsync(["bash", "-c", "~/.config/ags/launch.sh launchsidebar"])
                        if (visibleSound.get() === false) {
                            visibleSound.set(true)
                            visibleNotification.set(false)
                            visibleKeybind.set(false)
                            nameSideBar.set("Volume")
                            console.log(visibleSound)
                        } else {
                            visibleSound.set(true)
                            console.log(visibleSound)
                        }
                    }
                } >
                    <icon
                    className="menu-shortcuts-btn-icon"
                    icon="org.gnome.Settings-sound-symbolic"
                    />
                </button>
                <button className="btn-quick-settings" onClicked={
                    () => {
                        //execAsync(["bash", "-c", "~/.config/ags/launch.sh launchsidebar"])
                        if (visibleKeybind.get() === false) {
                            visibleKeybind.set(true)
                            visibleNotification.set(false)
                            visibleSound.set(false)
                            nameSideBar.set("Keybinds")
                            console.log(visibleKeybind)
                        } else {
                            visibleKeybind.set(true)
                            console.log(visibleKeybind)
                        }
                    }
                } >
                    <icon
                    className="menu-shortcuts-btn-icon"
                    icon="org.gnome.Settings-keyboard-symbolic"
                    />
                </button>
            </box>
            <label label={bind(nameSideBar)} hexpand />
            <box vertical hexpand>
                <NotificationConfig config={visibleNotification} />
                <SoundConf config={visibleSound} />
                <KeybindsConfig config={visibleKeybind}/>
            </box>
        </box> 
    </centerbox>
}


function OnSideBar ({ visible }: { visible: Variable<boolean> }) {
    const {SLIDE_LEFT, SLIDE_RIGHT} = Gtk.RevealerTransitionType
    function show(self) {
        if (visible === true) {
            self.revealChild = visible.get()
            self.transitionType = SLIDE_RIGHT
        } else {
            self.revealChild = visible.get()
            self.transitionType = SLIDE_LEFT
        }
    }
    
    return <revealer
        setup={self => show(self)}
        revealChild={visible()}
        //transitionDuration={100}
        >
        <QuickSettings />
    </revealer>
    
}


// ----------------------------------MediaPanel-----------------------------

function lengthStr(length: number) {
    const min = Math.floor(length / 60)
    //const min = length < 1000000000 ? Math.floor(length / 6e+7) : length > 1000000000 && length < 10000000000 ? Math.floor(length / 6e+7) : "nothing"
    const sec = Math.floor(length % 60)
    const sec0 = sec < 10 ? "0" : ""
    return `${min}:${sec0}${sec}`
}
function lengthStrNormal(length: number) {
    const min = Math.floor(length / 60)
    const sec = Math.floor(length % 60)
    const sec0 = sec < 10 ? "0" : ""
    return `${min}:${sec0}${sec}`
}

function Media() {
    
    return <box className="media-box">
        <label label={bind(title)} />
        <label label={bind(point)} />
        <label label={bind(artist)} />
        <icon
            className="media-icon"
            icon={bind(iconApp)}
        />
    </box>
}
function CoverArt() {
    return <centerbox>
        <box className="cover-art" css={`background-image: url("${url.get()}")`} />
    </centerbox>
}
function Time() {
    return <centerbox>
        <label label={bind(position).as(lengthStrNormal)} />
        <slider 
            visible="true"
            //onDragged={({ value }) => bind(position) = value}
            value={bind(position).as(p => bind(lengthMusic) > 0
                ? p / bind(lengthMusic) : 0)}
        />
        {/*1
        <slider
                visible={bind(position).as(l => l > 0)}
                onDragged={({ value }) => bind(position) = value * bind(position)}
                value={bind(lengthMusic).as(p => bind(position) > 0
                    ? p / bind(position) : 0)}
        />
                */}
        <label label={bind(lengthMusic).as(l => l > 0 ? lengthStr(l) : "0:00")} />
    </centerbox>
}

function Control() {
    return <centerbox className="control">
        <button className="control-play" cursor="pointer" onClicked={
            () => {
                execAsync(["bash", "-c", "bash ~/.config/ags/scripts/music.sh previous"])
                    .then((out) => console.log(out))
                    .catch((err) => console.error(err))
            }
        } >
            <icon
                className="control-play-icon"
                icon="media-skip-backward-symbolic"
            />
        </button>
        <button className="control-play" cursor="pointer" onClicked={
            () => {
                execAsync(["bash", "-c", "bash ~/.config/ags/scripts/music.sh playorpause"])
                    .then((out) => console.log(out))
                    .catch((err) => console.error(err))
            }
        } >
            <icon
                className="control-play-icon"
                icon="media-playback-start-symbolic"
            />
        </button>
        <button className="control-play" cursor="pointer" onClicked={
            () => {
                execAsync(["bash", "-c", "bash ~/.config/ags/scripts/music.sh next"])
                    .then((out) => console.log(out))
                    .catch((err) => console.error(err))
            }
        } >
            <icon
                className="control-play-icon"
                icon="media-skip-forward-symbolic"
            />
        </button>

    </centerbox>
}

function MediaBox () {
    return <centerbox className="revealer-box">
        <box className="media-menu" vertical>
            <Media />
            <CoverArt />
            <Time />
            <Control />
        </box>
    </centerbox>
}


function OnMediaPanel ({ visible }: { visible: Variable<boolean> }) {
    function show(self) {
        if (visible === true) {
            self.revealChild = visible.get()
        } else {
            self.revealChild = visible.get()
        }
    }
    
    return <revealer
        setup={self => show(self)}
        revealChild={visible()}
        transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
        //transitionDuration={400}
        >
        <MediaBox />
    </revealer>
    
}



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
export function SideBar(monitor: Gdk.Monitor) {
    const { TOP, RIGHT, BOTTOM } = Astal.WindowAnchor
    const visible = buttonOnSideBar

    return <window
        className="sidebar"
        gdkmonitor={monitor}
        exclusivity={Astal.Exclusivity.NORMAL}
        anchor={TOP | RIGHT | BOTTOM}
        iconTheme="Papirus"
        keymode={Astal.Keymode.ON_DEMAND}
        onKeyPressEvent={(self, event: Gdk.Event) => {
            if (event.get_keyval()[1] === Gdk.KEY_Escape) {
                self.hide()
            }
        }}
        marginTop="12"
        marginRight="12"
        marginBottom="12"
        >
        <OnSideBar visible={visible}/>
    </window>
}
export function MediaPanel(monitor: Gdk.Monitor) {
    const { TOP, RIGHT } = Astal.WindowAnchor
    const visible = buttonOnMediaPanel

    return <window
        className="mediapanel"
        gdkmonitor={monitor}
        exclusivity={Astal.Exclusivity.NORMAL}
        anchor={TOP | RIGHT}
        iconTheme="Papirus"
        keymode={Astal.Keymode.ON_DEMAND}
        onKeyPressEvent={(self, event: Gdk.Event) => {
            if (event.get_keyval()[1] === Gdk.KEY_Escape) {
                self.hide()
            }
        }}
        marginTop="12"
        marginRight="12"
        >
        <OnMediaPanel visible={visible}/>
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