import qs
import qs.modules.background
import qs.configs
import qs.widgets
import qs.utils
import qs.services

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland


Scope {
    id: root

    Variants {
        model: Quickshell.screens
        LazyLoader {
            id: backgroundLoader 
            active:  GlobalStates.backgroundOpen && !GlobalStates.screenLock
            required property ShellScreen modelData 
            component: StyledWindow {
                id: background
                screen: backgroundLoader.modelData
                name: "background"
                WlrLayershell.layer: WlrLayer.Bottom
                color: "transparent"
                exclusionMode: ExclusionMode.Ignore

                anchors {
                    top: true
                    bottom: true
                    left: true
                    right: true
                }
                

                
                Wallpaper {
                    id: wallpaper
                    window: background
                }
            

                    

                Item {
                    id: uiLayer
                    anchors.fill: parent

                    /*Item {
                        id: weather
                        anchors.bottom: clock.top
                        anchors.right: clock.right
                        anchors.bottomMargin: -30
                        anchors.rightMargin: 70
                        z: 10

                        implicitWidth: shape.implicitWidth
                        implicitHeight: shape.implicitHeight

                        ShapesIcons {
                            id: shape
                            implicitWidth: 120
                            implicitHeight: implicitWidth - 30
                            enable: true
                            useSystemShape: false
                            shape: "oval"
                            color: Appearance.colors.colPrimary
                        }

                        StyledText {
                            anchors.right: parent.right
                            anchors.rightMargin: 15
                            text: Weather.temperature
                            color: Appearance.colors.colOnPrimary
                            font.family: Appearance.font.family.background
                            font.pixelSize: 40
                        }
                    }

                    DesktopClock {
                        id: clock
                    }*/
                    
                }
                Widgets {
                }

                /* ===============================
                VIDRIO CONTENEDOR MÓVIL
                =============================== */
                /*
                Item {
                    id: glassContainer
                    width: glass.width
                    height: glass.height
                    x: posX
                    y: posY
                    z: 20

                    property real posX: (parent.width - width) / 2
                    property real posY: (parent.height - height) / 2

                    Behavior on posX {
                        SpringAnimation { spring: 5; damping: 0.4 }
                    }
                    Behavior on posY {
                        SpringAnimation { spring: 5; damping: 0.4 }
                    }

                    // (CAPTURA DEL FONDO)
                    GlassBackDrop {
                        id: backdropSource
                        sourceItem: scene
                        sourceX: glassContainer.x
                        sourceY: glassContainer.y
                        sourceW: glass.width
                        sourceH: glass.height
                        hideSource: true
                    }

                    //GLASS REAL
                    Rectangle {
                        id: glass
                        width: 300
                        height: 400
                        color: "transparent"

                        GlassBox {
                            id: box
                            anchors.fill: parent
                            radius: 28
                            source: backdropSource
                            color: '#00ffffff'
                        }

                        StyledText {
                            anchors.top: parent.top
                            anchors.topMargin: 50
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Hola Como vas"
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.OpenHandCursor

                            property point clickOffset

                            onPressed: (mouse) => {
                                cursorShape = Qt.ClosedHandCursor
                                clickOffset = Qt.point(mouse.x, mouse.y)
                            }

                            onReleased: {
                                cursorShape = Qt.OpenHandCursor
                            }

                            onPositionChanged: (mouse) => {
                                if (!pressed) return
                                glassContainer.posX += mouse.x - clickOffset.x
                                glassContainer.posY += mouse.y - clickOffset.y
                            }
                        }
                    }
                }*/
            }
        }
    }
}
