import qs 
import qs.modules.sticks
import qs.configs
import qs.widgets 
import qs.utils
import qs.services

import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets

Scope {
    id: root

    property bool visibleText: false

    function trigger() {
        root.visibleText = true
        osdTimeout.restart();
    }

    Timer {
        id: osdTimeout
        interval: 3000
        repeat: false
        onTriggered: () => {root.visibleText = false}
    }
    Connections {
        target: GlobalStates
        function onsticksOpenChanged() {
            root.trigger();
        }
    }

    Variants {
        model: Quickshell.screens

        LazyLoader {
            id: stickLoader 
            active: GlobalStates.sticksOpen
            required property ShellScreen modelData 

            component: StyledWindow {
                id: stick
                screen: stickLoader.modelData
                name: "stickyNotes"
                color: "transparent"

                property bool anyNoteFocused: false
                exclusiveZone: 0
                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.exclusionMode: ExclusionMode.Ignore
                WlrLayershell.keyboardFocus: stick.anyNoteFocused ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

                anchors {
                    top: true 
                    left: true 
                    right: true
                    bottom: true 
                }
                margins {
                    top: Appearance.sizes.barHeight
                }

                mask: Region {
                    x: 0
                    y: 0
                    width: stick.width
                    height: stick.height
                    intersection: Intersection.Xor
                    regions: regions.instances
                }

                Variants {
                    id: regions
                    model: {
                        notesContainer.children
                    }

                    Region {
                        required property Item modelData

                        x: modelData ? modelData.x : 0
                        y: modelData ? modelData.y : 0
                        width: modelData ? modelData.width : 0
                        height: modelData ? modelData.height : 0

                        intersection: Intersection.Subtract
                    }
                }

                StyledText {
                    anchors.centerIn: parent 
                    text: root.visibleText ? "Sticks Notes, Click Izquierdo sobre el + para agregar una nueva" : "Ocultando"
                    visible: root.visibleText ? 1 : 0
                    font.pixelSize: 30
                }
                Item {
                    id: sticks
                    anchors.fill: parent
                    property int topZ: 1
                    IpcHandler {
                        target: "notes"

                        function addNote(): void {
                            sticks.addNewNote()
                        }
                    }
                    Component.onCompleted: {
                        //StickyNotes.setWorkspace(Hyprland.activeWorkspace.id)
                        //Default Note
                        sticks.loadNotes()
                    }

                    Connections {
                        target: Hyprland
                        function onActiveWorkspaceChanged() {
                            //StickyNotes.setWorkspace(Hyprland.activeWorkspace.id)
                            sticks.loadNotes()
                        }
                    }

                    Item {
                        id: notesContainer
                        anchors.fill: parent
                    }

                    function loadNotes() {
                        destroyAll()
                        const notes = StickyNotes.notesForCurrentWorkspace()

                        for (let i = 0; i < notes.length; i++) {
                            noteComponent.createObject(notesContainer, {
                                x: notes[i].x,
                                y: notes[i].y,
                                noteCategory: notes[i].category,
                                noteText: notes[i].text,
                                noteColor: notes[i].color,
                                noteIndex: i,
                                z: topZ++
                            })
                        }
                    }

                    function destroyAll() {
                        for (let i = notesContainer.children.length - 1; i >= 0; i--)
                            notesContainer.children[i].destroy()
                    }

                    function addNewNote() {
                        const note = {
                            x: Math.floor(Math.random() * sticks.width - 200) + 100,
                            y: Math.floor(Math.random() * sticks.height - 200) + 100,
                            category: "Work",
                            text: "Nueva nota",
                            color: "#b3b3b3"
                        }

                        StickyNotes.addNote(note)
                        loadNotes()
                    }
                    Component {
                        id: noteComponent

                        Note {
                            id: note
                            item: sticks 
                            onFocused: ()=> {
                                if (stick.anyNoteFocused) {
                                    stick.anyNoteFocused = false
                                } else {
                                    stick.anyNoteFocused = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
