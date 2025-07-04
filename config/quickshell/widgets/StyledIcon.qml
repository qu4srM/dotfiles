import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick.Controls
import QtQuick.Effects

Item {
    id: root
    anchors.verticalCenter: parent.verticalCenter
    implicitWidth: size
    implicitHeight: parent.height
    property string iconSource: ""
    property string iconSystem: ""
    property real size: 0

    IconImage {
        id: image 
        anchors.verticalCenter: parent.verticalCenter
        implicitSize: root.size
        anchors.horizontalCenter: parent.horizontalCenter
        asynchronous: true
        source: Quickshell.iconPath(root.iconSystem, true) !== "" ? Quickshell.iconPath(root.iconSystem) : Qt.resolvedUrl("../assets/icons/" + root.iconSource)
    }
}
