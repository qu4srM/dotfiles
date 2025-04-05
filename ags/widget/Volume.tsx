import { App, Astal, Gdk, Gtk } from "astal/gtk3"
import { timeout } from "astal/time"
import Variable from "astal/variable"
import { bind } from "astal"
import { subprocess, exec, execAsync } from "astal/process"

/*
            setup={(self) => {
                self.hook(()=> {
                    show()
                })
            }}
           <slider className="vol-slider" min="0" max="100" value={bind(volume)}/> 
           <label label={bind(volume)} />
                <slider className="vol-slider" min="0" max="100" value={bind(volume)} orientation={1}/> 
                <icon 
                    icon="audio-volume-high-symbolic"
                />
*/

const volume = Variable("").poll(100, ["bash", "-c", "~/.config/ags/scripts/get-info.sh getvolume"])
const newvolume = Variable("").poll(100, ["bash", "-c", "~/.config/ags/scripts/get-info.sh getsumvolume"])


function OnVolume({ visible }: { visible: Variable<boolean> }) {
    let count = 0
    function show (self) {
        if (self.revealChild === true) {
            console.log("Hay errores")
        } else {
            visible.set(true)
            count++
            timeout(10000, () => {
                count--
                if (count === 0) { 
                    visible.set(false)
                    timeout(100, ()=> {
                        execAsync(["bash", "-c", "~/.config/ags/launch.sh stopvol"])
                            .then((out) => console.log(out))
                            .catch((err) => console.error(err))
                        
                    })
                }
            })
        }
                
            
    }
    return (
        <revealer
            setup={
                (self) => show(self)
            }
            revealChild={visible()}
            transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
        >
            <box className="volume-box" vertical>
                <box className="label">
                    <label label="Volumen" />
                </box>
                <box className="info">
                    <label label={bind(volume)} />
                    <overlay>
                        <box heightRequest={40} widthRequest={40}>
                            <levelbar className="level-bar" value={bind(newvolume)} widthRequest={100} />
                        </box>
                        <box className="overlay" margin-left={bind(newvolume)} valign={Gtk.Align.CENTER}>
                            <icon css="color: black;" icon="audio-volume-high-symbolic"/>
                        </box>
                    </overlay>
                </box>
            </box>
        </revealer>
    )
}

export default function Volume(monitor: Gdk.Monitor) {
    const {TOP} = Astal.WindowAnchor
    const visible = Variable(false)


    return (
        <window
            gdkmonitor={monitor}
            className="volume-window"
            namespace="volume"
            keymode={Astal.Keymode.ON_DEMAND}
            onKeyPressEvent={(self, event: Gdk.Event) => {
                if (event.get_keyval()[1] === Gdk.KEY_Escape) {
                    self.hide()
                    timeout(100, ()=> {
                        execAsync(["bash", "-c", "~/.config/ags/launch.sh stopvol"])
                            .then((out) => console.log(out))
                            .catch((err) => console.error(err))
                        
                    })
                } else {
                    print("Oprimiste otras")
                }
            }}
            exclusivity={Astal.Exclusivity.NORMAL}
            anchor={TOP}
            iconTheme="Papirus"
        >
            <eventbox onClick={() => {
                visible.set(false)
                timeout(200, ()=> {
                    execAsync(["bash", "-c", "~/.config/ags/launch.sh stopvol"])
                        .then((out) => console.log(out))
                        .catch((err) => console.error(err))
                    
                })
            }}>
                <OnVolume visible={visible} />
            </eventbox>
        </window>
    )
}