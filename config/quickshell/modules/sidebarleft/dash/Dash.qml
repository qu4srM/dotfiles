import qs
import qs.configs
import qs.modules.sidebarleft.dash
import "./calendarLayout.js" as CalendarLayout
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

    
    /*
    Item {
        id: start 
        anchors.top: parent.top
        implicitHeight: 240
        implicitWidth: root.implicitWidth
        
        RowLayout {
            spacing: 10

            Rect {
                width: 3 + columnSliders.implicitWidth * 3
                height: columnSliders.implicitHeight
                color: Appearance.colors.colsecondary
                radius: Appearance.rounding.small

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2
                    StyledText { text: "OS: Arch Linux"; font.pixelSize: 12 }
                    StyledText { text: "Terminal: Kitty"; font.pixelSize: 12 }
                    StyledText { text: "Uptime: 120 min"; font.pixelSize: 12 }
                }
            }
            ColumnLayout {
                id: columnSliders
                spacing: 10
                Rect {
                    width: root.implicitWidth / 4
                    height: 60
                    color: Appearance.colors.colsecondary
                    radius: Appearance.rounding.small

                    StyledText {
                        anchors.centerIn: parent
                        text: "10°"
                        font.pixelSize: 40
                    }
                }
                Rect {
                    width: root.implicitWidth / 4
                    height: 140
                    color: Appearance.colors.colsecondary
                    radius: Appearance.rounding.small

                    Row {
                        anchors.centerIn: parent 
                        spacing: 10 
                        ProgressBarV { implicitHeight: 100 }
                        ProgressBarV { implicitHeight: 100 }
                        ProgressBarV { implicitHeight: 100 }
                    }
                }
            }
            
        }
    }
    Rect {
        id: center
        anchors.top: start.bottom
        implicitHeight: 300
        implicitWidth: root.implicitWidth
        color: "black"
    }

    Rect {
        id: end
        anchors.top: center.bottom
        implicitWidth: root.implicitWidth
        implicitHeight: phrase.implicitHeight + phrase.anchors.margins * 2
        color: Appearance.colors.colsecondary
        radius: Appearance.rounding.small

        StyledText {
            id: phrase
            anchors.fill: parent
            anchors.margins: 8
            wrapMode: Text.Wrap
            text: "No permitas que tus miedos y debilidades te alejen de tus objetivos. Mantén tu corazón ardiendo. Recuerda que el tiempo no espera a nadie, no te hará compañía."
            color: "#ffffff"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
}*/ ColumnLayout {
        anchors.fill: parent 
        spacing: 10
        Rect {
            Layout.fillWidth: true
            implicitHeight: phrase.implicitHeight
            color: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
            Phrase{
                id: phrase
            }
        }
        Rect {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
            /*Pdf {
            }*/
            StyledText {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 10
                text: Translation.tr("Source: ") + NotionData.dataSourceTitle
            }
            StyledText {
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: 10
                text: Translation.tr("Database: ") + NotionData.dataTitle
            }
            ColumnLayout {
                anchors.top: parent.top
                anchors.left: parent.left 
                anchors.right: parent.right
                anchors.topMargin: 40
                anchors.margins: 10
        
                Repeater {
                    model: NotionData.data.pages || []
                    delegate: Rectangle {
                        Layout.fillWidth: true
                        radius: 8
                        color: "transparent"
                        property bool expanded: false
                        property int collapsedHeight: 34
                        property int expandedHeight: 120

                        implicitWidth: 180  // ancho mínimo seguro
                        implicitHeight: expanded ? expandedHeight : collapsedHeight

                        // 🔹 Animación suave en la expansión
                        Behavior on implicitHeight {
                            NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                        }
                        border.color: "#333"
                        border.width: 1

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 6
                            spacing: 4

                            // --- Cabecera (siempre visible) ---
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 8

                                Image {
                                    Layout.alignment: Qt.AlignVCenter
                                    source: modelData.icon?.external?.url ?? ""
                                    width: 24
                                    height: 24
                                    visible: source !== ""
                                }

                                StyledText {
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter
                                    text: modelData.properties?.Nombre ?? "(sin nombre)"
                                    font.bold: true
                                    elide: Text.ElideRight
                                }

                                // Flecha de expandir/colapsar
                                StyledMaterialSymbol {
                                    Layout.alignment: Qt.AlignVCenter
                                    text: "keyboard_arrow_down"
                                    size: 20
                                    opacity: 0.8
                                    color: Appearance.colors.colPrimary
                                    Behavior on rotation { NumberAnimation { duration: 150 } }
                                    rotation: expanded ? 180 : 0

                                }
                            }

                            // --- Contenido (solo visible si expandido) ---
                            ColumnLayout {
                                Layout.fillWidth: true
                                visible: expanded
                                opacity: expanded ? 1 : 0
                                Behavior on opacity { NumberAnimation { duration: 150 } }

                                StyledText {
                                    text: modelData.content || "Sin contenido"
                                    color: "#ccc"
                                    wrapMode: Text.Wrap
                                    Layout.fillWidth: true
                                }

                                Rectangle {
                                    Layout.alignment: Qt.AlignRight
                                    implicitWidth: 120
                                    implicitHeight: 26
                                    color: Appearance.colors.colSurfaceContainerHigh
                                    radius: Appearance.rounding.full

                                    StyledText {
                                        anchors.centerIn: parent
                                        text: modelData.properties?.Status?.status?.name ?? "Sin estado"
                                    }
                                }
                            }
                        }

                        // --- Interacción ---
                        MouseArea {
                            anchors.fill: parent
                            onClicked: expanded = !expanded
                            cursorShape: Qt.PointingHandCursor
                        }
                    }

                }

            }
        }
        Rect {
            Layout.fillWidth: true
            implicitHeight: calendar.implicitHeight + 20
            clip: true
            color: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
            Calendar {
                id: calendar
            }
        }
    }
    
    component Rect: Rectangle {
        radius: Appearance.rounding.small
    }
}
