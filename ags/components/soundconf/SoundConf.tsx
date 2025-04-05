import { App, Astal, Gdk, Gtk } from "astal/gtk3"
import { timeout } from "astal/time"
import Variable from "astal/variable"
import { bind } from "astal"
import { subprocess, exec, execAsync } from "astal/process"


const capture = Variable("").poll(100, ["bash", "-c", "~/.config/ags/scripts/get-info.sh getcapture"])
const newCapture = Variable("").poll(100, ["bash", "-c", "~/.config/ags/scripts/get-info.sh getsumcapture"])

function OnRevealer ({ visible }: { visible: Variable<boolean> }) {
    const {SLIDE_DOWN, SLIDE_TOP} = Gtk.RevealerTransitionType
    function show(self) {
        if (visible === true) {
            self.revealChild = visible.get()
            self.transitionType = SLIDE_TOP
        } else {
            self.revealChild = visible.get()
            self.transitionType = SLIDE_DOWN
        }
    }
    
    return <revealer
        setup={self => show(self)}
        revealChild={visible()}>
        <box className="soundconf-box" vertical heightRequest={550}>
            <label label="Volume Config" /> 
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
