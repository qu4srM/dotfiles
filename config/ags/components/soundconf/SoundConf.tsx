import Variable from "astal/variable"
import { bind } from "astal"
import { safeExecAsync } from "../../utils/exec"
import { show } from "../../utils/revealer"

import { SLIDE_DOWN, START, CENTER, END} from "../../utils/initvars"
export const outputAudio = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/get-info.sh getsinks"])


function OnRevealer ({ visible }: { visible: Variable<boolean> }) {

    return <revealer
        setup={self => {
            show(self, visible)
        }}
        revealChild={visible()}
        transitionType={SLIDE_DOWN}
        transitionDuration={100}>
        <box className="soundconf-box" orientation={1}> 
            <box>
                <label label="Audio Output: " />
                <label label={bind(outputAudio)} />
            </box>
            <button onClicked={()=> {
                safeExecAsync(["bash", "-c", "$HOME/.config/ags/scripts/get-info.sh toggleoutputaudio"])
            }}>
                Toggle Audio
            </button>
        </box>
    </revealer>
    
}

export default function SoundConf ({ config }: { config: Variable<boolean> }) {
    const visible = config
    return <OnRevealer visible={visible} />
}
