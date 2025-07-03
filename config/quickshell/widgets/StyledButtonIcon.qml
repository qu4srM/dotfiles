import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick.Controls
import QtQuick.Effects

Rectangle {
    id: root
    property string background: "transparent"
    color: background
    anchors.verticalCenter: parent.verticalCenter
    implicitWidth: 22
    implicitHeight: 22
    radius: 10
    property string iconSource: ""
    property string iconSystem: ""
    property string command: ""
    property real size: 0

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

    IconImage {
        id: image 
        anchors.verticalCenter: parent.verticalCenter
        implicitSize: root.size
        anchors.horizontalCenter: parent.horizontalCenter
        asynchronous: true
        source: Quickshell.iconPath(root.iconSystem, true) !== "" ? Quickshell.iconPath(root.iconSystem) : Qt.resolvedUrl("../assets/icons/" + root.iconSource)
    }
}
