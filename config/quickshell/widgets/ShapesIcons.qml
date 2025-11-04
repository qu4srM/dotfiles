import qs
import qs.configs
import qs.widgets
import qs.utils

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

Item {
    id: root

    // === PROPIEDADES ===
    property bool useSystemShape: true
    property string shape: Config.options.appearance.shapes.shape
    property bool enable: Config.options.appearance.shapes.enable
    property color color: Appearance.colors.colPrimaryActive
    property color systemColor: Appearance.colors.colBackground // color si coincide con global

    // Determina la forma actual (global o personalizada)
    readonly property string currentShape: useSystemShape ? Config.options.appearance.shapes.shape : shape

    // Lógica del color final:
    // - Si useSystemShape es true → siempre usa root.color
    // - Si es false y coincide con la forma global → usa systemColor
    // - Si no coincide → usa color normal
    readonly property color finalColor: (
        useSystemShape
        ? root.color
        : (root.shape === Config.options.appearance.shapes.shape ? root.systemColor : root.color)
    )

    Loader {
        anchors.fill: parent
        active: root.enable
        sourceComponent: Item {
            ShapeLoader {
                shape: "circle"
                sourceComponent: Rectangle {
                    anchors.fill: parent
                    color: root.finalColor
                    radius: Appearance.rounding.full
                }
            }

            ShapeLoader {
                shape: "square"
                sourceComponent: Rectangle {
                    anchors.fill: parent
                    color: root.finalColor
                    radius: Appearance.rounding.normal
                }
            }

            ShapeLoader {
                shape: "4sidedcookie"
                sourceComponent: SidedCookieShape {
                    rotation: 23
                    sides: 4
                    bulge: 0.3
                    fillColor: root.finalColor
                }
            }

            ShapeLoader {
                shape: "7sidedcookie"
                sourceComponent: SidedCookieShape {
                    sides: 7
                    bulge: 0.1
                    fillColor: root.finalColor
                }
            }

            ShapeLoader {
                shape: "arch"
                sourceComponent: Rectangle {
                    anchors.fill: parent
                    color: root.finalColor
                    topLeftRadius: Appearance.rounding.full
                    topRightRadius: Appearance.rounding.full
                    bottomLeftRadius: Appearance.rounding.unsharpenmore
                    bottomRightRadius: Appearance.rounding.unsharpenmore
                }
            }
        }
    }

    // === COMPONENTE REUTILIZABLE ===
    component ShapeLoader: Loader {
        property string shape
        anchors.fill: parent
        active: root.currentShape === shape
    }
}
