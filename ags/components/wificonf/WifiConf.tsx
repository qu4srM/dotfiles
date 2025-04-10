import { App, Astal, Gdk, Gtk } from "astal/gtk3"
import { timeout } from "astal/time"
import Variable from "astal/variable"
import { bind } from "astal"
import { subprocess, exec, execAsync } from "astal/process"

import { networks } from "./networks"
import { show } from "../../hooks/revealer"

const passwordSudo = Variable("").poll(1000, ["bash", "-c", "cat ~/.config/ags/password.txt"])

const iconWifi = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/network-info.sh geticon"])
const status = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/network-info.sh status"])
const name = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/network-info.sh getname"])
const networkstatus = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/network-info.sh networkstatus"])

function OnRevealer ({ visible }: { visible: Variable<boolean> }) {
    const {SLIDE_DOWN, SLIDE_TOP} = Gtk.RevealerTransitionType
    const visibleConnect = Variable(false)
    const password = Variable("")

    const value = Variable(1)
    
    return <revealer
        setup={self => show(self, visible)}
        revealChild={visible()}>
        <box className="wificonf-box" vertical heightRequest={550}> 
            <scrollable expand heightRequest={100} vscroll={true}>
                <box orientation={1}>
                    <centerbox className="power" hexpand>
                        <label label={bind(status)} hexpand halign={Gtk.Align.START}/>
                        <label label="" hexpand halign={Gtk.Align.CENTER}/>
                        <button hexpand halign={Gtk.Align.END} onClick={
                            ()=> {
                                if (value.get() == 0 && status.get() == "Off") {
                                    value.set(1) 
                                    execAsync(["bash", "-c", "nmcli radio wifi on"])
                                } else {
                                    value.set(0)
                                    execAsync(["bash", "-c", "nmcli radio wifi off"])
                                }
                            }
                        }>
                            <slider value={bind(value)} widthRequest={50}/>
                        </button>
                    </centerbox>
                    <Gtk.Separator visible />
                    <box className="current" vertical>
                        <label label="Current network" hexpand halign={Gtk.Align.START}/>
                        <box>
                            <icon icon={bind(iconWifi)} />
                            <box vertical>
                                <label className="label-1" label={bind(name)} hexpand halign={Gtk.Align.START}/>
                                <label className="label-2" label={bind(networkstatus)} hexpand halign={Gtk.Align.START}/>
                            </box>
                        </box>
                    </box>
                    <box className="nets" orientation={1} expand>
                        <label label="Available networks" hexpand halign={Gtk.Align.START}/>
                        
                        <box orientation={1} expand>
                            {  
                                networks.map(i => (
                                    <box className="items" vertical>
                                        <box>
                                            <icon icon={bind(iconWifi)} />
                                            <button onClick={
                                            ()=> {
                                                if (visibleConnect.get() === false){
                                                    visibleConnect.set(true)
                                                } else {
                                                    visibleConnect.set(false)
                                                }
                                            }}>
                                                <label label={i.name} />  
                                            </button>
                                        </box>
                                        <revealer
                                        setup={self => show(self, visibleConnect)}
                                        revealChild={visibleConnect()}>
                                            <box className="items-info-box" vertical expand> 
                                                <centerbox vertical hexpand>
                                                    <label label="Password" hexpand halign={Gtk.Align.START}/>
                                                    <entry marginLeft={12} placeHolderText="Enter password" hexpand halign={Gtk.Align.START} onActivate={(self)=> {
                                                        password.set(self.text)
                                                    }}/>
                                                </centerbox>
                                                <button hexpand onClick={
                                                    ()=> {
                                                        execAsync(["bash", "-c", `echo "${passwordSudo.get()}" | sudo -S nmcli dev wifi connect "${i.name}" password "${password.get()}"`])
                                                        
                                                    }
                                                }>
                                                    Connect
                                                </button>
                                            </box>
                                        </revealer>
                                    </box>   
                                ))
                                
                            }
                        </box>
                        
                    </box>
                </box>
            </scrollable>
        </box>
    </revealer>
    
}
export default function WifiConf ({ config }: { config: Variable<boolean> }) {
    const visible = config
    return <OnRevealer visible={visible} />
}
