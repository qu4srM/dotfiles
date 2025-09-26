import qs
import qs.configs
import qs.utils 
import qs.widgets
import qs.services

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

Rectangle {
    color: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
    radius: Appearance.rounding.normal
    MouseArea {
        id: popupMouseAreaTop
        anchors.fill: parent
        anchors.margins: 10
        hoverEnabled: true
        propagateComposedEvents: true
        Keys.onReturnPressed: {
            dialog.addTask()
        }

        Keys.onEnterPressed: {
            dialog.addTask()
        }
        Flickable {
            anchors.fill: parent 
            anchors.bottomMargin: row.implicitHeight + 10
            contentHeight: columnLayout.height
            clip: true
            ColumnLayout {
                id: columnLayout
                width: parent.width
                spacing: 10
                Repeater {
                    model: ScriptModel {
                        values: taskList
                    }
                    delegate: Rectangle {
                        id: todoItem
                        implicitWidth: parent.width
                        implicitHeight: text.implicitHeight + 40
                        radius: 10
                        color: Config.options.bar.showBackground 
                            ? pendingDoneToggle ? Appearance.colors.colprimary : Appearance.colors.colSurfaceContainerHigh
                            : pendingDoneToggle ? Colors.setTransparency(Appearance.colors.colglassmorphism, 0.7) : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                        property bool pendingDoneToggle: false
                        property bool pendingDelete: false
                        property bool enableHeightAnimation: false

                        Behavior on implicitHeight {
                            enabled: enableHeightAnimation
                            NumberAnimation {
                                duration: 400
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
                            }
                        }

                        function startAction() {
                            enableHeightAnimation = true
                            todoItem.implicitHeight = 0
                            actionTimer.start()
                        }
                        Timer {
                            id: actionTimer
                            interval: Appearance.animation.elementMoveFast.duration
                            repeat: false
                            onTriggered: {
                                if (todoItem.pendingDelete) {
                                    Todo.deleteItem(modelData.originalIndex)
                                } else if (todoItem.pendingDoneToggle) {
                                    if (!modelData.done) Todo.markDone(modelData.originalIndex)
                                    else Todo.markUnfinished(modelData.originalIndex)
                                }
                            }
                        }


                        ActionButtonIcon {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.margins: 10
                            colBackground: Config.options.bar.showBackground 
                                        ? Appearance.colors.colPrimary
                                        : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                            colBackgroundHover: Config.options.bar.showBackground 
                                                ? Appearance.colors.colPrimaryHover 
                                                : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                            iconMaterial: "check"
                            materialIconFill: true
                            iconSize: 20
                            changeColor: true
                            iconColor: Appearance.colors.colOnPrimary
                            implicitWidth: 30
                            implicitHeight: 30
                            buttonRadius: Appearance.rounding.full
                            onClicked: {
                                todoItem.pendingDoneToggle = true
                                todoItem.startAction()
                            }
                            StyledToolTip {
                                content: Translation.tr("Done")
                            }
                        }
                        Rectangle {
                            anchors.fill: parent 
                            anchors.margins: 50
                            color: "transparent"
                            MouseArea {
                                anchors.fill: parent 
                                hoverEnabled: true
                                propagateComposedEvents: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    //Qt.application.clipboard.setText("Texto copiado al portapapeles")
                                    //console.log("Copiado ✔")
                                    Quickshell.execDetached(["bash", "-c", `wl-copy "${text.text}`])
                                }
                                StyledText {
                                    id: text
                                    anchors.fill: parent 
                                    text: modelData.content
                                    wrapMode: Text.Wrap
                                }
                            }
                        }

                        ActionButtonIcon {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.margins: 10
                            colBackground: Config.options.bar.showBackground 
                                        ? Appearance.colors.colPrimary
                                        : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                            colBackgroundHover: Config.options.bar.showBackground 
                                                ? Appearance.colors.colPrimaryHover 
                                                : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                            iconMaterial: "delete"
                            materialIconFill: true
                            iconSize: 20
                            changeColor: true
                            iconColor: Appearance.colors.colOnPrimary
                            implicitWidth: 30
                            implicitHeight: 30
                            buttonRadius: Appearance.rounding.full
                            onClicked: {
                                todoItem.pendingDelete = true
                                todoItem.startAction()
                            }

                            StyledToolTip {
                                content: Translation.tr("Delete")
                            }
                        }
                    }
                }

            }
        }
        Item { // placeholder 
            visible: taskList.length === 0 ? true : false
            opacity: visible ? 1 : 0
            anchors.fill: parent
            Behavior on opacity {
                animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
            }

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 10
                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    font.pixelSize: Appearance.font.pixelSize.normal
                    color: Appearance.colors.colOutline
                    horizontalAlignment: Text.AlignHCenter
                    text: Translation.tr("Empty")
                }
            }
        }
        
        Item {
            id: dialog 
            anchors.bottom: parent.bottom
            implicitWidth: parent.width
            implicitHeight: row.implicitHeight

            function addTask () {
                if (input.text.length > 0) {
                    Todo.addTask(input.text)
                    input.text = ""
                    //root.showAddDialog = false
                    //root.currentTab = 0 // Show unfinished tasks
                }
            }

        
            RowLayout {
                id: row
                anchors.fill: parent
                spacing: 6
                Item {
                    id: inputContainer
                    Layout.fillWidth: true
                    implicitHeight: 40
                    TextField {
                        id: input
                        anchors.fill: parent
                        renderType: Text.NativeRendering
                        background: Rectangle {
                            anchors.fill: parent 
                            color: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainerHighest : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                            radius: Appearance.rounding.verysmall
                            border.width: input.activeFocus ? 1 : 0
                            border.color: Appearance.colors.colPrimary
                        }
                        color: Appearance.colors.colInverseSurface
                        placeholderText: Translation.tr("Task description")
                        placeholderTextColor: Appearance.colors.colOutline
                        
                        cursorDelegate: Rectangle {
                            width: 3
                            color: input.activeFocus ? Appearance.colors.colPrimary : "transparent"
                            radius: 1
                        }
                    }
                }
                ActionButtonIcon {
                    colBackground: Config.options.bar.showBackground ? Appearance.colors.colOnSurface : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                    colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colOnSurfaceVariant : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                    iconMaterial: "add"
                    materialIconFill: true
                    changeColor: true 
                    iconColor: Appearance.colors.colOnTertiary
                    iconSize: 26
                    implicitWidth: 40
                    implicitHeight: 40
                    buttonRadius: Appearance.rounding.normal
                    onClicked: {
                        dialog.addTask()
                    }
                    StyledToolTip {
                        content: Translation.tr("Add")
                    }
                }
            }
        }

        onExited: {
            if (!popupMouseAreaTop.containsMouse) {
                //root.onUnhovered()
            }
        }
    }
    Behavior on implicitHeight {
        NumberAnimation {
            duration: Appearance.animation.elementMove.duration
            easing.type: Appearance.animation.elementMove.type
                easing.bezierCurve: Appearance.animation.elementMove.bezierCurve
        }
    }
}