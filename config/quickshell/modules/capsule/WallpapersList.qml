import qs
import qs.configs
import qs.widgets 
import qs.utils 
import qs.services

import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

Item {
    id: root 
    width: grid.implicitWidth
    height: grid.implicitHeight
    focus: true

    // 🔥 Fuerza foco cuando aparece (StackLayout fix)
    Component.onCompleted: grid.forceActiveFocus()
    onVisibleChanged: if (visible) grid.forceActiveFocus()

    GridView {
        id: grid
        verticalLayoutDirection: GridView.TopToBottom

        implicitWidth: cellWidth * 7
        implicitHeight: 4 + cellHeight * 3

        cellWidth: 90
        cellHeight: 70

        snapMode: GridView.SnapToRow
        clip: true
        cacheBuffer: 200

        keyNavigationEnabled: true   // lo manejamos manualmente
        keyNavigationWraps: true

        currentIndex: count > 0 ? 0 : -1

        topMargin: 7
        bottomMargin: grid.count === 0 ? 0 : 7

        highlight: Rectangle {
            width: grid.cellWidth
            height: grid.cellHeight
            color: "transparent"
        }

        highlightFollowsCurrentItem: true
        highlightMoveDuration: 100
        preferredHighlightBegin: grid.topMargin
        preferredHighlightEnd: grid.height - grid.bottomMargin
        highlightRangeMode: GridView.ApplyRange

        ScrollBar.vertical: ScrollBar {}

        model: Wallpapers.allWallpapers.map(v => v.path)
        Keys.onPressed: (event) => {
            if ((event.key === Qt.Key_Return || event.key === Qt.Key_Enter)
                && grid.currentItem) {

                grid.currentItem.select()
                event.accepted = true
            }
        }


        delegate: MouseArea {
            id: wallpaperItem
            required property var modelData
            required property int index

            hoverEnabled: true
            implicitWidth: grid.cellWidth
            implicitHeight: grid.cellHeight

            onClicked: select()

            function select() {
                const path = Paths.expandTilde(modelData)
                const pathFile = Paths.strip(path)

                Config.options.background.wallpaperPath = pathFile
                console.log("Change Background:", pathFile)

                Wallpapers.updateMaterialColor()
            }

            Rectangle {
                anchors.fill: parent 
                radius: Appearance.rounding.unsharpenmore + 4
                color: "transparent"

                border.width: Config.options.bar.showBackground
                               ? 0
                               : (grid.currentIndex === index ? 2 : 0)

                border.color: Colors.setTransparency(
                                  Appearance.colors.colglassmorphism, 0.8)

                Behavior on border.width {
                    NumberAnimation { duration: 120 }
                }
            }
            ColumnLayout {
                anchors.fill: parent 
                spacing: 0
                ClippingRectangle {
                    id: clip
                    Layout.fillWidth: true 
                    Layout.fillHeight: true 
                    Layout.margins: 4
                    radius: Appearance.rounding.unsharpenmore

                    Image {
                        anchors.fill: parent
                        source: Paths.expandTilde(modelData)
                        asynchronous: true
                        fillMode: Image.PreserveAspectCrop
                        sourceSize.width: width
                        sourceSize.height: height
                    }
                }
                Rectangle {
                    visible: Paths.strip(modelData) == Wallpapers.actualCurrent
                    Layout.fillWidth: true 
                    implicitHeight: 10
                    Layout.bottomMargin: 4
                    color: "transparent"
                    StyledText {
                        anchors.centerIn: parent
                        text: "CURRENT"
                        color: '#464646'
                        font.pixelSize: 12
                    }
                }
            }

            
        }



        add: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 100 }
        }

        displaced: Transition {
            NumberAnimation { property: "y"; duration: 200; easing.type: Easing.OutCubic }
            NumberAnimation { property: "opacity"; to: 1; duration: 100 }
        }

        move: Transition {
            NumberAnimation { property: "y"; duration: 200; easing.type: Easing.OutCubic }
            NumberAnimation { property: "opacity"; to: 1; duration: 100 }
        }

        remove: Transition {
            NumberAnimation { property: "y"; duration: 200; easing.type: Easing.OutCubic }
            NumberAnimation { property: "opacity"; to: 0; duration: 100 }
        }
    }
}
