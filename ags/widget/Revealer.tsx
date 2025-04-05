import { App, Astal, Gdk, Gtk } from "astal/gtk3"
import { timeout } from "astal/time"
import Variable from "astal/variable"
import { bind } from "astal"

/*
            setup={(self) => {
                self.hook(()=> {
                    show()
                })
            }}*/

function OnRevealer({ visible }: { visible: Variable<boolean> }) {
    function show (self) {
        let count = 0
        if (self.revealChild === true) {
            console.log("Hay errores")
        } else {
            visible.set(true)
            count++
            timeout(2000, () => {
                count--
                if (count === 0) visible.set(false)
                console.log("Sirviendo")
            })
        }
    }   
    return (
        <revealer
            setup={
                (self) => show(self)
            }
            revealChild={visible()}
            transitionType={Gtk.RevealerTransitionType.SLIDE_UP}
        >
            <box className="revealer-box">
                <label label="Child" />
            </box>
        </revealer>
    )
}

export default function Revealer(monitor: Gdk.Monitor) {
    const {TOP, RIGHT} = Astal.WindowAnchor
    const visible = Variable(false)


    return (
        <window
            gdkmonitor={monitor}
            className="revealer"
            namespace="revealer"
            keymode={Astal.Keymode.ON_DEMAND}
            exclusivity={Astal.Exclusivity.NORMAL}
            anchor={TOP | RIGHT}
            iconTheme="Papirus"
            marginLeft="10"
            marginTop="10"
        >
            <eventbox onClick={() => {
                visible.set(false)
            }}>
                <OnRevealer visible={visible} />
            </eventbox>
        </window>
    )
}