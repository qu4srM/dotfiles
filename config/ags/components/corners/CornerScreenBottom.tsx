import {App, Astal, Gtk, Gdk } from "astal/gtk3"
import { BOTTOM, LEFT, RIGHT } from "../../utils/initvars"


export default function CornerRadiusBottom(monitor: Gdk.Monitor) {
    if (!monitor) {
        const display = Gdk.Display.get_default()
        monitor = display?.get_primary_monitor()
    }
    
    return <window
        className="corner-screen"
        name="corners"
        application={App}
        gdkmonitor={monitor}
        exclusivity={Astal.Exclusivity.NORMAL}
        anchor={BOTTOM | LEFT | RIGHT}
        iconTheme="Papirus"
        >
        <centerbox>
            <box hexpand halign={Gtk.Align.START} className="box-start">
                <icon
                    className="cornerscreenleft"
                    icon="left-bottom-symbolic"
                />
            </box>
            <box>
            </box>
            <box hexpand halign={Gtk.Align.END} className="box-end">
                <icon
                    className="cornerscreenright"
                    icon="right-bottom-symbolic"
                />
            </box>
        </centerbox>
    </window>
}