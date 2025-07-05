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
    implicitWidth: size
    implicitHeight: size
    property string iconSource: ""
    property string iconSystem: ""
    property real size: 0
    anchors.verticalCenter: parent.verticalCenter
    Layout.alignment: Qt.AlignVCenter

    IconImage {
        id: image 
        implicitSize: root.size
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        asynchronous: true
        source: Quickshell.iconPath(root.iconSystem, true) !== "" ? Quickshell.iconPath(root.iconSystem) : Qt.resolvedUrl("../assets/icons/" + root.iconSource)
    }
}
