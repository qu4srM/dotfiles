import { Gtk } from "astal/gtk3"
import Variable from "astal/variable"
import { list } from "./list"
import { show } from "../../utils/revealer"

import { SLIDE_DOWN } from "../../utils/initvars"


function OnKeybinds() {
    return (
        <box className="keybindconf-box" vertical>
            {
                list.map(i => (
                    <box className="items" vertical>
                        <label label={i.name} hexpand halign={Gtk.Align.START}/>
                        <label className="command" label={i.command} hexpand halign={Gtk.Align.START}/>
                    </box>   
                ))
            }
        </box>
    )
}

function OnRevealer ({ visible }: { visible: Variable<boolean> }) {
    
    return <revealer
        setup={self => {
            show(self, visible)
        }}
        revealChild={visible()}
        transitionType={SLIDE_DOWN}
        transitionDuration={100}>
        <OnKeybinds />
    </revealer>
    
}
export default function KeybindsConfig ({ config }: { config: Variable<boolean> }) {
    const visible = config
    return <OnRevealer visible={visible} />
}
