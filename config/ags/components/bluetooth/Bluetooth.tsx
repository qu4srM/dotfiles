import { App, Astal, Gdk, Gtk } from "astal/gtk3"
import Variable from "astal/variable"
import { bind } from "astal"
import { interval, timeout } from "astal/time"
import { safeExecAsync } from "../../utils/exec"
import { SLIDE_DOWN, START, CENTER, END, countSeconds, countMinutes } from "../../utils/initvars"
import { show } from "../../utils/revealer"




const pairedDevices: Variable<string>[] = [];
const pairedMacs: Variable<string>[] = [];
const devices: Variable<string>[] = [];
const devicesMacs: Variable<string>[] = [];


const lengthAvailable = Variable(0)
const lengthPaired = Variable(0)
const lengthMacsPaired = Variable(0)
const lengthMacs = Variable(0)


const name = Variable("")
timeout(1000, () => {
    safeExecAsync(["bash", "-c", `bluetoothctl list | grep "Controller" | awk '{print $3}'`]).then(val => name.set(val.trim()))
})


const connected = Variable("").poll(countSeconds(1), ["bash", "-c", `bluetoothctl devices Connected | grep '^Device' | sed -E 's/^Device ([A-F0-9:]+) //'`])

const indicesPaired = bind(lengthPaired).as(len =>
    Array.from({ length: Math.min(len, pairedDevices.length) }, (_, i) => i)
);
const indicesAvailable = bind(lengthAvailable).as(len =>
    Array.from({ length: Math.min(len, devices.length) }, (_, i) => i)
);

let updateDevInterval: number | null = null;
function RefreshDevices() {
    UpdateDevices();

    if (updateDevInterval) {
        clearInterval(updateDevInterval);
    }

    updateDevInterval = setInterval(() => {
        UpdateDevices();
    }, 5000);

    setTimeout(() => {
        if (updateDevInterval) {
            clearInterval(updateDevInterval);
            updateDevInterval = null;
        }
    }, 10000);
}
function UpdateDevices() {
    safeExecAsync(['bash', '-c', `bluetoothctl devices | grep '^Device' | awk '{print $2}' | wc -l`]).then(val => lengthAvailable.set(val.trim()))
    safeExecAsync(['bash', '-c', `bluetoothctl devices | grep '^Device' | awk '{print $2}'`])
        .then(output => {
            const lines = output.trim().split('\n');

            // Sincronizar con el valor de lengthPaired
            lengthMacs.set(lines.length);

            // Ajustar cantidad de variables
            while (devicesMacs.length < lines.length) {
                devicesMacs.push(Variable(''));
            }
            while (devicesMacs.length > lines.length) {
                devicesMacs.pop();
            }

            // Actualizar contenido
            lines.forEach((name, i) => {
                devicesMacs[i].set(name);
            });

            // Log opcional para comprobar
            console.log("Emparejados:", lines);
        });
    safeExecAsync(['bash', '-c', `bluetoothctl devices | grep '^Device' | sed -E 's/^Device ([A-F0-9:]+) //'`])
        .then(output => {
            const lines = output.trim().split('\n');

            // Sincronizar con el valor de lengthPaired
            lengthAvailable.set(lines.length);

            // Ajustar cantidad de variables
            while (devices.length < lines.length) {
                devices.push(Variable(''));
            }
            while (devices.length > lines.length) {
                devices.pop();
            }

            // Actualizar contenido
            lines.forEach((name, i) => {
                devices[i].set(name);
            });

            // Log opcional para comprobar
            console.log("Emparejados:", lines);
        });
}


let updateInterval: number | null = null;
function RefreshDevicesPaired() {
    UpdatePaired();

    if (updateInterval) {
        clearInterval(updateInterval);
    }

    updateInterval = setInterval(() => {
        UpdatePaired();
    }, 5000);

    setTimeout(() => {
        if (updateInterval) {
            clearInterval(updateInterval);
            updateInterval = null;
        }
    }, 10000);
}
function UpdatePaired() {
    safeExecAsync(['bash', '-c', `bluetoothctl devices Paired | grep '^Device' | awk '{print $2}' | wc -l`]).then(val => lengthPaired.set(val.trim()))
    safeExecAsync(['bash', '-c', `bluetoothctl devices Paired | grep '^Device' | awk '{print $2}'`])
        .then(output => {
            const lines = output.trim().split('\n');

            // Sincronizar con el valor de lengthPaired
            lengthMacsPaired.set(lines.length);

            // Ajustar cantidad de variables
            while (pairedMacs.length < lines.length) {
                pairedMacs.push(Variable(''));
            }
            while (pairedMacs.length > lines.length) {
                pairedMacs.pop();
            }

            // Actualizar contenido
            lines.forEach((name, i) => {
                pairedMacs[i].set(name);
            });

            // Log opcional para comprobar
            console.log("Emparejados:", lines);
        });
    safeExecAsync(['bash', '-c', `bluetoothctl devices Paired | grep '^Device' | sed -E 's/^Device ([A-F0-9:]+) //'`])
        .then(output => {
            const lines = output.trim().split('\n');

            // Sincronizar con el valor de lengthPaired
            lengthPaired.set(lines.length);

            // Ajustar cantidad de variables
            while (pairedDevices.length < lines.length) {
                pairedDevices.push(Variable(''));
            }
            while (pairedDevices.length > lines.length) {
                pairedDevices.pop();
            }

            // Actualizar contenido
            lines.forEach((name, i) => {
                pairedDevices[i].set(name);
            });

            // Log opcional para comprobar
            console.log("Emparejados:", lines);
        });

}



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


function OnRevealer({ visible }: { visible: Variable<boolean> }) {

    return <revealer
        setup={self => show(self, visible)}
        revealChild={visible()}
        transitionType={SLIDE_DOWN}
        transitionDuration={100}>
        <box className="bluetooth-box" orientation={1}>
            <box className="current" orientation={1}>
                <label label={bind(name)} />
                <button onClicked={() => { console.log(lengthPaired.get()) }}>
                    Execute Requirements Bluetooth (Always)
                </button>
            </box>
            <box className="paired" orientation={1}>
                <box>
                    <label label="Paired devices" hexpand halign={Gtk.Align.START} />
                    <button className="scan" cursor="pointer" onClicked={() => {
                        RefreshDevicesPaired()
                    }}>
                        Scan
                    </button>
                </box>
                <label label={bind(connected).as(v => v ? `Connected to ${v}` : "Disconnected")} />
                {indicesPaired.as(ids => ids.map(i => (
                    <button cursor="pointer" onClicked={() => {
                        safeExecAsync(["bash", "-c", `~/.config/ags/scripts/bluetooth-info.sh toggle ${pairedMacs[i].get()}`]);
                    }}>
                        <box>
                            <label label={bind(pairedDevices[i])} maxWidthChars={24} wrap />
                        </box>
                    </button>
                )))}
            </box>
            <box className="available" orientation={1}>
                <box>
                    <label label="Available devices" hexpand halign={Gtk.Align.START} />
                    <button className="scan" cursor="pointer" onClicked={() => {
                        RefreshDevices()
                        safeExecAsync(["bash", "-c", `~/.config/ags/scripts/bluetooth-info.sh scan`])
                    }}>
                        Scan
                    </button>
                </box>
                {indicesAvailable.as(ids => ids.map(i => (
                    <button cursor="pointer" onClicked={() => {
                        //safeExecAsync(["bash", "-c", `bluetoothctl pair ${devicesMacs[i].get()}`]);
                        safeExecAsync([
                            "/usr/bin/kitty",
                            "-e",
                            "bash",
                            "-c",
                            `echo -e 'yes\n' | bluetoothctl pair ${devicesMacs[i].get()} ; read -p 'Presiona Enter para salir...'`]);
                    }}>
                        <box>
                            <label label={bind(devices[i])} maxWidthChars={24} wrap />
                        </box>
                    </button>
                )))}

            </box>
        </box>
    </revealer>

}
export default function Bluetooth({ config }: { config: Variable<boolean> }) {
    const visible = config
    return <OnRevealer visible={visible} />
}
