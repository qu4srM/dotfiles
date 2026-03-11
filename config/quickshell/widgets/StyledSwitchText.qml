import qs
import qs.configs
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

ActionButton {
    id: root 
    property string buttonIcon: ""
    onClicked: checked = !checked
    contentItem: RowLayout {
        spacing: 10
        StyledText {
            id: labelWidget
            Layout.fillWidth: true
            text: root.text
            font.pixelSize: Appearance.font.pixelSize.large
            color: "white"
        }
        StyledSwitch {
            id: switchWidget
            activeColor: Appearance.colors.colOnPrimary
            inactiveColor: "transparent"
            down: root.down
            scale: 0.6
            Layout.fillWidth: false
            checked: root.checked
            onClicked: root.clicked()
        }
    }
}