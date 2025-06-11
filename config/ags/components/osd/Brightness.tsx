import { App, Astal, Gdk, Gtk } from "astal/gtk3"
import Variable from "astal/variable"
import { bind } from "astal"
import { interval, timeout } from "astal/time"
import { safeExecAsync } from "../../utils/exec"
import { SLIDE_LEFT, START, RIGHT, CENTER, END, countSeconds, countMinutes } from "../../utils/initvars"
import { show } from "../../utils/revealer"

const currentBrightness = Variable("0")
const brightnessValue = Variable(0.0)
const visible = Variable(false)
const levelbarClass = Variable("");

let hideTimer: ReturnType<typeof timeout> | null = null

interval(300, async () => {
    const cur = await safeExecAsync(["bash", "-c", "brightnessctl get"])
    const max = await safeExecAsync(["bash", "-c", "brightnessctl max"])

    const raw = (parseInt(cur) || 0) / (parseInt(max) || 1)
    const percent = Math.round(raw * 100)

    if (percent !== parseInt(currentBrightness.get())) {
        currentBrightness.set(percent.toString())
        brightnessValue.set(raw)
        visible.set(true)

        if (hideTimer) hideTimer.cancel()
        hideTimer = timeout(1000, () => visible.set(false))
    }
    if (percent >= 96) {
        levelbarClass.set("brightness-high");
    } else {
        levelbarClass.set("");
    }
})

function OnBrightness({ visible }: { visible: Variable<boolean> }) {
    return (
        <revealer
            revealChild={visible()}
            transitionType={SLIDE_LEFT}
            transitionDuration={200}
            setup={self => show(self, visible)}
        >
            <overlay>
                <box orientation={1}>
                    <levelbar
                        className={levelbarClass()}
                        orientation={Gtk.Orientation.VERTICAL}
                        inverted={true}
                        heightRequest={200}
                        value={brightnessValue()}
                    />
                </box>
                <centerbox className="overlay" orientation={1} valign={Gtk.Align.CENTER}>
                    <label label={bind(currentBrightness).as(v => `${v}`)} />
                    <box> </box>
                    <icon icon="display-brightness-symbolic" />
                </centerbox>
            </overlay>
        </revealer>
    )
}

export default function Brightness(monitor: Gdk.Monitor) {
    return (
        <window
            gdkmonitor={monitor}
            className="brightness"
            namespace="brightness"
            application={App}
            layer={Astal.Layer.OVERLAY}
            keymode={Astal.Keymode.ON_DEMAND}
            anchor={RIGHT}
        >
            <OnBrightness visible={visible} />
        </window>
    )
}
