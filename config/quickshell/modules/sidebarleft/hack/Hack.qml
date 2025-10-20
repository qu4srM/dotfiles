import qs
import qs.configs
import qs.modules.sidebarleft
import qs.modules.sidebarleft.study
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

Item {
    id: root

    function addTarget() {
        Config.options.hacking.targetIp = input.text 
        input.text = ""
        HackingData.getOs()
    }
    ColumnLayout {
        width: parent.width
        spacing: 10 
        ActionButton {
            Layout.fillWidth: true
            implicitHeight: 60
            colBackground: Appearance.colors.colSurfaceContainer
            colBackgroundHover: Appearance.colors.colPrimaryHover
            buttonText: Translation.tr("Start VPN")
            buttonRadius: Appearance.rounding.full
            releaseAction: () => HackingData.getOs()
        }
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 120
            color: Config.options.bar.showBackground 
                ? Appearance.colors.colSurfaceContainer 
                : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
            radius: Appearance.rounding.normal
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 5
                StyledText {
                    text: Translation.tr("Create folder") 
                }
                StyledText {
                    text: Translation.tr("Format") + ": monitorstwo-htb"
                }
                RowLayout {
                    width: parent.width
                    spacing: 10
                    TextField {
                        id: inputFolder
                        Layout.fillWidth: true
                        implicitHeight: 40
                        renderType: Text.NativeRendering
                        background: Rectangle {
                            anchors.fill: parent 
                            color: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainerHighest : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                            radius: Appearance.rounding.verysmall
                            border.width: inputFolder.activeFocus ? 1 : 0
                            border.color: Appearance.colors.colPrimary
                        }
                        color: Appearance.colors.colInverseSurface
                        placeholderText: Translation.tr("Folder name")
                        placeholderTextColor: Appearance.colors.colOutline
                        
                        cursorDelegate: Rectangle {
                            width: 3
                            color: inputFolder.activeFocus ? Appearance.colors.colPrimary : "transparent"
                            radius: 1
                        }
                    }
                    ActionButtonIcon {
                        colBackground: Config.options.bar.showBackground ? Appearance.colors.colOnSurface : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                        colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colOnSurfaceVariant : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                        iconMaterial: "create_new_folder"
                        materialIconFill: true
                        changeColor: true 
                        iconColor: Appearance.colors.colOnTertiary
                        iconSize: 26
                        implicitWidth: 40
                        implicitHeight: 40
                        buttonRadius: Appearance.rounding.normal
                        onClicked: {
                            Config.options.hacking.folder = inputFolder.text
                            inputFolder.text = ""
                            HackingData.createFolders()
                        }
                        StyledToolTip {
                            content: Translation.tr("Create folder")
                        }
                    }
                }
            }
        }
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 90
            color: Config.options.bar.showBackground 
                ? Appearance.colors.colSurfaceContainer 
                : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
            radius: Appearance.rounding.normal
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 5
                RowLayout {
                    width: parent.width
                    spacing: 10
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
                            placeholderText: Translation.tr("Target Ip")
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
                        iconMaterial: "target"
                        materialIconFill: true
                        changeColor: true 
                        iconColor: Appearance.colors.colOnTertiary
                        iconSize: 26
                        implicitWidth: 40
                        implicitHeight: 40
                        buttonRadius: Appearance.rounding.normal
                        onClicked: {
                            root.addTarget()
                        }
                        StyledToolTip {
                            content: Translation.tr("Add")
                        }
                    }
                }
                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    text: Config.options.hacking.targetIp + " " + Translation.tr("is") + " " + HackingData.os
                }
            }

        }
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 100
            color: Config.options.bar.showBackground 
                ? Appearance.colors.colSurfaceContainer 
                : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
            radius: Appearance.rounding.normal
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 5
                StyledText {
                    text: Translation.tr("Submit") + " User Flag"
                }
                RowLayout {
                    width: parent.width
                    spacing: 10
                    TextField {
                        id: inputUserFlag
                        Layout.fillWidth: true
                        implicitHeight: 40
                        renderType: Text.NativeRendering
                        background: Rectangle {
                            anchors.fill: parent 
                            color: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainerHighest : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                            radius: Appearance.rounding.verysmall
                            border.width: inputUserFlag.activeFocus ? 1 : 0
                            border.color: Appearance.colors.colPrimary
                        }
                        color: Appearance.colors.colInverseSurface
                        placeholderText: Translation.tr("User Flag")
                        placeholderTextColor: Appearance.colors.colOutline
                        
                        cursorDelegate: Rectangle {
                            width: 3
                            color: inputUserFlag.activeFocus ? Appearance.colors.colPrimary : "transparent"
                            radius: 1
                        }
                    }
                    ActionButtonIcon {
                        colBackground: Config.options.bar.showBackground ? Appearance.colors.colOnSurface : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                        colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colOnSurfaceVariant : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                        iconMaterial: "person"
                        materialIconFill: true
                        changeColor: true 
                        iconColor: Appearance.colors.colOnTertiary
                        iconSize: 26
                        implicitWidth: 40
                        implicitHeight: 40
                        buttonRadius: Appearance.rounding.normal
                        onClicked: {
                            HackingData.submitUserFlag(inputUserFlag.text)
                            inputUserFlag.text = ""
                        }
                        StyledToolTip {
                            content: Translation.tr("Submit")
                        }
                    }
                }
            }
        }
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 100
            color: Config.options.bar.showBackground 
                ? Appearance.colors.colSurfaceContainer 
                : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
            radius: Appearance.rounding.normal
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 5
                StyledText {
                    text: Translation.tr("Submit") + " Root Flag"
                }
                RowLayout {
                    width: parent.width
                    spacing: 10
                    TextField {
                        id: inputRootFlag
                        Layout.fillWidth: true
                        implicitHeight: 40
                        renderType: Text.NativeRendering
                        background: Rectangle {
                            anchors.fill: parent 
                            color: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainerHighest : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                            radius: Appearance.rounding.verysmall
                            border.width: inputRootFlag.activeFocus ? 1 : 0
                            border.color: Appearance.colors.colPrimary
                        }
                        color: Appearance.colors.colInverseSurface
                        placeholderText: Translation.tr("User Flag")
                        placeholderTextColor: Appearance.colors.colOutline
                        
                        cursorDelegate: Rectangle {
                            width: 3
                            color: inputRootFlag.activeFocus ? Appearance.colors.colPrimary : "transparent"
                            radius: 1
                        }
                    }
                    ActionButtonIcon {
                        colBackground: Config.options.bar.showBackground ? Appearance.colors.colOnSurface : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                        colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colOnSurfaceVariant : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                        iconMaterial: "supervisor_account"
                        materialIconFill: true
                        changeColor: true 
                        iconColor: Appearance.colors.colOnTertiary
                        iconSize: 26
                        implicitWidth: 40
                        implicitHeight: 40
                        buttonRadius: Appearance.rounding.normal
                        onClicked: {
                            HackingData.submitUserFlag(inputUserFlag.text)
                            inputUserFlag.text = ""
                        }
                        StyledToolTip {
                            content: Translation.tr("Submit")
                        }
                    }
                }
            }
        }

    }
}
