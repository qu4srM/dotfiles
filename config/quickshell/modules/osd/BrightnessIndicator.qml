import qs 
import qs.configs 
import qs.widgets 
import qs.utils
import qs.services

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

ProgressBarV {
    id: brightnessBar
    anchors.centerIn: parent 
    colorMain: Appearance.colors.colPrimary 
    colorBg: Appearance.colors.colSurfaceContainer 
    implicitWidth: parent.width 
    implicitHeight: parent.height - 20

    value: Brightness.value
    icon: "light_mode"
    rotateIcon: true

    // Cambiar brillo al deslizar
    motionAction: (val) => Brightness.setBrightness(val)

    // Escucha cambios de brillo en tiempo real
    Connections {
        target: Brightness
        function onBrightnessChanged(v) {
            brightnessBar.value = v
        }
    }
}
