import qs
import qs.modules.background
import qs.configs
import qs.widgets
import qs.configs.utils
import qs.services

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Services.Notifications



Variants {
    id: root 
    model: Quickshell.screens
    StyledWindow {
        id: background
        required property var modelData
        
        screen: modelData
        name: "background"
        WlrLayershell.layer: GlobalStates.screenLock ? WlrLayer.Top : WlrLayer.Bottom
        color: "#000000"
        exclusionMode: ExclusionMode.Ignore

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        property string wallpaperPath: Config.options.background.wallpaperPath
        property real wallpaperEffectiveScale: 1
        property int wallpaperWidth: modelData.width
        property int wallpaperHeight: modelData.height
        property real scaledWallpaperWidth: wallpaperWidth * wallpaperEffectiveScale
        property real scaledWallpaperHeight: wallpaperHeight * wallpaperEffectiveScale
        
        onWallpaperPathChanged: {
            background.updateScale()
        }
        function updateScale() {
            getWallpaperSizeProc.path = background.wallpaperPath;
            getWallpaperSizeProc.running = true;
        }
        Process {
            id: getWallpaperSizeProc
            property string path: background.wallpaperPath
            command: ["magick", "identify", "-format", "%w %h", path]
            stdout: StdioCollector {
                id: wallpaperSizeOutputCollector
                onStreamFinished: {
                    const output = wallpaperSizeOutputCollector.text;
                    const [width, height] = output.split(" ").map(Number);
                    background.wallpaperWidth = width;
                    background.wallpaperHeight = height;
                    background.wallpaperEffectiveScale = Math.max(background.screen.width / width, background.screen.height / height);
                }
            }
        }

        Image {
            visible: opacity > 0
            opacity: (status === Image.Ready) ? 1 : 0
            asynchronous: true
            retainWhileLoading: true
            cache: false
            smooth: false
            
            source: Config.options.background.wallpaperPath
            fillMode: Image.PreserveAspectCrop
            sourceSize {
                width: background.scaledWallpaperWidth
                height: background.scaledWallpaperHeight
            }
            width: background.scaledWallpaperWidth
            height: background.scaledWallpaperHeight
            Behavior on opacity {
                NumberAnimation { duration: 300 }
            }
        }

        /*Item {
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
            }
            
        }*/
        ScreenCorner {
            anchors.topMargin: Appearance.sizes.barHeight
            visible: Config.options.bar.showBackground && !Config.options.bar.floating
            color: Appearance.colors.colBackground
            topLeftRadius: Appearance.rounding.normal
            topRightRadius: Appearance.rounding.normal
            bottomLeftRadius: 0
            bottomRightRadius: 0
        }
        Widgets {
            visible: opacity > 0
            opacity: GlobalStates.screenLock ? 0 : 1
        }
        NotificationPopup {
            x: parent.width - 310
            y: Appearance.sizes.barHeight
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

