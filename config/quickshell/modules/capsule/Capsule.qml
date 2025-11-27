import qs
import qs.configs
import qs.modules.capsule
import qs.utils
import qs.widgets 

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import Quickshell.Io
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland


Scope {
    id: root
        
    function hide() {
        GlobalStates.capsuleOpen = false
    }

    function trigger() {
        GlobalStates.capsuleOpen = true;
        timeout.restart();
    }

    Timer {
        id: timeout
        interval: 3000
        repeat: false
        onTriggered: root.hide()
    }
    Connections {
        target: GlobalStates
        function onCapsuleOpenChanged() {
            if (GlobalStates.capsuleOpen)
                root.trigger();
            else
                timeout.stop();
        }
    }
    Variants {
        model: Quickshell.screens
        LazyLoader {
            id: capsuleLoader 
            active: GlobalStates.capsuleOpen
            required property ShellScreen modelData 
            component: StyledWindow {
                id: capsule
                screen: capsuleLoader.modelData
                name: "capsule"
                color: "transparent"
            
                exclusionMode: ExclusionMode.Ignore
                WlrLayershell.layer: WlrLayer.Overlay
                anchors {
                    top: true
                }
                margins {
                    top: Appearance.sizes.barHeight + Appearance.margins.panelMargin * 2
                }

                implicitWidth: 200 //Appearance.sizes.capsuleWidth
                implicitHeight: 100
                property string pathIcons: "root:/assets/icons/"
                property string pathScripts: "~/.config/quickshell/scripts/"

                HyprlandFocusGrab {
                    id: grab
                    windows: [ capsule ]
                    active: GlobalStates.capsuleOpen
                    onCleared: () => {
                        if (!active)
                            root.hide()
                    }
                }

                /*Loader {
                    id: capsuleLoader2
                    active: GlobalStates.capsuleOpen
                    anchors.fill: parent
                    focus: GlobalStates.capsuleOpen
                    Keys.onPressed: (event) => {
                        if (event.key === Qt.Key_Escape) {
                            root.hide();
                        }
                    }
                    sourceComponent: Rectangle {
                        color: Config.options.bar.showBackground ? Appearance.colors.colSurface : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                        anchors.fill: parent
                        radius: Appearance.rounding.normal
                        StyledText {
                            text: "Hola Mundo"
                        }
                        //Content {}
                    }
                }*/
                Text {
                    text: "Hola"
                }
                Rectangle {
                    implicitWidth: 100
                    implicitHeight: 40
                    color: Appearance.colors.colBackground
                    radius: Appearance.rounding.full
                }

            }
        }
    }
    component Panels: Loader {
        required property bool active
        anchors.fill: parent
        active: active
        focus: active
        Keys.onPressed: (event) => {
            if (event.key === Qt.Key_Escape) {
                root.hide();
            }
        }
    }
}