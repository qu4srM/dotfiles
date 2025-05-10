import { App, Astal, Gdk } from "astal/gtk3"
import { Variable, bind } from "astal"
import { interval,timeout } from "astal/time"
import { exec } from "astal/process"
import { TOP, RIGHT, EXCLUSIVE, LEFT, BOTTOM, IGNORE, START, CENTER, END } from "../../utils/initvars"
import { SLIDE_LEFT } from "../../utils/initvars"
import { safeExecAsync } from "../../utils/exec"

import SoundConf from "../soundconf/SoundConf"
import WifiConf from "../wificonf/WifiConf"
import NotificationConfig from "../notification/Notification"
import KeybindsConfig from "../keybinds/Keybinds"
import Microphone from "../soundconf/Microphone"
//import BluetoothConf from "../bluetoothconf/BluetoothConf"

import { logo, iconWifi, iconBluetooth } from "../bar/BarTop"
import { show } from "../../utils/revealer"

// ------------------- Estado -------------------

export const keymodeState = Variable<Astal.Keymode>(Astal.Keymode.NONE)
export const sidebarWindowName = "sidebar"
export const visibleSideBar = Variable(false)

export const capture = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/get-info.sh getsumcapture"])
export const volume = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/get-info.sh getsumvolume"])
export const brightness = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/get-info.sh getbrightness"])

export const uptimeMinutes = Variable("").poll(60000, ["bash", "-c", "awk '{print $1}' /proc/uptime | awk '{print int($1/60)}'"])

const visibleSound = Variable(false)
const visibleNotification = Variable(true)
const visibleWifi = Variable(false)
const visibleKeybinds = Variable(false)
const visibleMicrophone = Variable(false)

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
function SettingsButton({visible, icon, label, cmd}: {visible: any, icon: string, label: string, cmd: string}) {
    const iconArrow = Variable("arrow-right-symbolic")
    const toggleIcon = () => {
        const current = iconArrow.get()
        const next = current === "arrow-right-symbolic"
            ? "arrow-down-symbolic"
            : "arrow-right-symbolic"

        iconArrow.set(next)
    }
    return (
        <overlay>
            <button
                className="btn-quick-settings"
                cursor="pointer"
                onClicked={() => {
                    toggleIcon()
                    toggleVariable(visible)
                    safeExecAsync(["bash", "-c", cmd])
                }}
                hexpand
            >
                <box>
                    <icon className="menu-shortcuts-btn-icon" icon={icon} />
                    <icon className="menu-shortcuts-icon-arrow" icon={bind(iconArrow)} />
                </box>
            </button>
            <box className="overlay-text" valign={CENTER} halign={CENTER}>
                <label label={label}/>
            </box>
        </overlay>
    )
}
function SliderButton({visible, icon, variable, cmd, tool}: {visible: any, icon: string,variable: any, label: string, cmd: string, tool: string}) {
    const iconArrow = Variable("arrow-right-symbolic")
    const toggleIcon = () => {
        const current = iconArrow.get()
        const next = current === "arrow-right-symbolic"
            ? "arrow-down-symbolic"
            : "arrow-right-symbolic"

        iconArrow.set(next)
    }
    return (
        <overlay>
            <button
                className="btn-slider-settings"
                cursor="pointer"
                onClicked={() => {
                    toggleIcon()
                    toggleVariable(visible)
                }}
                hexpand
            >
                <box>
                    <icon className="menu-shortcuts-btn-icon" icon={icon} />
                    <icon className="menu-shortcuts-icon-arrow" icon={bind(iconArrow)} />
                </box>
            </button>
            <box className="slider" valign={CENTER} halign={START}>
                <slider value={variable} widthRequest={100} onDragged={
                    (self) => {
                    const percent = Math.round(self.value * 100)
                    safeExecAsync(["bash", "-c", `${tool} set ${cmd} ${percent}%`])
                    }
                }/>
            </box>
        </overlay>
    )
}

// ------------------- Componente Principal -------------------

function QuickSettings() {
    const value = Variable(0)
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
            <scrollable heightRequest={610} vscroll={true}>
                <box orientation={1}> 
                    <centerbox className="btn-keymode">
                        <label label={bind(keymodeState).as(v =>
                            v === Astal.Keymode.NONE
                                ? "Off Keymode"
                                : "On Keymode"
                        )} halign={START} />
                        <label label="" halign={CENTER}/>
                        <switch 
                            halign={END} 
                            active={bind(value)} 
                            onNotifyActive={self => {
                                console.log(self)
                                const current = keymodeState.get();
                                const next = current === 0 ? Astal.Keymode.ON_DEMAND : Astal.Keymode.NONE;
                                keymodeState.set(next)
                            }} 
                        />
                    </centerbox>
                    <box vertical>
                        <SettingsButton visible={visibleWifi} icon={bind(iconWifi)} label="Wi-Fi" cmd="~/.config/ags/scripts/network-info.sh listupdate" />
                        {visibleWifi() && <WifiConf config={visibleWifi} />}
                    </box>
                    <box vertical>
                        <SettingsButton icon={bind(iconBluetooth)} label="Bluetooth" />
                    </box>
                    <box vertical>
                        <SliderButton visible={visibleMicrophone} icon="org.gnome.Settings-microphone-symbolic" variable={bind(capture)} cmd="Capture" tool="amixer"/>
                        {visibleMicrophone() && <Microphone config={visibleMicrophone} />}
                    </box>
                    <box vertical>
                        <SliderButton visible={visibleSound}  icon="org.gnome.Settings-sound-symbolic" variable={bind(volume)} cmd="Master" tool="amixer"/>
                        {visibleSound() && <SoundConf config={visibleSound} />}
                    </box>
                    <box vertical>
                        <SliderButton icon="display-brightness-symbolic" variable={bind(brightness)} cmd="" tool="brightnessctl"/>
                    </box>
                    <box vertical>
                        <SettingsButton visible={visibleKeybinds} icon="org.gnome.Settings-keyboard-symbolic" label="Keybinds" cmd="" />
                        {visibleKeybinds() && <KeybindsConfig config={visibleKeybinds} />}
                    </box>
                    <box vertical>
                        <SettingsButton visible={visibleNotification} icon="chat-bubbles-symbolic" label="Notification" cmd="" />
                        {visibleNotification() && <NotificationConfig config={visibleNotification} />}
                    </box> 
                </box>
            </scrollable>
        </centerbox>
    
}

// ------------------- Revealer -------------------

function OnRevealer({ visible }: { visible: Variable<boolean> }) {
    return (
        <revealer
            setup={self => show(self, visible)}
            revealChild={visibleSideBar()}
            transitionType={SLIDE_LEFT}
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
            keymode={bind(keymodeState)}
            exclusivity={EXCLUSIVE} // Only LEFTBAR
            //layer={Astal.Layer.OVERLAY} # TOPBAR
            //anchor={TOP | RIGHT | BOTTOM} # TOPBAR
            anchor={TOP | LEFT | BOTTOM}
            marginTop="6"
            marginLeft="6"
            marginBottom="6"
            setup={self => {
                if (!visibleSideBar.get()) {
                    self.hide()
                }
            }}
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