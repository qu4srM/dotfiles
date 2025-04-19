import Variable from "astal/variable"
import { bind } from "astal"
import { safeExecAsync } from "../../utils/manage"
import { show } from "../../utils/revealer"

import { SLIDE_UP, SLIDE_DOWN } from "../../utils/initvars"

export const capture = Variable("").poll(100, ["bash", "-c", "~/.config/ags/scripts/get-info.sh getcapture"])
export const newCapture = Variable("").poll(100, ["bash", "-c", "~/.config/ags/scripts/get-info.sh getsumcapture"])
export const volume = Variable("").poll(100, ["bash", "-c", "~/.config/ags/scripts/get-info.sh getvolume"])
export const newVolume = Variable("").poll(100, ["bash", "-c", "~/.config/ags/scripts/get-info.sh getsumvolume"])


function OnRevealer ({ visible }: { visible: Variable<boolean> }) {
    
    return <revealer
        setup={self => show(self, visible, SLIDE_UP, SLIDE_DOWN)}
        revealChild={visible()}>
        <box className="soundconf-box" vertical heightRequest={550}> 
            <box orientation={1} expand>
                <box vertical>
                    <label label={bind(capture)} />
                    <slider value={bind(newCapture)} widthRequest={100} onDragged={
                        (self) => {
                            const percent = Math.round(self.value * 100)
                            safeExecAsync(["bash", "-c", `amixer set Capture ${percent}%`])
                        }
                    } />
                    <label label={bind(volume)} />
                    <slider value={bind(newVolume)} widthRequest={100} onDragged={
                        (self) => {
                            const percent = Math.round(self.value * 100)
                            safeExecAsync(["bash", "-c", `amixer set Master ${percent}%`])
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
