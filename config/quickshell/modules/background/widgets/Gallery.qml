import qs
import qs.configs
import qs.widgets
import qs.utils
import qs.services

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

Rectangle {
    id: root

    radius: Appearance.rounding.normal
    color: Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)

    border.width: 1
    border.color: Colors.setTransparency("white", 0.9)

    property string galleryDir: Config.options.widgets.galleryPath
    property var images: []
    property int currentIndex: -1

    function loadImages() {
        getImagesProc.running = true
    }

    function randomIndex() {
        if (images.length === 0)
            return -1

        var i = Math.floor(Math.random() * images.length)

        if (i === currentIndex && images.length > 1)
            i = (i + 1) % images.length

        return i
    }

    function preloadNext() {
        var i = randomIndex()
        if (i < 0) return

        nextImage.source = images[i]
        nextImage.index = i
    }

    function swapImages() {
        if (nextImage.source === "")
            return

        currentIndex = nextImage.index

        fade.restart()
    }

    Component.onCompleted: startDelay.start() 
    Timer {
        id: startDelay
        interval: Config.options.widgets.delay
        repeat: false
        onTriggered: {
            root.loadImages()
        }
    }

    Process {
        id: getImagesProc
        command: [
            "bash",
            "-c",
            `find "${galleryDir}" -maxdepth 1 -type f -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp"`
        ]

        stdout: StdioCollector {
            id: imagesCollector
            onStreamFinished: {
                try {
                    let data = imagesCollector.text.trim().split("\n")
                    root.images = data.filter(p => p.length > 0)

                    console.log("Images loaded:", root.images.length)

                    root.preloadNext() 
                    currentImage.source = nextImage.source
                    root.preloadNext()

                } catch(e) {
                    console.log("Images error:", e)
                }
            }
        }
    }
    Timer {
        interval: 360000
        repeat: true
        running: true
        onTriggered: root.swapImages()
    }

    ClippingRectangle {
        anchors.fill: parent
        radius: parent.radius
        color: "transparent"

        Item {
            anchors.fill: parent

            Image {
                id: currentImage
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                smooth: true
                mipmap: true
            }

            Image {
                id: nextImage
                anchors.fill: parent
                opacity: 0
                property int index: -1
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                smooth: true
                mipmap: true
            }

            SequentialAnimation {
                id: fade

                NumberAnimation {
                    target: nextImage
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 900
                    easing.type: Easing.InOutQuad
                }

                ScriptAction {
                    script: {
                        currentImage.source = nextImage.source
                        nextImage.opacity = 0
                        root.preloadNext()
                    }
                }
            }
        }
    }
}