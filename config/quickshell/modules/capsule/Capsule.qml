import qs
import qs.configs
import qs.modules.capsule
import qs.utils
import qs.widgets 
import qs.services

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
            active: true//GlobalStates.capsuleOpen
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
                    left: true 
                    right: true
                }
                implicitHeight: 600
                property string pathIcons: "root:/assets/icons/"
                property string pathScripts: "~/.config/quickshell/scripts/"

                mask: Region { item: content}
                function hide () {
                    content.expanded = false
                }
                HyprlandFocusGrab {
                    active: content.expanded
                    windows: [capsule]
                    onCleared: () => {
                        capsule.hide()
                    }
                }
                
                Rectangle {
                    id: content
                    property bool expanded: false
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top 
                    anchors.topMargin: 3

                    implicitWidth: expanded ? contentExpanded.width : 200
                    implicitHeight: expanded ? contentExpanded.height : 34
 
                    radius: Appearance.rounding.normal
                    color: "#000000"
                    clip: true

                    Behavior on implicitWidth {
                        NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
                    }
                    Behavior on implicitHeight {
                        NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
                    }
                    MouseArea {
                        anchors.fill: parent 
                        onClicked: {
                            content.expanded = true
                        }
                    }


                    CapsuleCollapsed {
                        id: contentCollapsed
                        visible: !content.expanded
                        anchors.fill: parent
                    }

                    CapsuleExpanded {
                        id: contentExpanded
                        visible: content.expanded
                    }
                }
            
            }
        }
    }
}