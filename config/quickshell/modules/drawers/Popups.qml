import "root:/"
import "root:/modules/common/"
import "root:/modules/sidebar/"
import "root:/modules/bar/components/"
import "root:/modules/bar/popups/"
import "root:/modules/drawers/"
import "root:/widgets/"
import "root:/utils/"

import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

Item {
    id: root
    required property ShellRoot screen
    property bool visiblePopup: true
    property string mode: ""
    property var callerRef: null

    signal opened(string mode)
    signal closed()

    readonly property bool isDetached: mode !== ""

    function open(detachMode, caller = null) {
        visiblePopup = true
        mode = detachMode
        callerRef = caller
        opened(mode)
    }

    function close() {
        visiblePopup = false
        mode = ""
        callerRef = null
        closed()
    }

    clip: false
    visible: visiblePopup
    implicitWidth: contentLoader.implicitWidth
    implicitHeight: contentLoader.implicitHeight

    Keys.onEscapePressed: close()

    HyprlandFocusGrab {
        active: root.isDetached
        windows: [QsWindow.window]
        onCleared: root.close()
    }

    Binding {
        when: root.isDetached
        target: QsWindow.window
        property: "WlrLayershell.keyboardFocus"
        value: WlrKeyboardFocus.OnDemand
    }

    Loader {
        id: contentLoader
        anchors.centerIn: parent
        //active: root.visiblePopup
        active: true
        /*
        sourceComponent: {
            switch (mode) {
                case "hack": return hackPopup;
                case "notifications": return notificationsPopup;
                default: return null;
            }
        }*/

        sourceComponent: Hola {
            x: 100
            y: 100
        }
    }
}
