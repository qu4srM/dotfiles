import qs
import qs.configs
import qs.widgets
import qs.utils

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        StyledWindow {
            id: launcher
            required property var modelData
            visible: GlobalStates.launcherOpen
            screen: modelData
            name: "launcher"
            color: "transparent"

            property string pathIcons: "root:/assets/icons/"
            property string colorMain: "transparent"
            property string pathScripts: "~/.config/quickshell/scripts/"

            WlrLayershell.layer: WlrLayer.Overlay
            implicitHeight: grid.implicitHeight + 100
            implicitWidth: grid.implicitWidth + 50

            function hide() {
                GlobalStates.launcherOpen = false
            }

            onVisibleChanged: {
                if (visible) search.forceActiveFocus()
            }

            HyprlandFocusGrab {
                id: grab
                windows: [ launcher ]
                active: GlobalStates.launcherOpen
                onCleared: {
                    if (!active) launcher.hide()
                }
            }

            StyledRectangularShadow {
                visible: Config.options.bar.showBackground ? Config.options.appearance.shape ? false : true : false
                target: content
            }

            Rectangle {
                id: content
                anchors.fill: parent
                anchors.margins: 10
                color: Config.options.bar.showBackground ? Config.options.appearance.shape ? "transparent" : Appearance.colors.colbackground : Config.options.appearance.shape ? "transparent" : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                radius: 10
                border.width: Config.options.bar.showBackground ? 0 : 1
                border.color: Colors.setTransparency(Appearance.colors.colglassmorphism, 0.7)

                ColumnLayout {
                    id: columnLayout
                    anchors.fill: parent
                    spacing: 0

                    Rectangle {
                        id: searchContainer
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: parent.width - 30
                        Layout.preferredHeight: searchbox.implicitHeight
                        Layout.topMargin: 20
                        color: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainerHighest : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                        radius: 4

                        Row {
                            id: searchbox
                            anchors.fill: parent
                            anchors.leftMargin: 10

                            StyledMaterialSymbol {
                                anchors.verticalCenter: parent.verticalCenter
                                text: "search"
                                font.pixelSize: 20
                                color: Config.options.bar.showBackground ? Appearance.colors.colprimarytext : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.7)
                            }

                            TextField {
                                id: search
                                Layout.fillWidth: true
                                color: Config.options.bar.showBackground ? Appearance.colors.colprimarytext : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.7)
                                placeholderText: "Applications"
                                focus: launcher.visible
                                background: Rectangle {
                                    anchors.fill: parent
                                    color: "transparent"
                                }

                                Keys.onEscapePressed: launcher.hide()

                                Keys.onPressed: (event) => {
                                    const cols = Math.max(1, Math.floor(grid.width / grid.cellWidth))
                                    if (event.modifiers & Qt.ControlModifier) {
                                        if (event.key === Qt.Key_J) {
                                            grid.currentIndex = (grid.currentIndex + 1) % grid.count
                                            event.accepted = true
                                            return
                                        } else if (event.key === Qt.Key_K) {
                                            grid.currentIndex = (grid.currentIndex - 1 + grid.count) % grid.count
                                            event.accepted = true
                                            return
                                        }
                                    }

                                    switch (event.key) {
                                    case Qt.Key_Right:
                                        grid.currentIndex = (grid.currentIndex + 1) % grid.count
                                        event.accepted = true
                                        break
                                    case Qt.Key_Left:
                                        grid.currentIndex = (grid.currentIndex - 1 + grid.count) % grid.count
                                        event.accepted = true
                                        break
                                    case Qt.Key_Down:
                                        grid.currentIndex = (grid.currentIndex + cols) % grid.count
                                        event.accepted = true
                                        break
                                    case Qt.Key_Up:
                                        grid.currentIndex = (grid.currentIndex - cols + grid.count) % grid.count
                                        event.accepted = true
                                        break
                                    }
                                }

                                onAccepted: {
                                    if (grid.currentItem?.modelData)
                                        grid.currentItem.modelData.execute()
                                    text = ""
                                }

                                onTextChanged: grid.currentIndex = 0
                            }
                        }
                    }

                    GridView {
                        id: grid
                        Layout.alignment: Qt.AlignHCenter
                        implicitWidth: cellWidth * 5
                        implicitHeight: cellHeight * 4 + 10
                        keyNavigationWraps: true
                        keyNavigationEnabled: true
                        cellWidth: 80
                        cellHeight: 80
                        snapMode: GridView.SnapToRow
                        clip: true
                        cacheBuffer: 0
                        currentIndex: 0
                        topMargin: 7
                        bottomMargin: grid.count == 0 ? 0 : 7

                        highlight: Rectangle {
                            width: grid.cellWidth
                            height: grid.cellHeight
                            radius: 8
                            color: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainerHighest : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                        }

                        highlightFollowsCurrentItem: true
                        highlightMoveDuration: 100
                        preferredHighlightBegin: grid.topMargin
                        preferredHighlightEnd: grid.height - grid.bottomMargin
                        highlightRangeMode: GridView.ApplyRange

                        delegate: MouseArea {
                            id: appItem
                            required property DesktopEntry modelData
                            property string shape: Config.options.appearance.shape
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            implicitWidth: grid.cellWidth
                            implicitHeight: grid.cellHeight

                            onClicked: {
                                modelData.execute()
                                launcher.hide()
                            }
                            Item {
                                id: shapes
                                anchors.top: parent.top
                                anchors.topMargin: 2
                                anchors.horizontalCenter: parent.horizontalCenter
                                implicitWidth: iconImage.width + 12
                                implicitHeight: iconImage.height + 12
                                Loader {
                                    anchors.fill: parent
                                    active: appItem.shape === "circle" ? true : false
                                    sourceComponent: Rectangle {
                                        anchors.fill: parent 
                                        color: Appearance.colors.colPrimary
                                        radius: Appearance.rounding.full
                                    }
                                }
                                Loader {
                                    anchors.fill: parent
                                    active: appItem.shape === "square" ? true : false
                                    sourceComponent: Rectangle {
                                        anchors.fill: parent 
                                        color: Appearance.colors.colPrimary
                                        radius: Appearance.rounding.normal
                                    }
                                }
                                Loader {
                                    anchors.fill: parent
                                    active: appItem.shape === "4sidedcookie" ? true : false
                                    sourceComponent: SidedCookieShape {
                                        sides: 4
                                        bulge: 0.2
                                    }
                                }
                                Loader {
                                    anchors.fill: parent
                                    active: appItem.shape === "7sidedcookie" ? true : false
                                    sourceComponent: SidedCookieShape {
                                        sides: 7
                                        bulge: 0.1
                                    }
                                }

                                Loader {
                                    anchors.fill: parent
                                    active: root.shape === "arch" ? true : false
                                    sourceComponent: Rectangle {
                                        anchors.fill: parent 
                                        color: Appearance.colors.palettes.primary.col60
                                        topLeftRadius: Appearance.rounding.full
                                        topRightRadius: Appearance.rounding.full
                                        bottomLeftRadius: Appearance.rounding.unsharpenmore
                                        bottomRightRadius: Appearance.rounding.unsharpenmore
                                    }
                                }
                            }

                            Column {
                                anchors.centerIn: parent
                                spacing: 6

                                IconImage {
                                    id: iconImage
                                    source: Quickshell.iconPath(modelData.icon)
                                    asynchronous: true
                                    width: 42
                                    height: 42
                                }

                                Text {
                                    text: modelData.name.length > 12 ? modelData.name.slice(0, 12) + "…" : modelData.name
                                    font.pixelSize: 12
                                    color: "#f0f0f0"
                                    horizontalAlignment: Text.AlignHCenter
                                    wrapMode: Text.NoWrap
                                    elide: Text.ElideRight
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    width: parent.width
                                }
                            }
                        }

                        model: ScriptModel {
                            values: { DesktopEntries.applications.values
                                .map(object => {
                                    const stxt = search.text.toLowerCase();
                                    const ntxt = object.name.toLowerCase();
                                    let ni = 0, matches = [], startMatch = -1;

                                    for (let si = 0; si < stxt.length; ++si) {
                                        const sc = stxt[si];
                                        while (true) {
                                            if (ni == ntxt.length) return null;
                                            const nc = ntxt[ni++];
                                            if (nc === sc) {
                                                if (startMatch === -1) startMatch = ni;
                                                break;
                                            } else if (startMatch !== -1) {
                                                matches.push({ index: startMatch, length: ni - startMatch });
                                                startMatch = -1;
                                            }
                                        }
                                    }

                                    if (startMatch !== -1)
                                        matches.push({ index: startMatch, length: ni - startMatch + 1 });

                                    return { object, matches };
                                })
                                .filter(entry => entry !== null)
                                .sort((a, b) => {
                                    let ai = 0, bi = 0, s = 0;
                                    while (ai < a.matches.length && bi < b.matches.length) {
                                        s = b.matches[bi].length - a.matches[ai].length;
                                        if (s !== 0) return s;
                                        s = a.matches[ai].index - b.matches[bi].index;
                                        if (s !== 0) return s;
                                        ai++; bi++;
                                    }
                                    s = a.matches.length - b.matches.length;
                                    if (s !== 0) return s;
                                    s = a.object.name.length - b.object.name.length;
                                    if (s !== 0) return s;
                                    return a.object.name.localeCompare(b.object.name);
                                })
                                .map(entry => entry.object);
                            }
                            onValuesChanged: grid.currentIndex = 0
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
            }
            
        }
    }

    GlobalShortcut {
        name: "launcherToggle"
        description: "Toggles launcher on press"
        onPressed: GlobalStates.launcherOpen = !GlobalStates.launcherOpen
    }
    GlobalShortcut {
        name: "launcherOpen"
        description: "Opens launcher on press"
        onPressed: GlobalStates.launcherOpen = true
    }
    GlobalShortcut {
        name: "launcherClose"
        description: "Closes launcher on press"
        onPressed: GlobalStates.launcherOpen = false
    }
}
