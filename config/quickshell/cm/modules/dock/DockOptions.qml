import qs 
import qs.configs 
import qs.configs.utils
import qs.widgets 
import qs.services 

import QtQuick 
import QtQuick.Layouts 
import QtQuick.Shapes
import Quickshell 
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Wayland


PopupWindow {
    id: root 
    required property var window

    implicitWidth: container.implicitWidth
    implicitHeight: container.implicitHeight
    color: "transparent"
    visible: Apps.visibleOptions && Apps.lastClickApp
    Rectangle {
        id: container
        
        implicitWidth:  toolsLayout.implicitWidth + toolsLayout.anchors.margins * 2
        implicitHeight: toolsLayout.implicitHeight + toolsLayout.anchors.margins * 2
        color: Appearance.colors.colGlass
        radius: Appearance.rounding.unsharpenmore
        border.width: 1
        border.color: Appearance.colors.colGlassBorder
                
        HoverHandler {
            id: popupHover
            enabled: root.visible
            onHoveredChanged: {
                window.hovered = hovered 
                if (!window.hovered) {Apps.visibleOptions = false}
            }
        }
        ColumnLayout {
            id: toolsLayout
            anchors.fill: parent
            anchors.margins: 4
            spacing: 2
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 4
                Repeater {
                    model: (Apps.visibleOptions && Apps.lastClickApp) ? Apps.lastClickApp.windows : []
                    delegate: Rectangle {
                        id: windowPreview
                        required property var modelData
                        implicitWidth: 200 
                        implicitHeight: 105
                        radius: Appearance.rounding.unsharpenmore
                        color: "#000000"
                        border.width: 1
                        border.color: "white"
                        MouseArea {
                            anchors.fill: parent 
                            onClicked: Quickshell.execDetached([
                                "hyprctl",
                                "eval",
                                `hl.dispatch(hl.dsp.focus({
                                    window = "address:0x${windowPreview.modelData.HyprlandToplevel.address}"
                                }))`
                            ])
                        }
                        ScreencopyView {
                            id: view
                            anchors.fill: parent
                            anchors.margins: 2
                            constraintSize: Qt.size(200, 105)
                            captureSource: windowPreview.modelData
                            live: root.visible
                        }
                        StyledText {
                            anchors.centerIn: parent 
                            text: HyprlandData.windowByAddress["0x" + windowPreview.modelData.HyprlandToplevel.address]?.workspace?.id || ""
                            color: "white"
                            font.bold: true
                            font.pixelSize: 24
                            style: Text.Outline
                            styleColor: "black"
                        }
                        Rectangle {
                            anchors.top: parent.top 
                            anchors.right: parent.right
                            anchors.margins: 6
                            width: 22; height: 22 
                            color: "#e64545"
                            radius: height / 2
                            
                            StyledText {
                                anchors.centerIn: parent 
                                text: "✕"
                                color: "white"
                                font.pixelSize: 12
                            }

                            MouseArea {
                                anchors.fill: parent 
                                onClicked: {
                                    modelData.close()
                                }
                            }
                        }
                    }
                }
            }
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "transparent"
                visible: Apps.options.length > 0
            }
            Repeater {
                model: Apps.options
                delegate: ActionButton {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 24
                    colBackground: "transparent"
                    colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colPrimary : Appearance.colors.colGlassHover
                    buttonRadius: Appearance.rounding.unsharpenmore
                    
                    contentItem: StyledText {
                        color: "white"
                        text: modelData.name
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: {
                        modelData.execute()
                    }
                }
            }
        }

    }
}