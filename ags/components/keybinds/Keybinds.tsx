import { App, Astal, Gdk, Gtk } from "astal/gtk3"
import { timeout } from "astal/time"
import Variable from "astal/variable"
import { bind } from "astal"
import { subprocess, exec, execAsync } from "astal/process"
import { list } from "./list"
import { show } from "../../hooks/revealer"


function OnKeybinds() {
    return (
        <box className="keybindconf-box" vertical heightRequest={550}>
            <scrollable vexpand heightRequest={100} vscroll={true}>
                <box orientation={1}>
                    {
                        list.map(i => (
                            <centerbox className="items">
                                <label label={i.name} hexpand halign={Gtk.Align.START}/>
                                <label className="command" label={i.command} hexpand halign={Gtk.Align.END}/>
                            </centerbox>   
                        ))
                    }
                </box>
            </scrollable>
        </box>
    )
}

function OnRevealer ({ visible }: { visible: Variable<boolean> }) {
    
    return <revealer
        setup={self => show(self, visible)}
        revealChild={visible()}>
        <OnKeybinds />
    </revealer>
    
}
export default function KeybindsConfig ({ config }: { config: Variable<boolean> }) {
    const visible = config
    return <OnRevealer visible={visible} />
}
