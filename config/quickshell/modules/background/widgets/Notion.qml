import qs
import qs.configs
import qs.configs.utils
import qs.widgets
import qs.services

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

Rectangle {
    radius: Appearance.rounding.normal 
    color: Appearance.colors.colGlass
    border.width: 1
    border.color: Appearance.colors.colGlassBorder

    ColumnLayout {
        anchors.fill: parent 
        anchors.margins: 20
        ActionButton {
            Layout.alignment: Qt.AlignHCenter
            buttonText: "New Note"
        }
        ActionButton {
            Layout.alignment: Qt.AlignHCenter
            buttonText: "New Note"
        }
    }

}