import { Variable, bind } from "astal"
import { execAsync } from "astal/process"
import { showh } from "../../hooks/revealer"

import SoundConf from "../soundconf/SoundConf"
import WifiConf from "../wificonf/WifiConf"
import NotificationConfig from "../notification/Notification"
import KeybindsConfig from "../keybinds/Keybinds"
import CalendarConfig from "../calendar/Calendar"

import { password, logo } from "../../hooks/initvars"

import { nameSideBar } from "../../hooks/initvars"
import { visibleSound, visibleBluetooth, visibleNotification, visibleKeybind, visibleWifi } from "../../hooks/initvars"

import { iconWifi } from "../../hooks/initvars"
import { iconBluetooth } from "../../hooks/initvars"

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
                            visibleWifi.set(false)
                            visibleBluetooth.set(false)
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
                <button className="btn-quick-settings" onClicked={
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
                <button className="btn-quick-settings" onClicked={
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
                <button className="btn-quick-settings" onClicked={
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
                <NotificationConfig config={visibleNotification} />
                <SoundConf config={visibleSound} />
                <KeybindsConfig config={visibleKeybind}/>
                <WifiConf config={visibleWifi} />
            </box>
        </box> 
    </centerbox>
}


export function OnSideBar ({ visible }: { visible: Variable<boolean> }) {
    return <revealer
        setup={self => showh(self, visible)}
        revealChild={visible()}
        //transitionDuration={100}
        >
        <QuickSettings />
    </revealer>
    
}
