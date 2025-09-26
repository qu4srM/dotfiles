import qs.configs

import QtQuick
import QtQuick.Shapes

Shape {
    id: cookie7
    width: parent.width 
    height: parent.height
    property int sides: 4           // número de ondulaciones reales
    property real bulge: 0.35       // cuánto sobresalen/entran
    property real baseScale: 1    // tamaño base
    property color fillColor: Appearance.colors.colPrimaryActive

    preferredRendererType: Shape.CurveRenderer

    ShapePath {
        strokeWidth: 0
        fillColor: cookie7.fillColor

        PathSvg {
            path: {
                let cx = cookie7.width / 2
                let cy = cookie7.height / 2
                let r  = Math.min(cookie7.width, cookie7.height) / 2 * cookie7.baseScale
                let d  = ""

                // el ángulo base se divide en "sides * 2"
                let totalSegments = cookie7.sides * 2

                // punto inicial
                let startX = cx + r * Math.cos(0)
                let startY = cy + r * Math.sin(0)
                d += `M ${startX} ${startY} `

                for (let i = 1; i <= totalSegments; i++) {
                    let angle = (2 * Math.PI * i) / totalSegments
                    let midAngle = angle - (Math.PI / totalSegments)

                    let x = cx + r * Math.cos(angle)
                    let y = cy + r * Math.sin(angle)

                    // alternar fuera/dentro
                    let factor = (i % 2 === 0)
                        ? (1 - cookie7.bulge)
                        : (1 + cookie7.bulge)

                    let ctrlX = cx + r * factor * Math.cos(midAngle)
                    let ctrlY = cy + r * factor * Math.sin(midAngle)

                    d += `Q ${ctrlX} ${ctrlY}, ${x} ${y} `
                }

                d += "Z"
                return d
            }
        }
    }
}
