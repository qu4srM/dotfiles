import Variable from "astal/variable"
import { bind } from "astal"
import { safeExecAsync } from "../../utils/exec"
import { show } from "../../utils/revealer"

import { SLIDE_UP, SLIDE_DOWN } from "../../utils/initvars"

export const capture = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/get-info.sh getcapture"])
export const newCapture = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/get-info.sh getsumcapture"])
export const volume = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/get-info.sh getvolume"])
export const newVolume = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/get-info.sh getsumvolume"])


function OnRevealer ({ visible }: { visible: Variable<boolean> }) {
    
    return <revealer
        setup={self => {
            show(self, visible)
        }}
        revealChild={visible()}
        transitionType={SLIDE_UP}
        transitionDuration={100}>
        <box className="soundconf-box" orientation={1}> 
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
    </revealer>
    
}

export default function SoundConf ({ config }: { config: Variable<boolean> }) {
    const visible = config
    return <OnRevealer visible={visible} />
}
