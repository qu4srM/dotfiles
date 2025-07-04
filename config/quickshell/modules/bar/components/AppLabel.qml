import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Text {
    id: root
    anchors.verticalCenter: parent.verticalCenter
    color: "white"
    font.family: "Roboto"
    font.pixelSize: 12
    font.weight: Font.Medium

    text: {
        const raw = Hyprland.activeToplevel?.lastIpcObject.class || ""
        raw.charAt(0).toUpperCase() + raw.slice(1)
    }
}
