import qs 
import qs.configs 
import qs.widgets 
import qs.services

import QtQuick
import QtQuick.Layouts
import Quickshell

ColumnLayout {
    anchors.fill: parent
    anchors.topMargin: 10
    anchors.bottomMargin: 10
    ShapesIcons {
        id: volumeIcon
        enable: true
        useSystemShape: false 
        shape: "12sidedcookie"
        Layout.alignment: Qt.AlignHCenter
        implicitWidth: parent.width - 20
        implicitHeight: parent.width - 20
        color: Appearance.colors.colPrimary 
        StyledMaterialSymbol {
            anchors.centerIn: parent
            text: Audio.muted ? "volume_off" : "volume_up"
            size: 20
            fill: 1
            color: Appearance.colors.colBackground
        }
    }
    ProgressBarV{
        colorMain: Appearance.colors.colPrimary 
        colorBg: Appearance.colors.colSurfaceContainer
        implicitWidth: parent.width
        implicitHeight: parent.height - volumeIcon.implicitWidth - parent.spacing
        icon: value === 0.0 ? "music_off" : "music_note"
        size: 18
        value: (Audio.muted)
            ? 0.0
            : (Audio.sink?.audio?.volume ?? 0.0)

        motionAction: (value) => {
            value = Math.max(0, Math.min(1, value));
            Quickshell.execDetached(["amixer", "set", "Master", `${Math.round(value * 100)}%`]);
        }
    }
}