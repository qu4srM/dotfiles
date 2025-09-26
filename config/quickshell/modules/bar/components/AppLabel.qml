import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick.Layouts

Text {
    id: root
    Layout.alignment: Qt.AlignVCenter
    color: "white"
    font.family: "Roboto"
    font.pixelSize: 12
    font.weight: Font.Medium

    text: {
        const raw = Hyprland.activeToplevel?.lastIpcObject.class || ""
        raw.charAt(0).toUpperCase() + raw.slice(1)
    }
}
