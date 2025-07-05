import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Hyprland



PopupWindow {
    required property Item windowItem
    anchor.window: windowItem
    anchor.rect.x: parentWindow.width / 2 - width / 2
    anchor.rect.y: parentWindow.height
    width: 500
    height: 500
    visible: false
    Rectangle {
        implicitWidth: parent.width
        implicitHeight: parent.height
        color: "black"
    }
}