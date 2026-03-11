import qs
import qs.configs
import qs.widgets
import qs.utils
import qs.services

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls 
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland

Rectangle {
    id: root
    required property var modelData

    property var windowByAddress: HyprlandData.windowByAddress
    property var windowAddresses: HyprlandData.addresses

    property bool isLauncher: modelData?.type === "launcher"
    property var appData: isLauncher ? null : modelData?.app
    property var appTopLevel: modelData

    property real hoverScale: 1.0
    property real baseSize: 30
    property real jumpOffset: 0
    property bool hoverVisible: hoverScale >= (Config.options.dock.magnification.maxBoost + 1 - 0.1)
    property bool hoverVisibleOptions: hoverScale >= (Config.options.dock.magnification.maxBoost + 1 - 0.2)

    color: "transparent"


    Behavior on implicitWidth {
        animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
    }
    Behavior on implicitHeight {
        animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
    }

    SequentialAnimation {
        id: bounceAnim
        PropertyAnimation { target: root; property: "jumpOffset"; to: -9; duration: 120 }
        PropertyAnimation { target: root; property: "jumpOffset"; to: 0; duration: 120 }
        PropertyAnimation { target: root; property: "jumpOffset"; to: -6; duration: 100 }
        PropertyAnimation { target: root; property: "jumpOffset"; to: 0; duration: 100 }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: false
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: (mouse) => {
            bounceAnim.restart()

            
            if (mouse.button === Qt.LeftButton) {
                if (isLauncher) {
                    GlobalStates.launcherOpen = true
                    return
                }

                if (root.modelData?.running) {
                    Quickshell.execDetached(["bash", "-c", "hyprctl dispatch focuswindow class:" + root.modelData?.appId])
                    Apps.visibleOptions = false
                    return;
                    
                } else {
                    appData.execute();
                    Apps.visibleOptions = false
                    return
                }

            }

            if (mouse.button === Qt.RightButton) {
                Apps.setLastApp(root.modelData)
                Apps.addClickedPosition(root)
                Apps.visibleOptions = true 
            }
        }
        ShapesIcons {
            anchors.fill: parent
        }


        Image {
            id: icon
            anchors.centerIn: parent
            anchors.verticalCenterOffset: root.jumpOffset
            width: parent.width - 10
            height: width
            source: isLauncher
                ? Qt.resolvedUrl(Quickshell.shellPath("assets/icons") + "/" + modelData.icon)
                : Quickshell.iconPath(appData?.icon ?? "")
            smooth: true
            mipmap: true
            antialiasing: true
            asynchronous: true
            cache: false
            fillMode: Image.PreserveAspectFit
        }
        Loader {
            active: Config.options.dock.monochromeIcons
            anchors.fill: icon
            sourceComponent: Item {
                Desaturate {
                    id: desaturatedIcon
                    visible: false // Ya hay overlay de color
                    anchors.fill: parent
                    source: icon
                    desaturation: 1
                }
                ColorOverlay {
                    anchors.fill: desaturatedIcon
                    source: desaturatedIcon
                    color: Colors.setTransparency('#282828', 1)
                }
            }
        }

        Rectangle {
            id: tooltip
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.top
            anchors.bottomMargin: hoverScale - 1
            radius: Appearance.rounding.verysmall
            visible: opacity > 0
            opacity: hoverVisible ? 1 : 0

            color: Config.options.bar.showBackground
                ? Appearance.colors.colOnTooltip
                : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)

            implicitWidth: tooltipText.implicitWidth + 10
            implicitHeight: tooltipText.implicitHeight + 10

            Behavior on opacity { NumberAnimation { duration: 150 } }

            StyledText {
                id: tooltipText
                anchors.centerIn: parent
                text: isLauncher ? "Launcher" : (appData?.name ?? "App")
                font.pixelSize: Appearance.font.pixelSize.smaller
                color: Appearance.colors.colTooltip
            }
        }
        
                    
        Item {
            visible: !isLauncher
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            Row {
                anchors.centerIn: parent
                spacing: 4
                Repeater {
                    model: ScriptModel {
                        values: {
                            let values = []
                            if (!appData) return values

                            for (const tl of ToplevelManager.toplevels.values) {
                                if (tl.appId?.toLowerCase() === appData.id?.toLowerCase())
                                    values.push(tl)
                            }
                            return values.slice(0, 5)
                        }
                    }

                    delegate: Rectangle {
                        implicitWidth: 3
                        implicitHeight: 3
                        radius: Appearance.rounding.full
                        color: Appearance.colors.colPrimary
                    }
                }
            }
        }
    }
}
