import qs.configs
import QtQuick
import QtQuick.Shapes

Shape {
    id: cookie
    property int sides: 4
    property real bulge: 0.35
    property real baseScale: 1.0
    property color fillColor: Appearance.colors.colPrimaryActive

    width: parent ? parent.width : 64
    height: parent ? parent.height : 64

    preferredRendererType: Shape.CurveRenderer

    property string cachedPath: ""

    // recalcula solo cuando cambia algo relevante
    function generatePath() {
        const cx = width / 2
        const cy = height / 2
        const r = Math.min(width, height) / 2 * baseScale
        let d = ""

        const totalSegments = sides * 2
        let startX = cx + r * Math.cos(0)
        let startY = cy + r * Math.sin(0)
        d += `M ${startX} ${startY} `

        for (let i = 1; i <= totalSegments; i++) {
            const angle = (2 * Math.PI * i) / totalSegments
            const midAngle = angle - (Math.PI / totalSegments)
            const x = cx + r * Math.cos(angle)
            const y = cy + r * Math.sin(angle)
            const factor = (i % 2 === 0) ? (1 - bulge) : (1 + bulge)
            const ctrlX = cx + r * factor * Math.cos(midAngle)
            const ctrlY = cy + r * factor * Math.sin(midAngle)
            d += `Q ${ctrlX} ${ctrlY}, ${x} ${y} `
        }
        d += "Z"
        cachedPath = d
    }

    onWidthChanged: generatePath()
    onHeightChanged: generatePath()
    onSidesChanged: generatePath()
    onBulgeChanged: generatePath()
    Component.onCompleted: generatePath()

    ShapePath {
        strokeWidth: 0
        fillColor: cookie.fillColor
        PathSvg { path: cookie.cachedPath }
    }
}
