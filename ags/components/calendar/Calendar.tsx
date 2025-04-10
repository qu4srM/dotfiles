import { App, Astal, Gdk, Gtk } from "astal/gtk3"
import { timeout } from "astal/time"
import Variable from "astal/variable"
import { bind } from "astal"
import { subprocess, exec, execAsync } from "astal/process"
import { show } from "../../hooks/revealer"


function Volume() {
    return <centerbox vertical className="revealer-box">
        <box heightRequest={100} widthRequest={100}></box>
    </centerbox>
}

function OnRevealer ({ visible }: { visible: Variable<boolean> }) {
    
    return <revealer
        setup={self => show(self, visible)}
        revealChild={visible()}>
        <Volume />
    </revealer>
    
}
export default function CalendarConfig ({ config }: { config: Variable<boolean> }) {
    const visible = config
    return <OnRevealer visible={visible} />
}
