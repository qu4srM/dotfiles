import { Astal, Gtk, Gdk } from "astal/gtk3"

export default function CornerRadius(monitor: Gdk.Monitor) {
    const {TOP, LEFT, RIGHT } = Astal.WindowAnchor

    return <window
        className="corner-screen"
        gdkmonitor={monitor}
        exclusivity={Astal.Exclusivity.NORMAL}
        anchor={TOP | LEFT | RIGHT}
        iconTheme="Papirus"
        >
        <centerbox>
            <box hexpand halign={Gtk.Align.START} className="box-start">
                <icon
                    className="cornerscreenleft"
                    icon="cornerscreenleft"
                />
            </box>
            <box>
            </box>
            <box hexpand halign={Gtk.Align.END} className="box-end">
                <icon
                    className="cornerscreenright"
                    icon="cornerscreenright"
                />
            </box>
        </centerbox>
    </window>
}