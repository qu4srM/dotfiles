import Variable from "astal/variable"
import { bind } from "astal"
import { safeExecAsync } from "../../utils/exec"
import { show } from "../../utils/revealer"

import { SLIDE_DOWN, START, CENTER, END, countSeconds} from "../../utils/initvars"


export const microphone = Variable("").poll(countSeconds(1), ["bash", "-c", "~/.config/ags/scripts/get-info.sh getmicrophone"])


function OnRevealer ({ visible }: { visible: Variable<boolean> }) {
    return <revealer
        setup={self => {
            show(self, visible)
        }}
        revealChild={visible()}
        transitionType={SLIDE_DOWN}
        transitionDuration={100}>
        <box className="microphone-box" orientation={1}> 
            <box>
                <label label="Microphone: "/>
                <label label={bind(microphone)} />
            </box>
            <button onClicked={()=> {
                safeExecAsync(["bash", "-c", "$HOME/.config/ags/scripts/get-info.sh togglemicrophone"])
            }}>
                Toggle Microphone
            </button>
        </box>
    </revealer>
    
}

export default function Microphone ({ config }: { config: Variable<boolean> }) {
    const visible = config
    return <OnRevealer visible={visible} />
}
