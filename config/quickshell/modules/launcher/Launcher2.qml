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
            implicitHeight: content.height
            implicitWidth: content.width

            function hide() {
                GlobalStates.launcherOpen = false
                grid.currentIndex = 0
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
                width: columnLayout.implicitWidth
                height: columnLayout.implicitHeight + 20
                color: Config.options.bar.showBackground ? Config.options.appearance.shape ? "transparent" : Appearance.colors.colbackground : Config.options.appearance.shape ? "transparent" : Colors.setTransparency('#222136', 0.3)
                radius: 20
                border.width: Config.options.bar.showBackground ? 0 : 2
                border.color: Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)

                ColumnLayout {
                    id: columnLayout
                    anchors.top: parent.top 
                    anchors.topMargin: 6
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 0

                    Rectangle {
                        id: searchContainer
                        Layout.fillWidth: true
                        Layout.leftMargin: 10
                        Layout.rightMargin: 10
                        height: searchbox.implicitHeight
                        color: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainerHighest : "transparent"
                        radius: 4
                        RowLayout {
                            id: searchbox
                            anchors.fill: parent
                            spacing: 0

                            StyledMaterialSymbol {
                                Layout.alignment: Qt.AlignVCenter
                                text: "search"
                                font.pixelSize: 26
                                color: Config.options.bar.showBackground ? Appearance.colors.colprimarytext : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.7)
                            }

                            TextField {
                                id: search
                                Layout.fillWidth: true
                                font.pixelSize: 18
                                color: Config.options.bar.showBackground ? Appearance.colors.colprimarytext : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.7)
                                placeholderText: Translation.tr("Apps")
                                placeholderTextColor: '#cacaca'
                                focus: true
                                background: Rectangle {
                                    anchors.fill: parent
                                    color: "transparent"
                                }

                                Keys.onEscapePressed: () => {
                                    launcher.hide()
                                    text = ""
                                }
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
                                        GlobalStates.launcherOpen = false
                                    text = ""
                                }

                                onTextChanged: grid.currentIndex = 0
                            }
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.leftMargin: 10
                        Layout.rightMargin: 10
                        height: 2
                        color: Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                    }
                    GridView {
                        id: grid
                        verticalLayoutDirection: GridView.TopToBottom
                        Layout.alignment: Qt.AlignHCenter
                        implicitWidth: cellWidth * Config.options.launcher.columnsApps
                        implicitHeight: cellHeight * Config.options.launcher.rowsApps
                        keyNavigationWraps: true
                        keyNavigationEnabled: true
                        cellWidth: 100
                        cellHeight: 84
                        snapMode: GridView.SnapToRow
                        clip: true
                        cacheBuffer: 0
                        currentIndex: 0
                        topMargin: 7
                        bottomMargin: grid.count == 0 ? 0 : 7

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

                        delegate: MouseArea {
                            id: appItem
                            required property DesktopEntry modelData
                            required property real index
                            hoverEnabled: true
                            implicitWidth: grid.cellWidth
                            implicitHeight: grid.cellHeight

                            onClicked: {
                                modelData.execute()
                                launcher.hide()
                            }
                            Rectangle {
                                anchors.top: parent.top
                                anchors.topMargin: 4
                                anchors.horizontalCenter: parent.horizontalCenter
                                implicitWidth: iconImage.width
                                implicitHeight: iconImage.height
                                radius: Appearance.rounding.small + 2
                                color: "transparent"
                                border.width: Config.options.bar.showBackground ? 0 : (grid.currentIndex === index) ? 2 : 0
                                border.color: Colors.setTransparency(Appearance.colors.colglassmorphism, 0.8)
                            }

                            Column {
                                anchors.centerIn: parent
                                spacing: 4

                                IconImage {
                                    id: iconImage
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    source: Quickshell.iconPath(modelData.icon)
                                    asynchronous: true
                                    width: 54
                                    height: 54
                                }

                                Text {
                                    text: modelData.name
                                    font.pixelSize: 13
                                    color: "#f0f0f0"

                                    width: grid.cellWidth - 12
                                    horizontalAlignment: Text.AlignHCenter

                                    wrapMode: Text.WordWrap
                                    elide: Text.ElideRight
                                    maximumLineCount: 1
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
