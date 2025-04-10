import { App, Astal, Gdk, Gtk } from "astal/gtk3"
import { timeout } from "astal/time"
import Variable from "astal/variable"
import { bind } from "astal"
import { subprocess, exec, execAsync } from "astal/process"
import { show } from "../../hooks/revealer"


const capture = Variable("").poll(100, ["bash", "-c", "~/.config/ags/scripts/get-info.sh getcapture"])
const newCapture = Variable("").poll(100, ["bash", "-c", "~/.config/ags/scripts/get-info.sh getsumcapture"])

function OnRevealer ({ visible }: { visible: Variable<boolean> }) {
    
    return <revealer
        setup={self => show(self, visible)}
        revealChild={visible()}>
        <box className="soundconf-box" vertical heightRequest={550}> 
            <box orientation={1} expand>
                <box vertical>
                    <label label={bind(capture)} />
                    <slider value={bind(newCapture)} widthRequest={100} onDragged={
                        (self)=> {
                            execAsync([`bash -c "amixer set Capture ${self.value}"`])
                            .then((out) => console.log(out))
                            .catch((err) => console.error(err))
                        }
                    } />
                </box>
            </box>
        </box>
    </revealer>
    
}
export default function SoundConf ({ config }: { config: Variable<boolean> }) {
    const visible = config
    return <OnRevealer visible={visible} />
}
