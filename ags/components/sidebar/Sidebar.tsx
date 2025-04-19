import { App, Astal, Gdk} from "astal/gtk3"
import { Variable, bind } from "astal"
import { TOP, RIGHT, BOTTOM, LEFT, IGNORE } from "../../utils/initvars"
import { SLIDE_LEFT, SLIDE_RIGHT } from "../../utils/initvars"
import { NORMAL } from "../../utils/initvars"

export const sidebarWindowName = "sidebar"
export const visibleSideBar = Variable(false)

import { safeExecAsync } from "../../utils/manage"

import SoundConf from "../soundconf/SoundConf"
import WifiConf from "../wificonf/WifiConf"
import NotificationConfig from "../notification/Notification"
import KeybindsConfig from "../keybinds/Keybinds"

import { password, logo } from "../bar/BarTop"

// Sidebar
export const visibleSound = Variable(false)
export const visibleNotification = Variable(true)
export const visibleKeybind = Variable(false)
export const nameSideBar = Variable("Notification")
export const visibleWifi = Variable(false)
export const visibleBluetooth = Variable(false)


import { show } from "../../utils/revealer"
import { iconWifi } from "../bar/BarTop"
import { iconBluetooth } from "../bar/BarTop"

function QuickSettings () {
    return <centerbox expand vertical className="revealer-box">
        <box vertical>
            <box className="btn-help">
                <label label="Uptime" />
                <button marginLeft="100" className="btn-quick-settings" cursor="pointer" onClick={
                    () => {
                        safeExecAsync(["bash", "-c", "wlogout"])
                    }
                }>
                    <icon
                    className="menu-shortcuts-btn-icon"
                    icon="org.gnome.Settings-symbolic"
                    />
                </button>
                <button className="btn-quick-settings" cursor="pointer" onClick={
                    () => {
                        safeExecAsync(["bash", "-c", "wlogout"])
                    }
                }>
                    <icon
                    className="menu-shortcuts-btn-icon"
                    icon="org.gnome.Settings-screen-lock-symbolic"
                    />
                </button>
                <button className="btn-quick-settings" cursor="pointer" onClick={
                    () => {
                        safeExecAsync(["bash", "-c", "wlogout"])
                    }
                }>
                    <icon
                    className="menu-shortcuts-btn-icon"
                    icon={bind(logo)}
                    />
                </button>
            </box>
            <box className="btn-quick-settings-box">
                <button className="btn-quick-settings" cursor="pointer">
                    <icon
                    className="menu-shortcuts-btn-icon"
                    icon={bind(iconWifi)}
                    />
                </button>
                <button className="btn-quick-settings" cursor="pointer">
                    <icon
                    className="menu-shortcuts-btn-icon"
                    icon={bind(iconWifi)}
                    />
                </button>
                <button className="btn-quick-settings" cursor="pointer">
                    <icon
                    className="menu-shortcuts-btn-icon"
                    icon={bind(iconWifi)}
                    />
                </button>
                <button className="btn-quick-settings" cursor="pointer" onClick={
                    ()=> {
                        safeExecAsync(["bash", "-c", "~/.config/rofi/wall/launch.sh"])
                        safeExecAsync(["bash", "-c", "~/.config/ags/launch.sh sidebar"])
                    }
                }>
                    <icon
                    className="menu-shortcuts-btn-icon"
                    icon="org.gnome.Settings-appearance-symbolic"
                    />
                </button>
            </box>
        </box>
        <box vertical vexpand>
            <box className="btn-settings-box" hexpand>
                <button className="btn-quick-settings" cursor="pointer" onClicked={
                    () => {
                        //execAsync(["bash", "-c", "~/.config/ags/launch.sh launchsidebar"])
                        if (visibleNotification.get() === false) {
                            visibleNotification.set(true)
                            visibleWifi.set(false)
                            visibleBluetooth.set(false)
                            visibleSound.set(false)
                            visibleKeybind.set(false)
                            nameSideBar.set("Notification")
                        } 
                    }
                } >
                    <icon
                    className="menu-shortcuts-btn-icon"
                    icon="chat-bubbles"
                    />
                </button>
                <button className="btn-quick-settings" cursor="pointer" onClicked={
                    () => {
                        //execAsync(["bash", "-c", "~/.config/ags/launch.sh launchsidebar"])
                        if (visibleSound.get() === false) {
                            visibleSound.set(true)
                            visibleNotification.set(false)
                            visibleWifi.set(false)
                            visibleBluetooth.set(false)
                            visibleKeybind.set(false)
                            nameSideBar.set("Volume")
                        } else {
                            visibleSound.set(true)
                        }
                    }
                } >
                    <icon
                    className="menu-shortcuts-btn-icon"
                    icon="org.gnome.Settings-sound-symbolic"
                    />
                </button>
                <button className="btn-quick-settings" cursor="pointer" onClicked={
                    () => {
                        //execAsync(["bash", "-c", "~/.config/ags/launch.sh launchsidebar"])
                        if (visibleKeybind.get() === false) {
                            visibleKeybind.set(true)
                            visibleNotification.set(false)
                            visibleSound.set(false)
                            visibleWifi.set(false)
                            visibleBluetooth.set(false)
                            nameSideBar.set("Keybinds")
                        } else {
                            visibleKeybind.set(true)
                        }
                    }
                } >
                    <icon
                    className="menu-shortcuts-btn-icon"
                    icon="org.gnome.Settings-keyboard-symbolic"
                    />
                </button>
                <button className="btn-quick-settings" cursor="pointer" onClicked={
                    () => {
                        //execAsync(["bash", "-c", "~/.config/ags/launch.sh launchsidebar"])
                        if (visibleWifi.get() === false) {
                            visibleWifi.set(true)
                            visibleBluetooth.set(false)
                            visibleKeybind.set(false)
                            visibleNotification.set(false)
                            visibleSound.set(false)
                            nameSideBar.set("Wifi")
                        } else {
                            visibleWifi.set(true)
                        }
                    }
                } >
                    <icon
                    className="menu-shortcuts-btn-icon"
                    icon={bind(iconWifi)}
                    />
                </button>
                <button className="btn-quick-settings" cursor="pointer" onClicked={
                    () => {
                        //execAsync(["bash", "-c", "~/.config/ags/launch.sh launchsidebar"])
                        if (visibleBluetooth.get() === false) {
                            visibleBluetooth.set(true)
                            visibleKeybind.set(false)
                            visibleWifi.set(false)
                            visibleNotification.set(false)
                            visibleSound.set(false)
                            nameSideBar.set("Bluetooth")
                        } else {
                            visibleBluetooth.set(true)
                        }
                    }
                } >
                    <icon
                    className="menu-shortcuts-btn-icon"
                    icon={bind(iconBluetooth)}
                    />
                </button>
            </box>
            <label label={bind(nameSideBar)} expand/>
            <box vertical hexpand>
                {/*
                <NotificationConfig config={visibleNotification} />
                <SoundConf config={visibleSound} />
                <KeybindsConfig config={visibleKeybind}/>
                
                <WifiConf config={visibleWifi} />*/
                }
            </box>
        </box> 
    </centerbox>
}

function OnRevealer ({ visible }: { visible: Variable<boolean> }) {   
    return <revealer
        setup={self => show(self, visible)}
        revealChild={visibleSideBar()}
        transitionType={SLIDE_RIGHT}
        transitionDuration={100}>
        <QuickSettings />
    </revealer>
    
}

export default function SideBar(monitor: Gdk.Monitor) {
    if (!monitor) {
        const display = Gdk.Display.get_default()
        monitor = display?.get_primary_monitor()
    }
    return <window
        className={sidebarWindowName}
        name={sidebarWindowName}
        application={App}
        gdkmonitor={monitor}
        exclusivity={IGNORE}
        layer={Astal.Layer.OVERLAY}
        anchor={TOP | RIGHT | BOTTOM}
        marginTop="38"
        marginRight="6"
        marginBottom="6"
        >
        <eventbox onHoverLost={
            ()=> {
                safeExecAsync(["bash", "-c", "~/.config/ags/launch.sh sidebar"])
            }
        }>
            <centerbox>
                <OnRevealer visible={visibleSideBar} />
            </centerbox>
        </eventbox>
        
    </window>
}
