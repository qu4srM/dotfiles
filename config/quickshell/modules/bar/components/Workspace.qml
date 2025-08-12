import qs 
import qs.configs
import qs.modules.bar.components
import qs.services
import qs.widgets 
import qs.utils

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland


Item {
    id: root
    width: 19
    height: 18
    required property int workspaceId
    property string workspaceActive: ""
    anchors.verticalCenter: parent.verticalCenter
    Layout.alignment: Qt.AlignVCenter

    Text {
        anchors.centerIn: parent
        text: "·"
        font.family: "Roboto"
        color: root.workspaceActive === "true" ? "transparent" : mouseArea.containsMouse ? Appearance.colors.colprimary_hover : Appearance.colors.colsecondarytext
        font.pixelSize: 40
        font.weight: Font.Medium
    }

    StyledIcon {
        id: icon
        anchors.centerIn: parent
        size: 13
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            Hyprland.dispatch("workspace " + root.workspaceId)
        }
    }
    Process {
        id: multiProcess
        command: ["bash", "-c",
            "ws_id=" + root.workspaceId + "; " +
            "var1=$(hyprctl clients -j | jq -r --argjson ws $ws_id '.[] | select(.workspace.id == $ws) | .class' | head -n1); " +
            "var2=$(hyprctl clients -j | jq -e --argjson ws $ws_id 'any(.[]; .workspace.id == $ws)' > /dev/null && echo true || echo false); " +
            "echo \"$var1|$var2\""
        ]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const parts = this.text.trim().split("|")
                icon.iconSystem = Icons.getIcon(parts[0] || "")
                workspaceActive = parts[1] || ""
            }
        }
    }
    
    Timer {
        interval: 3000
        running: true
        repeat: true
        //onTriggered: getAppClassProcess.running = true
        onTriggered: multiProcess.running = true
    }
}