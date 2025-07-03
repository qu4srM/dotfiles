import Quickshell
import Quickshell.Wayland

PanelWindow {
    required property string name
    property string colorMain: "transparent"

    WlrLayershell.namespace: `shell-${name}`
    color: colorMain
}