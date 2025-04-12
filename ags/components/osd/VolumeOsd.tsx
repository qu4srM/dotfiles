import { Gtk } from "astal/gtk3"
import { timeout, interval } from "astal/time"
import Variable from "astal/variable"
import { bind } from "astal"

import { volume } from "../../utils/initvars"
import { newvolume } from "../../utils/initvars"
import { visibleVol } from "../../utils/initvars"

let previousValue = undefined;

interval(1000, () => {
    const currentValue = volume.get();

    if (previousValue === undefined) {
        previousValue = currentValue;
        return;
    }

    if (currentValue !== previousValue) {
        visibleVol.set(true)
        previousValue = currentValue;
    } else if (currentValue === previousValue) {
        timeout(2000, ()=>{
            visibleVol.set(false)
        })
    }
});

export function OnVolume({ visible }: { visible: Variable<boolean> }) {
    return (
        <revealer
            revealChild={visible()}
            transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
        >
            <box className="volume-box" vertical>
                <box className="label">
                    <label label="Volumen" />
                </box>
                <box className="info">
                    <label label={bind(volume)} />
                    <overlay>
                        <box heightRequest={40} widthRequest={40}>
                            <levelbar className="level-bar" value={bind(newvolume)} widthRequest={100} />
                        </box>
                        <box className="overlay" margin-left={bind(newvolume)} valign={Gtk.Align.CENTER}>
                            <icon css="color: black;" icon="audio-volume-high-symbolic"/>
                        </box>
                    </overlay>
                </box>
            </box>
        </revealer>
    )
}

