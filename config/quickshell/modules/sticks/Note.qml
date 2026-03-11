import qs 
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

Rectangle {
    id: root

    required property Item item
    
    property var onFocused

    property int noteIndex: -1
    property string noteCategory
    property string noteText: ""
    property bool editing: false
    property bool focused: false
    property bool showColorPicker: false

    property color noteColor: "#b3b3b3"

    width: 260
    height: editor.implicitHeight + buttons.implicitHeight + 20
    radius: Appearance.rounding.normal

    color: noteColor
    border.color: focused ? "#FFAA00" : "#E0C35A"
    border.width: focused ? 2 : 1

    /* BRING FRONT */
    MouseArea {
        anchors.fill: parent
        onPressed: root.z = item.topZ++
        onDoubleClicked: {
            root.editing = true
            root.focused = true
            editor.forceActiveFocus()
            root.onFocused()
            
        }
        propagateComposedEvents: true
    }

    DragHandler {
        target: root
        onActiveChanged: if (!active) save()
    }

    function save() {
        StickyNotes.updateNote(noteIndex, {
            x: root.x,
            y: root.y,
            category: root.noteCategory,
            text: root.noteText,
            color: root.noteColor
        })
    }
    ColumnLayout {
        width: parent.width
        spacing: 10
        Rectangle {
            id: buttons
            Layout.fillWidth: true 
            implicitHeight: 30
            color: Qt.darker(root.color, 1.2)
            radius: Appearance.rounding.normal
            z: 10
            StyledText {
                anchors.left: parent.left 
                anchors.margins: 10  
                anchors.verticalCenter: parent.verticalCenter
                text: StickyNotes.categoryNameFromColor(root.noteColor)
                font.pixelSize: 16
                color: "#333"
            }

            Rectangle {
                id: btnDelete
                width: 16
                height: 16
                radius: 8
                color: "#ff5555"
                anchors.right: parent.right
                anchors.margins: 8
                anchors.verticalCenter: parent.verticalCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        StickyNotes.deleteNote(root.noteIndex)
                        item.loadNotes()
                    }
                }
            }
            /* COLOR PICKER BUTTON */
            Rectangle {
                id: colorButton
                width: 18
                height: 18
                radius: 9
                color: root.noteColor
                border.color: "#444"
                border.width: 1

                anchors.right: btnDelete.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 8

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.showColorPicker = !root.showColorPicker
                    }
                }
            }
            /* COLOR PICKER PANEL */
            Rectangle {
                visible: root.showColorPicker
                width: 80
                height: 46
                radius: 10
                color: "#ffffff"
                border.color: "#cccccc"
                border.width: 1
                z: 999

                anchors.top: parent.top
                anchors.right: colorButton.left
                anchors.margins: 6

                GridLayout {
                    anchors.fill: parent
                    anchors.margins: 4
                    columns: 4
                    rowSpacing: 2
                    columnSpacing: 2

                    Repeater {
                        model: StickyNotes.categoryColors

                        delegate: Rectangle {
                            width: 16
                            height: 16
                            radius: 999
                            color: modelData
                            border.color: "#555"
                            border.width: root.noteColor === modelData ? 2 : 1

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    root.noteColor = modelData
                                    root.showColorPicker = false
                                    root.save()
                                }
                            }
                        }
                    }
                }
            }
            Rectangle {
                id: saveButton
                width: 40
                height: 18
                color: "green"

                anchors.right: colorButton.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 8
                StyledText {
                    anchors.centerIn: parent
                    text: "Save"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.editing = false
                        root.focused = false
                        focus = false
                        root.save()
                    }
                }
            }
        }
        TextEdit {
            id: editor
            Layout.fillWidth: true 
            Layout.fillHeight: true 
            Layout.topMargin: 0
            Layout.margins: 16
            text: root.noteText
            wrapMode: TextEdit.Wrap
            font.pixelSize: 16
            color: "#333"

            focus: root.editing
            onTextChanged: root.noteText = text

            Keys.onPressed: (event) => {
                if (event.key === Qt.Key_Escape ||
                    event.key === Qt.Key_Return ||
                    event.key === Qt.Key_Enter) {

                    root.editing = false
                    root.focused = false
                    focus = false
                    event.accepted = true
                    root.save()
                }
            }

        }

    }
    
}