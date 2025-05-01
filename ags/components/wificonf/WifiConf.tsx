import { App, Astal, Gdk, Gtk } from "astal/gtk3"
import Variable from "astal/variable"
import { bind } from "astal"
import { safeExecAsync } from "../../utils/exec"
import { SLIDE_UP, START, CENTER, END } from "../../utils/initvars"
import { networks } from "./networks"
import { show } from "../../utils/revealer"


//const passwordSudo = Variable("").poll(1000, ["bash", "-c", "cat ~/.config/ags/password.txt"])

const iconWifi = Variable("").poll(10000, ["bash", "-c", "~/.config/ags/scripts/network-info.sh geticon"])
const status = Variable("").poll(10000, ["bash", "-c", "~/.config/ags/scripts/network-info.sh status"])
const name = Variable("").poll(10000, ["bash", "-c", "~/.config/ags/scripts/network-info.sh getname"])
const networkstatus = Variable("").poll(10000, ["bash", "-c", "~/.config/ags/scripts/network-info.sh networkstatus"])

function OnRevealer ({ visible }: { visible: Variable<boolean> }) {
    const value = Variable(1)
    
    return <revealer
        setup={self => show(self, visible)}
        revealChild={visible()}
        transitionType={SLIDE_UP}
        transitionDuration={100}>
        <box className="wificonf-box" vertical> 
            <box vertical>

                <centerbox className="power">
                    <label label={bind(status)} halign={START}/>
                    <label label="" halign={CENTER}/>
                    <switch 
                        active={bind(value)} 
                        onNotifyActive={self => {
                            const isActive = self.active
                            value.set(isActive ? 1 : 0)
                            if (isActive) {
                                safeExecAsync(["bash", "-c", "nmcli radio wifi on"])
                            } else {
                                safeExecAsync(["bash", "-c", "nmcli radio wifi off"])
                            }
                        }} 
                    />

                </centerbox>

                <box className="current" vertical>
                    <label label="Current network" halign={START}/>
                    <box>
                        <icon icon={bind(iconWifi)} />
                        <box vertical>
                            <label className="label-1" label={bind(name)} halign={START}/>
                            <label className="label-2" label={bind(networkstatus)} halign={START}/>
                        </box>
                    </box>
                </box>

                {/*
                <box className="nets" orientation={1} expand>
                    <label label="Available networks" hexpand halign={Gtk.Align.START}/>
                    
                    <box orientation={1} expand>
                        {  
                            networks.map((i) => (
                                <box className="items" vertical>
                                    <box>
                                        <icon icon={bind(iconWifi)} />
                                        <button onClick={
                                        () => {}}>
                                            <label label={i.name} maxWidthChars={16} wrap/>  
                                        </button>
                                    </box>
                                    <revealer
                                    revealChild={true}>
                                        <box className="items-info-box" vertical expand> 
                                            <centerbox vertical hexpand>
                                                <label label="Password" hexpand halign={Gtk.Align.START}/>
                                                <entry placeHolderText="Enter password" hexpand halign={Gtk.Align.START} onActivate={(self)=> {
                                                    //password.set(self.text)
                                                }}/>
                                            </centerbox>
                                            <button hexpand onClick={
                                                ()=> {
                                                    //execAsync(["bash", "-c", `echo "${passwordSudo.get()}" | sudo -S nmcli dev wifi connect "${i.name}" password "${password.get()}"`])
                                                    
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
                */}
            </box>
        </box>
    </revealer>
    
}
export default function WifiConf ({ config }: { config: Variable<boolean> }) {
    const visible = config
    return <OnRevealer visible={visible} />
}
