import { App, Astal, Gdk, Gtk } from "astal/gtk3"
import { Variable, bind } from "astal"
import { safeExecAsync } from "../../utils/exec"
import { show } from "../../utils/revealer"
import { TOP, LEFT, RIGHT,BOTTOM} from "../../utils/initvars"
import { END, CENTER, START } from "../../utils/initvars"

export const screenshotWindowName = "screenshot"
export const visibleScreenshot= Variable(false)

function OnRevealer ({ visible }: { visible: Variable<boolean> }) {  
    return <revealer
        setup={self => show(self, visible)}
        revealChild={visibleScreenshot()}
        transitionType={Gtk.RevealerTransitionType.CROSSFADE}
        transitionDuration={100}>
        <box orientation={1} className="revealer-box">
            <label label="Screenshot" />
            <centerbox>
                <button cursor="pointer" halign={START} onClicked={()=> {
                    safeExecAsync(["bash", "-c", "~/.config/ags/scripts/screenshot.sh all"])
                }}>
                    <box orientation={1}>
                        <label className="icon" label="" />
                        <label label="All" />
                    </box>
                </button>
                <button cursor="pointer" onClicked={()=> {
                    safeExecAsync(["bash", "-c", "~/.config/ags/scripts/screenshot.sh monitor"])
                }}>
                    <box orientation={1}>
                        <label className="icon" label="" />
                        <label label="Monitor" />
                    </box>
                </button>
                <button cursor="pointer" halign={END} onClicked={()=> {
                    safeExecAsync(["bash", "-c", "~/.config/ags/scripts/screenshot.sh area"])
                }}>
                    <box orientation={1}>
                        <label className="icon" label="" />
                        <label label="Area" />
                    </box>
                </button>
            </centerbox>
        </box>
    </revealer>
    
}

export default function ScreenShot(monitor: Gdk.Monitor) {
    if (!monitor) {
        const display = Gdk.Display.get_default()
        monitor = display?.get_primary_monitor()
    }
    return <window
        className={screenshotWindowName}
        name={screenshotWindowName}
        application={App}
        gdkmonitor={monitor}
        //keymode={Astal.Keymode.NONE}
        layer={Astal.Layer.OVERLAY}
        anchor={TOP}
        marginTop="250"
        setup={self => {
            if (!visibleScreenshot.get()) {
                self.hide()
            }
        }}
        >
        <eventbox onHoverLost={
            ()=> {
                safeExecAsync(["bash", "-c", "~/.config/ags/launch.sh screenshot"])
            }
        }>
            <centerbox>
                <OnRevealer visible={visibleScreenshot} />
            </centerbox>
        </eventbox>
        
    </window>
}