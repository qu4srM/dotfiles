import { App, Astal, Gdk, Gtk } from "astal/gtk3"
import { Variable, bind } from "astal"
import { interval,timeout } from "astal/time"
import { safeExecAsync } from "../../utils/exec"
import { show } from "../../utils/revealer"
import { TOP, LEFT, BOTTOM} from "../../utils/initvars"
import { SLIDE_RIGHT} from "../../utils/initvars"
import { IGNORE } from "../../utils/initvars"
import { END, CENTER, START } from "../../utils/initvars"
import { stateHTB, formattedDate, formattedTime } from "../bar/BarTop"

export const hackWindowName = "hack"
export const visibleHack= Variable(false)
export const keymodeState = Variable<Astal.Keymode>(Astal.Keymode.NONE)
export const notes = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/htb-status.sh notes"])
export const target = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/htb-status.sh target"])


const notesWrite = Variable("")

function sendRequest() {
    safeExecAsync(["bash", "-c", `echo "${notesWrite.get()}. ${formattedTime} · ${formattedDate}" >> $HOME/.config/ags/components/hack/notes.txt`])
}
function clearNotes() {
    safeExecAsync(["bash", "-c", `echo "" > $HOME/.config/ags/components/hack/notes.txt`])
}
function OnRevealer ({ visible }: { visible: Variable<boolean> }) {  
    const value = Variable(0) 
    return <revealer
        setup={self => show(self, visible)}
        revealChild={visibleHack()}
        transitionType={SLIDE_RIGHT}
        transitionDuration={100}>
        <box orientation={1} className="revealer-box">
            <centerbox className="btn-keymode">
                <label label={bind(keymodeState).as(v =>
                    v === Astal.Keymode.NONE
                        ? "Off Keymode"
                        : "On Keymode"
                )} halign={START} />
                <label label="" halign={CENTER}/>
                <switch 
                    halign={END} 
                    active={bind(value)} 
                    onNotifyActive={self => {
                        console.log(self)
                        const current = keymodeState.get();
                        const next = current === 0 ? Astal.Keymode.ON_DEMAND : Astal.Keymode.NONE;
                        keymodeState.set(next)
                    }} 
                />
            </centerbox>
            <eventbox cursor="pointer" onClick={()=> {
                safeExecAsync(["bash", "-c", `echo "${stateHTB.get()}" | wl-copy `])
            }}>
                <label label={bind(stateHTB).as(v => `My IP: ${v}`)} halign={Gtk.Align.START} />
            </eventbox>
            <eventbox cursor="pointer" onClick={()=> {
                safeExecAsync(["bash", "-c", `echo "${target.get()}" | wl-copy `])
            }}>
                <label label={bind(target).as(v => `IP Machine: ${v}`)} halign={Gtk.Align.START} />
            </eventbox>
            <entry placeholder-text="Enter Notes" 
                widthRequest={300}
                halign={Gtk.Align.CENTER}
                onChanged={e => notesWrite.set(e.text)} />
            <box>
                <button onClicked={sendRequest}>
                    Send Note
                </button>
                <button onClicked={clearNotes}>
                    Clear Notes
                </button>
            </box>
            <label label="Notes: " halign={Gtk.Align.START} />
            <scrollable widthRequest={300} heightRequest={100}>
                <label label={bind(notes)} halign={Gtk.Align.START} />
            </scrollable>
        </box>
    </revealer>
    
}

export default function Hack(monitor: Gdk.Monitor) {
    if (!monitor) {
        const display = Gdk.Display.get_default()
        monitor = display?.get_primary_monitor()
    }
    return <window
        className={hackWindowName}
        name={hackWindowName}
        application={App}
        gdkmonitor={monitor}
        layer={Astal.Layer.OVERLAY}
        keymode={bind(keymodeState)}
        anchor={TOP | LEFT}
        marginTop="6"
        marginLeft="6"
        setup={self => {
            if (!visibleHack.get()) {
                self.hide()
            }
        }}
        >
        <eventbox onHoverLost={
            ()=> {
                safeExecAsync(["bash", "-c", "~/.config/ags/launch.sh hack"])
            }
        }>
            <centerbox>
                <OnRevealer visible={visibleHack} />
            </centerbox>
        </eventbox>
        
    </window>
}