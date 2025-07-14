import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick.Controls
import QtQuick.Effects

IconImage {
    id: root
    property string icon: ""
    property real size: 0
    implicitSize: root.size
    asynchronous: true
    source: Quickshell.iconPath(root.icon, true) !== "" ? Quickshell.iconPath(root.icon) : Qt.resolvedUrl("../assets/icons/" + root.icon)
}

