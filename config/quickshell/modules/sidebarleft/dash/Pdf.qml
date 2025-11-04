import qs
import qs.configs
import qs.utils 
import qs.widgets
import qs.services

import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

Item {
    id: root 
    anchors.fill: parent 
    property string selectedFile: ""
    function hide (val) {
        GlobalStates.sidebarLeftRef.preventAutoHide = val
    }
    Flickable {
        anchors.fill: parent 
        contentHeight: columnLayout.implicitHeight
        clip: true
        ColumnLayout {
            id: columnLayout
            anchors.top: parent.top
            anchors.left: parent.left 
            anchors.right: parent.right 
            anchors.margins: 10
            spacing: 10 
            Page {
                Layout.fillWidth: true 
                implicitHeight: 450
            }

            
        }
    }
    Item {
        id: dialog
        anchors.centerIn: parent
        implicitWidth: parent.width 
        implicitHeight: 100 
        ActionButton{
            anchors.centerIn: parent
            buttonText: "Seleccionar PDF"
            releaseAction: () => {
                root.hide(true)
                fileDialog.open()
            }
        }
        FileDialog {
            id: fileDialog
            title: "Select a File"
            nameFilters: ["Archivos PDF (*.pdf)", "Todos los archivos (*)"]
            fileMode: FileDialog.OpenFile

            onAccepted: {
                root.selectedFile = fileDialog.selectedFile
                console.log("Archivo seleccionado:", selectedFile)
                root.hide(false)
                // Aquí puedes pasar la ruta al singleton o ejecutar el convertidor
            }

            onRejected: {
                console.log("Selección cancelada")
                root.hide(false)
            }
        }
        Text {
            text: root.selectedFile ? "📄 Archivo: " + root.selectedFile : "Ningún archivo seleccionado"
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 20
        }
    }
    component Page: ClippingRectangle {
        id: page 
        color: Appearance.colors.colSurfaceContainerHighest
        radius: Appearance.rounding.small
        
    }
}