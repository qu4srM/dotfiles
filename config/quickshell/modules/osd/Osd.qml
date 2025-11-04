import qs 
import qs.configs 
import qs.widgets 
import qs.services

import QtQuick
import Quickshell


Scope {
    id: root

    property string currentIndicator: "volume"
    property var indicators: [
        {
            id: "volume",
            sourceUrl: "./VolumeIndicator.qml"
        },
        {
            id: "brightness",
            sourceUrl: "./BrightnessIndicator.qml"
        },
    ]

    function hide () {
        GlobalStates.osdVolumeOpen = false;
    }


    function triggerOsd() {
        GlobalStates.osdVolumeOpen = true;
        osdTimeout.restart();
    }

    Timer {
        id: osdTimeout
        interval: 3000
        repeat: false
        onTriggered: root.hide()
    }
    Connections {
        target: Brightness
        function onBrightnessChanged() {
            root.currentIndicator = "brightness";
            root.triggerOsd();
        }
    }

    Connections {
        target: Audio.sink?.audio ?? null
        function onVolumeChanged() {
            if (!Audio.ready)
                return;
            root.currentIndicator = "volume";
            root.triggerOsd();
        }
        function onMutedChanged() {
            if (!Audio.ready)
                return;
            root.currentIndicator = "volume";
            root.triggerOsd();
        }
    }
    Connections {
        target: Audio
        function onSinkProtectionTriggered(reason) {
            root.currentIndicator = "volume";
            root.triggerOsd();
        }
    }
    Loader {
        id: osdLoader
        active: GlobalStates.osdVolumeOpen
        sourceComponent: StyledWindow {
            id: volume
            visible: osdLoader.active
            name: "osd"
            color: "transparent"
            exclusiveZone: 0
            anchors {
                left: true
            }
            implicitWidth: 70
            implicitHeight: 300

            property string pathIcons: "root:/assets/icons/"
            property string colorMain: "transparent"
            property string pathScripts: "~/.config/quickshell/scripts/"
            Rectangle {
                anchors.fill: parent
                anchors.margins: 10
                color: Appearance.colors.colBackground
                radius: Appearance.rounding.full
                Loader {
                    id: osdIndicatorLoader
                    anchors.fill: parent
                    source: root.indicators.find(i => i.id === root.currentIndicator)?.sourceUrl
                }
            }
        }
    }
}

