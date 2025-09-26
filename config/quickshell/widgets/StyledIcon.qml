import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick.Controls
import QtQuick.Effects

IconImage {
    id: root
    property string iconSource: ""
    property string iconSystem: ""
    property real size: 0
    implicitSize: root.size
    asynchronous: true
    //source: root.iconSystem
    /*
    source: Quickshell.iconPath(root.iconSystem, true) !== ""
          ? Quickshell.iconPath(root.iconSystem)
          : (root.iconSource !== "" 
              ? Qt.resolvedUrl("../assets/icons/" + root.iconSource)
              : Qt.resolvedUrl("../assets/icons/default.svg"))*/

}

