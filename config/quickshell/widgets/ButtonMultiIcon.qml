import "root:/"
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell 
import Quickshell.Io

Rectangle {
    id: root

    property bool active: false
    required property Item item
    required property real h

    signal toggled(bool value) // 👈 señal para notificar cambio

    color: mouseArea.containsMouse ? "#000000" : "transparent"
    width: item.width + 10
    height: h - 5
    radius: 10
    anchors.verticalCenter: parent.verticalCenter
    Layout.alignment: Qt.AlignVCenter

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onPressed: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                root.toggled(!root.active) // 👈 avisamos al exterior
            }
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: 150
            easing.type: Easing.InOutQuad
        }
    }
}
