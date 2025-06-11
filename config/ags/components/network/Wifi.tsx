import { App, Astal, Gdk, Gtk } from "astal/gtk3"
import Variable from "astal/variable"
import { bind } from "astal"
import { interval, timeout } from "astal/time"
import { safeExecAsync } from "../../utils/exec"
import { SLIDE_DOWN, START, CENTER, END, countSeconds } from "../../utils/initvars"
import { show } from "../../utils/revealer"
import { net1, net2, net3, net4, net5, net6, signal1, signal2, signal3, signal4, signal5, signal6 } from "../../utils/initvars"

const iconWifi = Variable("").poll(countSeconds(5), ["bash", "-c", "~/.config/ags/scripts/network-info.sh geticon"])
const name = Variable("").poll(countSeconds(5), ["bash", "-c", "~/.config/ags/scripts/network-info.sh getname"])
const networkstatus = Variable("").poll(countSeconds(5), ["bash", "-c", "~/.config/ags/scripts/network-info.sh networkstatus"])

const net = Variable("")
const passwdnet = Variable("")
const ssid = Variable("")
const status = Variable("Nothing")
export const changeColor = Variable(false)
const isconnecting = Variable(false)
const isreconnecting = Variable(false)

const nets = [net1, net2, net3, net4, net5, net6]
const signals = [signal1, signal2, signal3, signal4, signal5, signal6]

function updateNetworks() {
    safeExecAsync(['bash', '-c', `nmcli -t -f active,ssid dev wifi | grep '^no' | cut -d':' -f2 | head -n 6`])
        .then(output => {
            const lines = output.trim().split('\n');
            net1.set(lines[0] || '');
            net2.set(lines[1] || '');
            net3.set(lines[2] || '');
            net4.set(lines[3] || '');
            net5.set(lines[4] || '');
            net6.set(lines[5] || '');
        })
    safeExecAsync(['bash', '-c', `nmcli -t -f active,signal dev wifi | grep '^no' | cut -d':' -f2 | head -n 6`])
        .then(output => {
            const lines = output.trim().split('\n');
            signal1.set(parseInt(lines[0]) || 0);
            signal2.set(parseInt(lines[1]) || 0);
            signal3.set(parseInt(lines[2]) || 0);
            signal4.set(parseInt(lines[3]) || 0);
            signal5.set(parseInt(lines[4]) || 0);
            signal6.set(parseInt(lines[5]) || 0);
        })
}
function getWifiIcons(level) {
    if (level >= 75) return 'wifi-level-max-symbolic';
    if (level >= 50) return 'wifi-level-3-symbolic';
    if (level >= 25) return 'wifi-level-2-symbolic';
    return 'wifi-level-min-symbolic';
}


updateNetworks()

const gradients = [
    'linear-gradient(180deg, rgba(42, 123, 155, 0) 0%, rgb(72, 235, 181) 100%)',
    'linear-gradient(180deg, rgba(42, 123, 155, 0) 0%, rgb(72, 235, 80) 100%)',
    'linear-gradient(180deg, rgba(42, 123, 155, 0) 0%, rgb(178, 235, 72) 100%)',
    'linear-gradient(180deg, rgba(42, 123, 155, 0) 0%, rgba(237, 221, 83, 1) 100%)',
    'linear-gradient(180deg, rgba(42, 123, 155, 0) 0%, rgb(237, 165, 83) 100%)',
];
const currentGradient = Variable(gradients[0]);
let n = 0
interval(1000, () => {
    n = (n + 1) % gradients.length;
    currentGradient.set(gradients[n]);
})

function connect() {
    isconnecting.set(true)
    status.set("Connecting...")
    safeExecAsync(["bash", "-c", `nmcli dev wifi connect "${net.get()}" password "${passwdnet.get()}"`])
    timeout(10000, () => {
        isconnecting.set(false)
        status.set("Nothing")
    })
}
function reConnect() {
    isreconnecting.set(true)
    status.set("Reconnecting...")
    safeExecAsync(["bash", "-c", `nmcli connection up "${ssid.get()}" | awk '{print $1, $2, $3}'`]).then(val => status.set(val.trim()))
    timeout(10000, () => {
        isreconnecting(false)
        status.set("Nothing")
    })
}
function onChangeColor() {
    timeout(2000, () => {
        changeColor.set(false)
    })
}


function OnRevealer({ visible }: { visible: Variable<boolean> }) {

    return <revealer
        setup={self => show(self, visible)}
        revealChild={visible()}
        transitionType={SLIDE_DOWN}
        transitionDuration={100}>
        <box className="wificonf-box" vertical>
            <box className="current" vertical>
                <label label="Current network" halign={START} />
                <box>
                    <icon icon={bind(iconWifi)} />
                    <box vertical>
                        <label className="label-1" label={bind(name)} halign={START} />
                        <label className="label-2" label={bind(networkstatus)} halign={START} />
                    </box>
                </box>
            </box>
            <box className="nets" orientation={1} hexpand>
                <box>
                    <label label="Available networks" hexpand halign={Gtk.Align.START} />
                    <button className="scan" cursor="pointer" onClicked={() => {
                        changeColor.set(true)
                        updateNetworks()
                        onChangeColor()
                    }}>
                        <icon icon="scanner-symbolic" />
                    </button>
                </box>
                {Array.from({ length: 6 }, (_, i) => (
                    <button cursor="pointer" onClicked={() => {
                        safeExecAsync(["bash", "-c", `echo -n '${nets[i].get()}' | wl-copy`]);
                    }}>
                        <box>
                            <icon icon={bind(signals[i]).as(level => getWifiIcons(level))} />
                            <label label={bind(nets[i])} maxWidthChars={24} wrap />
                        </box>
                    </button>

                ))}


            </box>
            <box className="connect" orientation={1} hexpand>
                <label label="Reconnect to network saved" halign={START} />
                <box orientation={1}>
                    <entry
                        placeholder-text="Enter Network Name"
                        halign={Gtk.Align.CENTER}
                        onChanged={e => ssid.set(e.text)} />
                </box>
                <button css={bind(currentGradient).as(g => isreconnecting.get() ? `background: ${g};` : `background: #378DF7;`)} cursor="pointer" onClicked={reConnect}>
                    Reconnect
                </button>
                <label label={bind(status)} halign={CENTER} />
                <label label="Connect to network" halign={START} />
                <box orientation={1}>
                    <entry
                        placeholder-text="Enter BSSID"
                        halign={Gtk.Align.CENTER}
                        onChanged={e => net.set(e.text)} />
                    <entry
                        placeholder-text="Enter Password"
                        halign={Gtk.Align.CENTER}
                        onChanged={e => passwdnet.set(e.text)} />
                </box>
                <button css={bind(currentGradient).as(g => isconnecting.get() ? `background: ${g};` : `background: #378DF7;`)} cursor="pointer" onClicked={connect}>
                    Connect
                </button>
                <label label={bind(status)} halign={CENTER} />
            </box>
        </box>
    </revealer>

}
export default function Wifi({ config }: { config: Variable<boolean> }) {
    const visible = config
    return <OnRevealer visible={visible} />
}
