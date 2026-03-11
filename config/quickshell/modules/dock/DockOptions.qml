import qs 
import qs.configs 
import qs.widgets 
import qs.utils 
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
    required property Scope scope
    required property StyledWindow window
    property real widthC: container.implicitWidth
    property real heightC: container.implicitWidth

    implicitWidth: container.implicitWidth
    implicitHeight: container.implicitHeight
    color: "transparent"
    visible: Apps.visibleOptions
    Rectangle {
        id: container
        
        implicitWidth:  toolsLayout.implicitWidth + 14
        implicitHeight: toolsLayout.implicitHeight + 14
        color: Colors.setTransparency(Appearance.colors.colglassmorphism, 0.95)
        radius: Appearance.rounding.unsharpenmore
                
        RectangleRing {
            anchors.fill: parent 
            radius: parent.radius
            source: ShaderEffectSource {
                anchors.fill: parent 
                sourceRect: Qt.rect(0,0,200,400)
                hideSource: true
                live: true
                visible: true
            }
        }
        HoverHandler {
            id: popupHover
            enabled: scope.ready && !scope.pinned
            onHoveredChanged: {
                window.hovered = hovered 
                if (!window.hovered) {Apps.visibleOptions = false}
            }
        }
        ColumnLayout {
            id: toolsLayout
            anchors.centerIn: parent 
            RowLayout {
                Repeater {
                    model: Apps.lastClickApp.windows
                    delegate: ClippingRectangle {
                        id: windowPreview
                        required property var modelData
                        implicitWidth: view.implicitWidth + 60
                        implicitHeight: view.implicitHeight + 35
                        radius: Appearance.rounding.unsharpenmore
                        color: "transparent"
                        border.width: 1
                        border.color: modelData?.activated ? "white" : "transparent"
                        MouseArea {
                            anchors.fill: parent 
                            onClicked: Quickshell.execDetached(["bash", "-c", "hyprctl dispatch focuswindow address:" + `0x${windowPreview.modelData.HyprlandToplevel.address}`])
                        }
                        ScreencopyView {
                            id: view
                            anchors.fill: parent
                            constraintSize: Qt.size(90,70)
                            captureSource: windowPreview.modelData
                            live: Apps.visibleOptions

                            StyledText {
                                anchors.centerIn: parent 
                                text: HyprlandData.windowByAddress[`0x${windowPreview.modelData.HyprlandToplevel.address}`].workspace.id
                            }
                        }
                        Rectangle {
                            anchors.top: parent.top 
                            anchors.right: parent.right
                            anchors.margins: 4
                            width: 16
                            height: 16 
                            color: "red"
                            radius: Appearance.rounding.full 
                            MouseArea {
                                anchors.fill: parent 
                                onClicked: () => {
                                    modelData.close()
                                    visibleOptions = false
                                }
                            }
                            StyledText {
                                anchors.centerIn: parent 
                                text: "x"
                                color: "white"
                            }
                        }
                    }
                }
            }
            Repeater {
                model: Object.keys(Apps.options)
                delegate: ActionButton {
                    Layout.fillWidth: true
                    colBackground: "transparent"
                    colBackgroundHover: Appearance.colors.colPrimary
                    buttonRadius: Appearance.rounding.unsharpenmore
                    
                    contentItem: StyledText {
                        color: "black"
                        text: modelData
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: {
                        Apps.options[modelData].execute()
                    }
                }
            }
        }

    }
}