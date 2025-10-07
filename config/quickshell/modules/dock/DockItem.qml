import qs
import qs.configs
import qs.modules.dock
import qs.widgets
import qs.utils

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Shapes
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

Rectangle {
    id: root
    required property var modelData
    property var listView: parent.width
    property int numOpens: 0

    implicitWidth: parent.height
    implicitHeight: parent.height
    color: "transparent"

    property real jumpOffset: 0

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 1000
            easing.type: Easing.OutBack
        }
    }
    SequentialAnimation {
        id: bounceAnim
        running: false
        PropertyAnimation { target: root; property: "jumpOffset"; to: -9; duration: 120; easing.type: Easing.OutQuad }
        PropertyAnimation { target: root; property: "jumpOffset"; to: 0; duration: 120; easing.type: Easing.InQuad }
        PropertyAnimation { target: root; property: "jumpOffset"; to: -6; duration: 100; easing.type: Easing.OutQuad }
        PropertyAnimation { target: root; property: "jumpOffset"; to: 0; duration: 100; easing.type: Easing.InQuad }
        PropertyAnimation { target: root; property: "jumpOffset"; to: -3;  duration: 80;  easing.type: Easing.OutQuad }
        PropertyAnimation { target: root; property: "jumpOffset"; to: 0;  duration: 80;  easing.type: Easing.InQuad }
    }
    
    ShapesIcons{
        id: shapes
        anchors.fill: parent
    }
    

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        propagateComposedEvents: true

        onClicked: {
            bounceAnim.restart()
            if (root.modelData?.execute) {
                root.modelData.execute()
            }
        }

        IconImage {
            id: iconImage 
            anchors.centerIn: parent
            anchors.verticalCenterOffset: root.jumpOffset
            width: shapes.shape ? parent.width - 6 : parent.width - 3
            height: shapes.shape ? width - 6 : width - 3
            source: Quickshell.iconPath(root.modelData?.icon ?? "")
        }
        
        Loader {
            active: Config.options.dock.monochromeIcons
            anchors.fill: iconImage 
            sourceComponent: Item {
                Desaturate {
                    id: desaturatedIcon
                    visible: false // There's already color overlay
                    anchors.fill: parent
                    source: iconImage
                    desaturation: 1
                }
                ColorOverlay {
                    anchors.fill: desaturatedIcon
                    source: desaturatedIcon
                    color: Colors.setTransparency(Appearance.colors.colOnPrimary, 0.1)
                }
            }
        }

        // Indicadores de ventanas abiertas
        Item {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            Row {
                anchors.centerIn: parent
                spacing: 4

                Repeater {
                    id: rep
                    model: ScriptModel {
                        id: appWindowsModel
                        property var modelData: root.modelData
                        objectProp: "appId"
                        values: {
                            var map = new Map()

                            const ignoredRegexes = [
                                //launcher/i,
                                //desktop/i
                            ]

                            const appAliases = {
                                "dolphin": ["org.kde.dolphin"],
                                "zen": [
                                    "zen",
                                    "zen-browser-bin",
                                    "zen-browser",
                                    "zen-bin"
                                ],
                                "lutris": [
                                    "net.lutris.Lutris"
                                ]
                            }

                            for (const toplevel of ToplevelManager.toplevels.values) {
                                if (!toplevel.appId) continue
                                if (ignoredRegexes.some(re => re.test(toplevel.appId))) continue

                                const appIdLower = toplevel.appId.toLowerCase()
                                if (!map.has(appIdLower)) {
                                    map.set(appIdLower, { toplevels: [] })
                                }
                                map.get(appIdLower).toplevels.push(toplevel)
                            }

                            var values = []
                            const appName = (modelData?.name ?? "").toLowerCase()

                            // Chequeo directo
                            if (appName && map.has(appName)) {
                                let entry = map.get(appName)
                                let limitedToplevels = entry.toplevels.slice(0, 5)
                                for (const tl of limitedToplevels) {
                                    values.push({ appId: appName, toplevel: tl })
                                }
                            }

                            // Chequeo por alias
                            if (appAliases[appName]) {
                                for (const alias of appAliases[appName]) {
                                    const aliasLower = alias.toLowerCase()
                                    if (map.has(aliasLower)) {
                                        let entry = map.get(aliasLower)
                                        let limitedToplevels = entry.toplevels.slice(0, 5)
                                        for (const tl of limitedToplevels) {
                                            values.push({ appId: aliasLower, toplevel: tl })
                                        }
                                    }
                                }
                            }

                            return values
                        }
                    }

                    delegate: Rectangle {
                        implicitWidth: rep.count > 0
                            ? (root.implicitWidth / rep.count) - parent.spacing
                            : 0
                        implicitHeight: 3
                        radius: Appearance.rounding.full
                        color: Appearance.colors.colPrimary
                    }
                }
            }
        }
    }
}
