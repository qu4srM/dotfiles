import { App, Astal, Gdk } from "astal/gtk3"
import { Variable, bind } from "astal"
import { interval,timeout } from "astal/time"
import { exec } from "astal/process"
import { TOP, RIGHT, EXCLUSIVE, LEFT, BOTTOM, IGNORE, START, CENTER, END, countMinutes, countSeconds, NORMAL } from "../../utils/initvars"
import { SLIDE_LEFT, SLIDE_RIGHT } from "../../utils/initvars"
import { safeExecAsync } from "../../utils/exec"
import { activeBar } from "../../utils/initvars"

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

export const capture = Variable("").poll(countSeconds(1), ["bash", "-c", "~/.config/ags/scripts/get-info.sh getsumcapture"])
export const volume = Variable("").poll(countSeconds(1), ["bash", "-c", "~/.config/ags/scripts/get-info.sh getsumvolume"])
export const brightness = Variable("").poll(countSeconds(1), ["bash", "-c", "~/.config/ags/scripts/get-info.sh getbrightness"])

export const uptimeMinutes = Variable("").poll(countMinutes(1), ["bash", "-c", "awk '{print $1}' /proc/uptime | awk '{print int($1/60)}'"])

const visibleSound = Variable(false)
const visibleNotification = Variable(true)
const visibleWifi = Variable(false)
const visibleKeybinds = Variable(false)
const visibleMicrophone = Variable(false)

const anchor = Variable()
const exclusivity = Variable()
const layer = Variable()
const left = Variable("")
const right = Variable("")
const size = Variable()
const slide = Variable()

if (activeBar.get() === "bartop") {
    anchor.set(TOP | RIGHT | BOTTOM)
    exclusivity.set(NORMAL)
    layer.set(Astal.Layer.OVERLAY)
    left.set("0")
    right.set("14")
    size.set(600)
    slide.set(SLIDE_LEFT)
} else if (activeBar.get() === "barleft") {
    anchor.set(TOP | LEFT | BOTTOM)
    exclusivity.set(EXCLUSIVE)
    layer.set(Astal.Layer.TOP)
    left.set("14")
    right.set("0")
    size.set(630)
    slide.set(SLIDE_RIGHT)
}

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
        <overlay hexpand>
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
            <box className="slider" valign={CENTER} halign={START} hexpand>
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
                        logo,
                        "shutdown-symbolic",
                        "settings2-symbolic"
                    ].map((icon, idx) => (
                        <ButtonSet
                            key={`help-${idx}`}
                            icon={icon}
                            onClick={() => safeExecAsync(["bash", "-c", "wlogout"])}
                        />
                    ))}
                </box>
            </box>
            <scrollable heightRequest={size.get()} vscroll={true}>
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
            <centerbox className="btn-quick-settings-box">
                <box></box>
                <box >
                    <QuickButton icon={bind(iconWifi)} cmd={`nmcli radio wifi | grep -q "enabled" && nmcli radio wifi off || nmcli radio wifi on`} />
                    <QuickButton icon={bind(iconBluetooth)} cmd={`bluetoothctl show | grep "Powered: yes" && bluetoothctl power off || bluetoothctl power on`}/>
                    <QuickButton icon="cut-screenshot-symbolic" cmd="~/.config/ags/launch.sh screenshot" />
                    <QuickButton icon="dnd-symbolic" cmd="astal-notifd -t" />
                    <QuickButton icon="moon-symbolic" cmd="~/.config/ags/scripts/toggle_theme.sh" />
                    <QuickButton icon="toggle-wall-symbolic" cmd="~/.config/rofi/wall/launch.sh" />
                </box>
                <box></box>
            </centerbox>
        </centerbox>
    
}

// ------------------- Revealer -------------------

function OnRevealer({ visible }: { visible: Variable<boolean> }) {
    return (
        <revealer
            setup={self => show(self, visible)}
            revealChild={visibleSideBar()}
            transitionType={slide.get()}
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
            exclusivity={exclusivity.get()} // Only LEFTBAR
            //layer={Astal.Layer.OVERLAY} # TOPBAR
            layer={layer.get()}
            //anchor={TOP | RIGHT | BOTTOM} # TOPBAR
            anchor={anchor.get()}
            marginTop="14"
            marginLeft={left.get()}
            marginRight={right.get()}
            marginBottom="14"
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