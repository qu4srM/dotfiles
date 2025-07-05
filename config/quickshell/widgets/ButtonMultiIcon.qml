import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell 
import Quickshell.Io

Rectangle {
    id: root
    color: mouseArea.containsMouse ? "#000000" : "transparent"
    width: item.width + 10
    height: h - 5
    radius: 10
    anchors.verticalCenter: parent.verticalCenter
    Layout.alignment: Qt.AlignVCenter


    property string command: "whoami"
    required property Item item
    required property real h
    

    Process {
        id: runCommand
        command: ["bash", "-c", root.command]
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: runCommand.startDetached()
    }
    Behavior on color {
        ColorAnimation {
            duration: 150
            easing.type: Easing.InOutQuad
        }
    }
}


