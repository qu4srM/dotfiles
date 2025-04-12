import { App, Astal, Gdk, Gtk } from "astal/gtk3"

import { TOP, LEFT, RIGHT, BOTTOM } from "../utils/initvars"

export function WindowSide(monitor: Gdk.Monitor | null = null, name: string, visible: boolean, Component: any) {
    if (!monitor) {
        const display = Gdk.Display.get_default()
        monitor = display?.get_primary_monitor()
    }
    
    const visibleOn = visible

    return <window
        className={name}
        name={name}
        application={App}
        gdkmonitor={monitor}
        exclusivity={Astal.Exclusivity.NORMAL}
        anchor={TOP | RIGHT | BOTTOM}
        iconTheme="Papirus"
        keymode={Astal.Keymode.ON_DEMAND}
        onKeyPressEvent={(self, event: Gdk.Event) => {
            if (event.get_keyval()[1] === Gdk.KEY_Escape) {
                self.hide()
            }
        }}
        marginTop="12"
        marginRight="12"
        marginBottom="12"
        >
        <Component visible={visibleOn}/>
    </window>
}
export function WindowTop(monitor: Gdk.Monitor | null = null, name: string, visible: boolean, Component: any) {
    if (!monitor) {
        const display = Gdk.Display.get_default()
        monitor = display?.get_primary_monitor()
    }

    const visibleOn = visible

    return <window
        className={name}
        name={name}
        application={App}
        gdkmonitor={monitor}
        exclusivity={Astal.Exclusivity.NORMAL}
        anchor={TOP}
        iconTheme="Papirus"
        keymode={Astal.Keymode.ON_DEMAND}
        onKeyPressEvent={(self, event: Gdk.Event) => {
            if (event.get_keyval()[1] === Gdk.KEY_Escape) {
                self.hide()
            }
        }}
        marginTop="12"
        >
        <Component visible={visibleOn}/>
    </window>
}

export function WindowRight(monitor: Gdk.Monitor | null = null, name: string, visible: boolean, Component: any) {
    if (!monitor) {
        const display = Gdk.Display.get_default()
        monitor = display?.get_primary_monitor()
    }

    const visibleOn = visible

    return <window
        className={name}
        name={name}
        application={App}
        gdkmonitor={monitor}
        exclusivity={Astal.Exclusivity.NORMAL}
        anchor={TOP | RIGHT}
        iconTheme="Papirus"
        keymode={Astal.Keymode.ON_DEMAND}
        onKeyPressEvent={(self, event: Gdk.Event) => {
            if (event.get_keyval()[1] === Gdk.KEY_Escape) {
                self.hide()
            }
        }}
        marginTop="12"
        marginRight="12"
        >
        <Component visible={visibleOn}/>
    </window>
}
export function WindowLeft(monitor: Gdk.Monitor | null = null, name: string, visible: boolean, Component: any) {
    if (!monitor) {
        const display = Gdk.Display.get_default()
        monitor = display?.get_primary_monitor()
    }

    const visibleOn = visible

    return <window
        className={name}
        name={name}
        application={App}
        gdkmonitor={monitor}
        exclusivity={Astal.Exclusivity.NORMAL}
        anchor={TOP | LEFT}
        iconTheme="Papirus"
        keymode={Astal.Keymode.ON_DEMAND}
        onKeyPressEvent={(self, event: Gdk.Event) => {
            if (event.get_keyval()[1] === Gdk.KEY_Escape) {
                self.hide()
            }
        }}
        marginTop="12"
        marginLeft="12"
        >
        <Component visible={visibleOn}/>
    </window>
}

export function WindowAlert(monitor: Gdk.Monitor | null = null, name: string, visible: boolean, Component: any) {
    if (!monitor) {
        const display = Gdk.Display.get_default()
        monitor = display?.get_primary_monitor()
    }
    const visibleOn = visible

    return <window    
        gdkmonitor={monitor}
        name="volume"
        application={App}
        className="volume"
        keymode={Astal.Keymode.NONE}
        exclusivity={Astal.Exclusivity.NORMAL}
        layer={Astal.Layer.OVERLAY}
        anchor={TOP}
        iconTheme="Papirus"
        marginTop="12"
        >
        <eventbox>
            <Component visible={visibleOn}/>
        </eventbox>
    </window>
}
