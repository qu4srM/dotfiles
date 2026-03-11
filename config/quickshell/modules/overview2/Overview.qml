import qs 
import qs.configs
import qs.widgets 
import qs.utils
import qs.services

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland

Scope {
    id: root
    Variants {
        model: Quickshell.screens
        LazyLoader {
            id: overviewLoader 
            active: GlobalStates.overviewOpen && !GlobalStates.screenLock
            required property ShellScreen modelData 
            component: StyledWindow {
                id: overview
                screen: overviewLoader.modelData
                name: "overview"
                color: Colors.setTransparency(Appearance.colors.colglassmorphism, 0.90)

                property string pathIcons: "root:/assets/icons/"
                property string colorMain: "transparent"
                property string pathScripts: "~/.config/quickshell/scripts/"

                WlrLayershell.layer: WlrLayer.Overlay
                WlrLayershell.exclusionMode: ExclusionMode.Ignore
                anchors {
                    left: true
                    right: true 
                    top: true 
                    bottom: true
                }
                function hide() {
                    GlobalStates.overviewOpen = false
                }
                MouseArea {
                    anchors.fill: parent 
                    onClicked: {
                        overview.hide()
                    }
                }

                /*
                Rectangle {
                    visible: !Config.options.bar.showBackground
                    id: shadow
                    anchors.top: parent.top 
                    implicitWidth: parent.width 
                    implicitHeight: 1
                    color: "transparent"
                }
                StyledRectangularShadow {
                    visible: !Config.options.bar.showBackground 
                    target: shadow
                    blur: 30
                }*/

                Rectangle {
                    id: content
                    anchors.centerIn: parent
                    width: widget.implicitWidth
                    height: widget.implicitHeight
                    color: "transparent"
                    radius: Config.options.bar.floating ? Appearance.rounding.normal : 0
                    OverviewWidget {
                        id: widget
                        anchors.centerIn: parent
                        styledWindow: overview
                    }
                }
            }
            
        }
    }
    GlobalShortcut {
        name: "overviewToggle"
        description: "Toggles overview on press"
        onPressed: GlobalStates.overviewOpen = !GlobalStates.overviewOpen;
    }

    GlobalShortcut {
        name: "overviewOpen"
        description: "Opens overview on press"
        onPressed: GlobalStates.overviewOpen = true;
    }

    GlobalShortcut {
        name: "overviewClose"
        description: "Closes overview on press"
        onPressed: GlobalStates.overviewOpen = false;
    }
}
