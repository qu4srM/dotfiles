import qs 
import qs.configs
import qs.widgets
import qs.services 

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    width: 400
    height: 200

    property bool verticalMode: true

    x: Config.options.background.clockX ?? (parent.width - width) / 2
    y: Config.options.background.clockY ?? 100

    // --- Reloj ---
    Item {
        id: clock
        anchors.fill: parent

        // --- Loader que alterna entre horizontal o vertical ---
        Loader {
            id: clockLoader
            anchors.fill: parent
            sourceComponent: root.verticalMode ? verticalClock : horizontalClock
        }

        // --- Reloj horizontal ---
        Component {
            id: horizontalClock
            Row {
                spacing: 0
                anchors.centerIn: parent
                Repeater {
                    model: Time.time.substring(0, 5).split(":")
                    delegate: Text {
                        text: modelData
                        font.family: Appearance.font.family.background
                        font.pixelSize: Math.min(clock.width, clock.height) * 0.5
                        color: "white"
                        transform: Scale { xScale: 1.0; yScale: 1.0 }
                    }
                }
            }
        }

        // --- Reloj vertical ---
        Component {
            id: verticalClock
            ShapesIcons {
                anchors.fill: parent
                enable: true
                useSystemShape: false 
                shape: "12sidedcookie"
            
                Column {
                    anchors.centerIn: parent
                    spacing: 10
                    StyledText {
                        height: 60
                        text: Time.time.substring(0, 2)
                        font.family: Appearance.font.family.background
                        font.pixelSize: Math.min(clock.width, clock.height) * 0.4
                        font.weight: Appearance.font.weight.black
                        color: Appearance.colors.colOnPrimary
                    }
                    StyledText {
                        height: 60
                        text: Time.time.substring(3, 5)
                        font.family: Appearance.font.family.background
                        font.pixelSize: Math.min(clock.width, clock.height) * 0.4
                        font.weight: Appearance.font.weight.black
                        color: Appearance.colors.colOnPrimaryContainer
                    }
                }
            }
        }
    }
}
