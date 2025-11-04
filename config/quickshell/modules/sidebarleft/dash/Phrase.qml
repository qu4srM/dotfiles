import qs
import qs.configs
import qs.widgets 
import qs.utils

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
    implicitWidth: parent.width 
    implicitHeight: phrase.implicitHeight + phrase.anchors.margins * 2
    
    StyledText {
        id: phrase
        anchors.fill: parent
        anchors.margins: 10
        wrapMode: Text.Wrap
        text: "No permitas que tus miedos y debilidades te alejen de tus objetivos. Mantén tu corazón ardiendo. Recuerda que el tiempo no espera a nadie, no te hará compañía."
        color: Appearance.colors.colPrimary
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignTop
    }
}