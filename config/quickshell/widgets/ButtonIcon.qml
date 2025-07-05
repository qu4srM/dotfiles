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
    Layout.alignment: Qt.AlignVCenter
    implicitWidth: size
    implicitHeight: size + 2
    radius: 10

    property string iconSystem: ""
    property string iconSource: ""
    property string command: ""
    property string rightClickCommand: ""  // 👈 nuevo
    property real size: 0

    Process {
        id: runCommand
        command: ["bash", "-c", root.command]
    }

    Process {
        id: runRightClickCommand
        command: ["bash", "-c", root.rightClickCommand]
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onPressed: (mouse) => {
            if (mouse.button === Qt.RightButton && root.rightClickCommand !== "") {
                runRightClickCommand.startDetached()
            } else if (mouse.button === Qt.LeftButton && root.command !== "") {
                runCommand.startDetached()
            }
        }
    }

    IconImage {
        id: image
        implicitSize: root.size
        y: mouseArea.containsMouse ? 3 : 0
        anchors.horizontalCenter: parent.horizontalCenter
        asynchronous: true
        source: Quickshell.iconPath(root.iconSystem, true) !== "" ? Quickshell.iconPath(root.iconSystem) : Qt.resolvedUrl("../assets/icons/" + root.iconSource)

        Behavior on y {
            NumberAnimation {
                duration: 150
                easing.type: Easing.InOutQuad
            }
        }
    }
}
