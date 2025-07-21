import "root:/"
import "root:/modules/common/"
import "root:/modules/sidebar/"
import "root:/modules/bar/components/"
import "root:/modules/drawers/"
import "root:/widgets/"
import "root:/utils/"

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland
PopupWindow {
    id: root
    anchor.rect.x: parentWindow.width / 2 - width / 2
    anchor.rect.y: Appearance.sizes.barHeight

    width: GlobalStates.hackOpen ? Appearance.sizes.notchHackWidth : Appearance.sizes.notchWidth
    height: GlobalStates.hackOpen ? Appearance.sizes.notchHackHeight + 10 : 0
    color: "transparent"
    visible: GlobalStates.hackOpen

    property bool delayedLoadActive: false

    Timer {
        id: loadDelayTimer
        interval: 300
        repeat: false
        onTriggered: delayedLoadActive = true
    }

    // Cuando hackOpen cambia, inicia el timer o lo detiene y resetea
    Connections {
        target: GlobalStates
        onHackOpenChanged: {
            if (GlobalStates.hackOpen) {
                loadDelayTimer.restart()
            } else {
                delayedLoadActive = false
                loadDelayTimer.stop()
            }
        }
    }

    MouseArea {
        id: popupMouseArea
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true

        onExited: {
            GlobalStates.hackOpen = false
        }

        Loader {
            id: sidebarLoader
            active: delayedLoadActive
            anchors.fill: parent
            anchors.topMargin: Appearance.margins.panelMargin
            focus: delayedLoadActive
            sourceComponent: Rectangle {
                color: "transparent"
                anchors.fill: parent
                radius: Appearance.rounding.normal

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0

                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 10

                        StyledText {
                            text: "My IP host: "
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        ActionButton {
                            colBackground: "transparent"
                            colBackgroundHover: Appearance.colors.colprimary_hover
                            buttonText: "Volume"
                            implicitHeight: parent.height
                            releaseAction: () => {
                                popup.open()
                            }
                        }

                        StyledText {
                            text: "Target: "
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        ActionButton {
                            colBackground: "transparent"
                            colBackgroundHover: Appearance.colors.colprimary_hover
                            buttonText: "Hola"
                            implicitHeight: parent.height
                            releaseAction: () => {
                                GlobalStates.onScreenVolumeOpen = true
                            }
                        }
                    }

                    StyledText {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "modifica el archivo ~/Machines/target para cambiar la ip objetivo"
                    }
                }
            }
        }
    }

    Popup {
        id: popup
        width: 200
        height: 120
        modal: true
        focus: true
        padding: 10
        background: Rectangle {
            color: "#2b2b2b"
            radius: 8
        }

        // Animación de apertura
        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 200 }
            NumberAnimation { property: "scale"; from: 0.95; to: 1.0; duration: 200; easing.type: Easing.OutCubic }
        }

        // Animación de cierre
        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 150 }
            NumberAnimation { property: "scale"; from: 1.0; to: 0.95; duration: 150; easing.type: Easing.InCubic }
        }

        contentItem: ColumnLayout {
            anchors.fill: parent
            spacing: 10

            Label {
                text: "Esto es un popup"
                color: "white"
                Layout.alignment: Qt.AlignHCenter
            }

            Button {
                text: "Cerrar"
                Layout.alignment: Qt.AlignHCenter
                onClicked: popup.close()
            }
        }
    }
}
