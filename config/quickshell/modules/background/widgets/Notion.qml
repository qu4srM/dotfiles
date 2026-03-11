import qs
import qs.configs
import qs.widgets
import qs.utils
import qs.services

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

Rectangle {
    radius: Appearance.rounding.normal 
    color: Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)

    border.width: 1
    border.color: Colors.setTransparency("white", 0.9)

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