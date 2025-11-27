import qs
import qs.configs
import qs.widgets
import qs.utils

import QtQuick
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland

Rectangle {
    id: root
    required property var modelData
    property real hoverScale: 1.0
    property real baseSize: 30
    property var listView: parent.width
    property int numOpens: 0
    color: "transparent"

    property real jumpOffset: 0
    property bool hoverVisible: hoverScale >= 1.3 // Tooltip visible a partir de cierto tamaño

    Behavior on implicitWidth {
        animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
    }
    Behavior on implicitHeight {
        animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
    }

    SequentialAnimation {
        id: bounceAnim
        running: false
        PropertyAnimation { target: root; property: "jumpOffset"; to: -9; duration: 120; easing.type: Easing.OutQuad }
        PropertyAnimation { target: root; property: "jumpOffset"; to: 0; duration: 120; easing.type: Easing.InQuad }
        PropertyAnimation { target: root; property: "jumpOffset"; to: -6; duration: 100; easing.type: Easing.OutQuad }
        PropertyAnimation { target: root; property: "jumpOffset"; to: 0; duration: 100; easing.type: Easing.InQuad }
        PropertyAnimation { target: root; property: "jumpOffset"; to: -3; duration: 80; easing.type: Easing.OutQuad }
        PropertyAnimation { target: root; property: "jumpOffset"; to: 0; duration: 80; easing.type: Easing.InQuad }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        propagateComposedEvents: true
        hoverEnabled: true

        onClicked: {
            bounceAnim.restart()
            if (root.modelData?.execute)
                root.modelData.execute()
        }

        // === Fondo / formas ===
        ShapesIcons {
            id: shapes
            anchors.fill: parent
        }

        // === Ícono principal ===
        Image {
            id: iconImage
            anchors.centerIn: parent
            anchors.verticalCenterOffset: root.jumpOffset
            width: parent.width - 10
            height: width
            source: Quickshell.iconPath(root.modelData?.icon ?? "")
        }

        // === Desaturación opcional ===
        Loader {
            active: Config.options.dock.monochromeIcons
            anchors.fill: iconImage
            sourceComponent: Item {
                Desaturate {
                    id: desaturatedIcon
                    visible: false // Ya hay overlay de color
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

        // === Tooltip flotante ===
        Rectangle {
            id: tooltip
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.top
            anchors.bottomMargin: hoverScale - 1 // se eleva con el zoom
            radius: Appearance?.rounding.verysmall ?? 7
            visible: opacity > 0
            opacity: hoverVisible ? 1 : 0
            color: Config.options.bar.showBackground
                ? Appearance.colors.colOnTooltip
                : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)

            implicitWidth: tooltipText.implicitWidth + 10
            implicitHeight: tooltipText.implicitHeight + 8

            Behavior on opacity { NumberAnimation { duration: 150 } }

            StyledText {
                id: tooltipText
                anchors.centerIn: parent
                text: root.modelData?.name ?? "App"
                font.pixelSize: Appearance?.font.pixelSize.smaller ?? 14
                color: Appearance?.colors.colTooltip ?? "#FFFFFF"
                font.hintingPreference: Font.PreferNoHinting
            }
        }

        // === Indicadores de ventanas abiertas ===
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
                                // launcher/i,
                                // desktop/i
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
                                if (!map.has(appIdLower))
                                    map.set(appIdLower, { toplevels: [] })
                                map.get(appIdLower).toplevels.push(toplevel)
                            }

                            var values = []
                            const appName = (modelData?.name ?? "").toLowerCase()

                            // Chequeo directo
                            if (appName && map.has(appName)) {
                                let entry = map.get(appName)
                                let limitedToplevels = entry.toplevels.slice(0, 5)
                                for (const tl of limitedToplevels)
                                    values.push({ appId: appName, toplevel: tl })
                            }

                            // Chequeo por alias
                            if (appAliases[appName]) {
                                for (const alias of appAliases[appName]) {
                                    const aliasLower = alias.toLowerCase()
                                    if (map.has(aliasLower)) {
                                        let entry = map.get(aliasLower)
                                        let limitedToplevels = entry.toplevels.slice(0, 5)
                                        for (const tl of limitedToplevels)
                                            values.push({ appId: aliasLower, toplevel: tl })
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

    // === Reacción a hoverScale ===
    onHoverScaleChanged: {
        tooltip.opacity = hoverScale >= 1.4 ? 1 : 0
    }
}
