import { App, Astal, Gdk } from "astal/gtk3"
import { Variable, bind } from "astal"
import { interval,timeout } from "astal/time"
import { exec } from "astal/process"
import { TOP, RIGHT, BOTTOM, IGNORE } from "../../utils/initvars"
import { SLIDE_RIGHT } from "../../utils/initvars"
import { safeExecAsync } from "../../utils/exec"
import { START } from "../../utils/initvars"

import SoundConf from "../soundconf/SoundConf"
import WifiConf from "../wificonf/WifiConf"
import NotificationConfig from "../notification/Notification"
import KeybindsConfig from "../keybinds/Keybinds"
//import BluetoothConf from "../bluetoothconf/BluetoothConf"

import { password, logo, iconWifi, iconBluetooth } from "../bar/BarTop"
import { show } from "../../utils/revealer"

// ------------------- Estado -------------------

export const sidebarWindowName = "sidebar"
export const visibleSideBar = Variable(false)

export const activeSection = Variable<"notification" | "sound" | "keybind" | "wifi" | "bluetooth" | null>("notification")
export const nameSideBar = Variable("Notification")

export const uptimeMinutes = Variable("").poll(60000, ["bash", "-c", "awk '{print $1}' /proc/uptime | awk '{print int($1/60)}'"])

const theme = exec(["bash", "-c", "cat ~/.config/ags/scss/theme_mode"])
const initState = Variable(false)
if (theme === "light") {
    initState.set(false)
} else if (theme === "dark") {
    initState.set(true)
}

const visibleSound = Variable(false)
const visibleNotification = Variable(true)
const visibleWifi = Variable(false)
// ------------------- Funciones -------------------

function toggleVariable(variable: Variable<boolean>) {
    variable.set(!variable.get());
}

function QuickButton({ icon, cmd}: { icon: string, cmd : string}) {
    const classButton = Variable("normal")
    const toggleClass = () => {
        const current = classButton.get()
        const next = current === "normal"
            ? "active"
            : "normal"
    
        classButton.set(next)
    }
    return (
        <button className={bind(classButton)}
            cursor="pointer" onClicked={() => {
                safeExecAsync(["bash", "-c", cmd])
                toggleClass()
            }}>
            <icon icon={icon}  />
        </button>
    )
}
function ButtonSet({ icon, onClick }: { icon: string, onClick?: () => void }) {
    return (
        <button className="btn-quick-settings" cursor="pointer" onClick={onClick}>
            <icon className="menu-shortcuts-btn-icon" icon={icon} />
        </button>
    )
}
function SettingsButton({visible, icon, label, cmd }: {visible: any, icon: string, label: string, cmd : string }) {
    const iconArrow = Variable("arrow-right-symbolic")
    const toggleIcon = () => {
        const current = iconArrow.get()
        const next = current === "arrow-right-symbolic"
            ? "arrow-down-symbolic"
            : "arrow-right-symbolic"

        iconArrow.set(next)
    }
    return (
        <button
            className="btn-quick-settings"
            cursor="pointer"
            onClicked={() => {
                toggleIcon()
                toggleVariable(visible)
            }}
            hexpand
        >
            <centerbox>
                <icon className="menu-shortcuts-btn-icon" icon={icon} />
                <label label={label}/>
                <icon className="menu-shortcuts-icon-arrow" icon={bind(iconArrow)} />
            </centerbox>
        </button>
    )
}

// ------------------- Componente Principal -------------------

function QuickSettings() {
    return <centerbox expand vertical className="revealer-box">
            <box vertical>
                <box className="btn-help">
                    <label label={bind(uptimeMinutes).as(uptime => `Uptime: ${uptime} mins`)} />
                    {[
                        "org.gnome.Settings-symbolic",
                        "uninterruptible-power-supply-symbolic",
                        logo,
                    ].map((icon, idx) => (
                        <ButtonSet
                            key={`help-${idx}`}
                            icon={icon}
                            onClick={() => safeExecAsync(["bash", "-c", "wlogout"])}
                        />
                    ))}
                </box>

                <centerbox className="btn-quick-settings-box">
                    <box></box>
                    <box >
                        <QuickButton icon={bind(iconWifi)}/>
                        <QuickButton icon={bind(iconWifi)} />
                        <QuickButton icon={bind(iconWifi)} />
                        <QuickButton icon={bind(iconWifi)} />
                        <QuickButton icon="moon-symbolic" cmd="~/.config/ags/scripts/toggle_theme.sh" />
                        <QuickButton icon="orientation-landscape-symbolic" cmd="~/.config/rofi/wall/launch.sh" />
                    </box>
                    <box></box>
                </centerbox>
            </box>
            <box className="btn-settings-box">
            
                {/*<SettingsButton visible={visibleWifi} icon={bind(iconWifi)} label="Wi-Fi" />
            {visibleWifi() && <WifiConf config={visibleWifi} />}
                <scrollable heightRequest={620} vscroll={true}>
                    <box orientation={1}> 
                        
                        <box vertical>
                            <SettingsButton visible={visibleWifi} icon={bind(iconWifi)} label="Wi-Fi" />
                            {visibleWifi() && <WifiConf config={visibleWifi} />}
                        </box>
                        <box vertical>
                            <SettingsButton icon={bind(iconBluetooth)} label="Bluetooth" />
                        </box>
                        <box vertical>
                            <SettingsButton visible={visibleSound} icon="org.gnome.Settings-sound-symbolic" label="Sound" />
                            {visibleSound() && <SoundConf config={visibleSound} />}
                        </box>
                        <box vertical>
                            <SettingsButton icon="org.gnome.Settings-keyboard-symbolic" label="Keyboard" />
                        </box>
                        <box vertical>
                            <SettingsButton visible={visibleNotification} icon="chat-bubbles-symbolic" label="Notification" />
                            {visibleNotification() && <NotificationConfig config={visibleNotification} />}
                        </box>  
                    </box>
                </scrollable>
                */}
            </box>
        </centerbox>
    
}

// ------------------- Revealer -------------------

function OnRevealer({ visible }: { visible: Variable<boolean> }) {
    return (
        <revealer
            setup={self => show(self, visible)}
            revealChild={visibleSideBar()}
            transitionType={SLIDE_RIGHT}
            transitionDuration={100}>
            <QuickSettings />
        </revealer>
    )
}

// ------------------- Ventana -------------------

export default function SideBar(monitor: Gdk.Monitor) {
    if (!monitor) {
        const display = Gdk.Display.get_default()
        monitor = display?.get_primary_monitor()
    }

    return (
        <window
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
            <eventbox onHoverLost={() => {
                safeExecAsync(["bash", "-c", "~/.config/ags/launch.sh sidebar"])
            }}>
                <centerbox>
                    <OnRevealer visible={visibleSideBar} />
                </centerbox>
            </eventbox>
        </window>
    )
}
