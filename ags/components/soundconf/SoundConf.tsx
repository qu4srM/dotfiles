import Variable from "astal/variable"
import { bind } from "astal"
import { safeExecAsync } from "../../utils/manage"
import { show } from "../../utils/revealer"

import { capture } from "../../utils/initvars"
import { newCapture } from "../../utils/initvars"

// Nueva variable para controlar el volumen
import { volume } from "../../utils/initvars"

function OnRevealer ({ visible }: { visible: Variable<boolean> }) {
    
    return <revealer
        setup={self => show(self, visible)}
        revealChild={visible()}>
        <box className="soundconf-box" vertical heightRequest={550}> 
            <box orientation={1} expand>
                <box vertical>
                    {/* Slider para Capture */}
                    <label label={bind(capture)} />
                    <slider value={bind(newCapture)} widthRequest={100} onDragged={
                        (self) => {
                            const percent = Math.round(self.value * 100)
                            safeExecAsync(["bash", "-c", `amixer set Capture ${percent}%`])
                        }
                    } />
                    
                    {/* Nuevo Slider para controlar el volumen */}
                    <label label="Volume" />
                    <slider value={bind(volume)} widthRequest={100} onDragged={
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
