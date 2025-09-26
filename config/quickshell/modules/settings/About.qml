import qs
import qs.configs
//import qs.modules.settings
import qs.utils
import qs.widgets 


import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Widgets

Item {
    id: root
    anchors.fill: parent
    property var list: [
        {
            type: "Product name",
            name: "Galaxy A34 5G"
        },
        {
            type: "Procesador",
            name: "Mediatek Dimensity 1080"
        },
        {
            type: "Gráficos",
            name: "AMD Radeon 1080"
        },
        {
            type: "Numero de serie",
            name: "1080"
        }
        
    ]
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 10
        IconImage {
            anchors.horizontalCenter: parent.horizontalCenter
            implicitSize: 100
            //source: Quickshell.iconPath("picker-symbolic.svg")
            //source: Paths.assetsPath + "/icons/picker-symbolic.svg"
            source: Qt.resolvedUrl("../../assets/icons/" + "arch-symbolic")
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Arch Linux"
            font {
                family: Appearance.font.family.main
                pixelSize: Appearance.font.pixelSize.huge
                weight: Appearance.font.weight.bold
            }
            color: "white"
        }
        Repeater {
            model: root.list
            delegate: RowLayout {
                anchors.horizontalCenter: parent.horizontalCenter
                required property var modelData
                
                StyledText {
                    text: modelData.type
                }
                StyledText {
                    text: modelData.name
                }
            }
        }
        
    }
}