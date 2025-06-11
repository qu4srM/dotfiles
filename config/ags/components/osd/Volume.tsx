import { App, Astal, Gdk, Gtk } from "astal/gtk3"
import Variable from "astal/variable"
import { bind } from "astal"
import { interval, timeout } from "astal/time"
import { safeExecAsync } from "../../utils/exec"
import { SLIDE_LEFT, START, RIGHT, CENTER, END, countSeconds, countMinutes } from "../../utils/initvars"
import { show } from "../../utils/revealer"

const currentVolume = Variable("0")
const volumeValue = Variable(0.0);
const visible = Variable(false)
const levelbarClass = Variable("");

let hideTimer: ReturnType<typeof timeout> | null = null
interval(300, async () => {
    const out = await safeExecAsync(["bash", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@"]);
    const match = out?.match(/[\d.]+/);
    const raw = match ? parseFloat(match[0]) : 0;
    const vol = Math.round(raw * 100); // Redondeado para el texto

    if (vol !== currentVolume.get()) {
        currentVolume.set(vol);
        volumeValue.set(parseFloat(raw.toFixed(2))); // Nivel con 2 decimales para el levelbar
        visible.set(true);

        if (hideTimer) hideTimer.cancel();
        hideTimer = timeout(1000, () => visible.set(false));
    }
    if (vol >= 96) {
        levelbarClass.set("volume-high");
    } else {
        levelbarClass.set("");
    }
});


function OnVolume({ visible }: { visible: Variable<boolean> }) {

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
                        value={volumeValue()}
                    />
                </box>
                <centerbox className="overlay" orientation={1} valign={Gtk.Align.CENTER}>
                    <label label={bind(currentVolume).as(v => `${v}`)} />
                    <box> </box>
                    <icon icon="org.gnome.Settings-sound-symbolic" />
                </centerbox>
            </overlay>
        </revealer>
    )
}

export default function Volume(monitor: Gdk.Monitor) {

    return (
        <window
            gdkmonitor={monitor}
            className="volume"
            namespace="volume"
            application={App}
            layer={Astal.Layer.OVERLAY}
            keymode={Astal.Keymode.ON_DEMAND}
            anchor={RIGHT}
        >
            <OnVolume visible={visible} />
        </window>
    )
}