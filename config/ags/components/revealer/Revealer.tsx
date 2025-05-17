import { App, Astal, Gdk, Gtk } from "astal/gtk3"
import { timeout } from "astal/time"
import Variable from "astal/variable"
import { bind } from "astal"

function OnRevealer ({ visible }: { visible: Variable<boolean> }) {
    return <revealer
        //setup={self => show(self)}
        setup={self => timeout(500, () => {
            self.revealChild = true
            visible.set(true)
        })}
        revealChild={visible()}
        transitionType={Gtk.RevealerTransitionType.SLIDE_LEFT}>
        <label label="Child" />
    </revealer>
    
}

function RevealerSystem() {
    const visible = Variable(false)
    function showIn () {
        visible.set(true)
    }
    function showOut () {
        visible.set(false)
    }

    return <box className="revealer-box" >
        <button onClick={
            () => {
                if (visible.get() === true) {
                    showOut()
                } else {
                    showIn()
                }
            }
        }>Toggle</button>
        <box>
            <OnRevealer visible={visible}/>
        </box>
    </box>
}

export default function Revealer(monitor: Gdk.Monitor) {
    const {TOP, BOTTOM} = Astal.WindowAnchor


    return (
        <window
            gdkmonitor={monitor}
            className="revealer"
            namespace="revealer"
            keymode={Astal.Keymode.ON_DEMAND}
            exclusivity={Astal.Exclusivity.NORMAL}
            anchor={TOP | BOTTOM}
            iconTheme="Papirus"
            marginLeft="10"
            marginTop="10"
        >
            <RevealerSystem />
        </window>
    )
}