import {App, Astal, Gtk, Gdk } from "astal/gtk3"
import { TOP, LEFT, RIGHT } from "../../utils/initvars"


export default function CornerRadius(monitor: Gdk.Monitor) {

    return <window
        className="corner-screen"
        name="corners"
        application={App}
        gdkmonitor={monitor}
        exclusivity={Astal.Exclusivity.NORMAL}
        anchor={TOP | LEFT | RIGHT}
        iconTheme="Papirus"
        >
        <centerbox>
            <box hexpand halign={Gtk.Align.START} className="box-start">
                <icon
                    className="cornerscreenleft"
                    icon="left"
                />
            </box>
            <box>
            </box>
            <box hexpand halign={Gtk.Align.END} className="box-end">
                <icon
                    className="cornerscreenright"
                    icon="right"
                />
            </box>
        </centerbox>
    </window>
}