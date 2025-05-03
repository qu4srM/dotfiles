import { App, Astal, Gdk, Gtk } from "astal/gtk3"
import { timeout } from "astal/time"
import Variable from "astal/variable"
import { bind } from "astal"

function OnRevealer ({ visible }: { visible: Variable<boolean> }) {
    function show(self) {
        if (visible === true) {
            self.revealChild = visible.get()
        } else {
            self.revealChild = visible.get()
        }
    }
    
    return <revealer
        setup={self => show(self)}
        revealChild={visible()}
        transitionType={Gtk.RevealerTransitionType.SLIDE_LEFT}>
        <label label="Child" />
    </revealer>
    
}

export default function Osd(monitor: Gdk.Monitor) {
    const {TOP, RIGHT, LEFT, BOTTOM} = Astal.WindowAnchor
    const visible = Variable(false)


    return (
        <window
            gdkmonitor={monitor}
            className="osd"
            namespace="osd"
            application={App}
            layer={Astal.Layer.OVERLAY}
            keymode={Astal.Keymode.ON_EXCLUSIVE}
            onKeyPressEvent={(self, event: Gdk.Event) => {
                if (event.get_keyval()[1] === 269025026) {
                    visible.set(true)
                    console.log("Oprimida Subir")
                } else if (event.get_keyval()[1] === 269025027) {
                    visible.set(true)
                    console.log("Oprimida Bajar")
                } else {
                    timeout(4000, ()=> {
                        visible.set(false)
                    })
                }
            }}
            exclusivity={Astal.Exclusivity.IGNORE}
            anchor={TOP | RIGHT | LEFT | BOTTOM}
            iconTheme="Papirus"
        >
            <OnRevealer visible={visible} />
        </window>
    )
}