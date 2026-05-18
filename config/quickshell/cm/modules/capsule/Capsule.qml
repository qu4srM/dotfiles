import qs
import qs.configs
import qs.configs.utils
import qs.modules.capsule
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
                    left: true 
                    right: true
                }
                margins {
                    top: Config.options.bar.floating ? Appearance.margins.panelMargin : 0
                }
                implicitHeight: 500
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
                
                DiagonalContainer {
                    id: content
                    property bool expanded: false

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 1

                    implicitWidth: expanded ? contentExpanded.width : Appearance.sizes.capsuleWidth
                    implicitHeight: expanded ? contentExpanded.height : Appearance.sizes.capsuleHeight

                    cornerSize: Appearance.rounding.small - 4
                    color: "#000000"
                    borderWidth: 1
                    borderColor: '#18ffffff'

                    Behavior on cornerSize {
                        animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
                    }


                    Behavior on implicitWidth {
                        animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
                    }

                    Behavior on implicitHeight {
                        animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: content.expanded = !content.expanded
                    }

                    CapsuleCollapsed {
                        id: contentCollapsed
                        anchors.fill: parent

                        visible: opacity > 0
                        opacity: content.expanded ? 0 : 1

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 400
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
                            }
                        }
                    }

                    CapsuleExpanded {
                        id: contentExpanded
                        show: content.expanded

                        anchors.centerIn: parent

                        visible: opacity > 0
                        opacity: content.expanded ? 1 : 0

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 400
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
                            }
                        }
                    }
                }
            
            }
        }
    }
}