import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Canvas {
    id: root
    property real w: 18
    property real h: 18
    required property real value

    implicitWidth: w
    implicitHeight: h

    property real progressRight: value  // de 0 a 1
    property real progressLeft: 1.0 - 0.04 - progressRight   // de 0 a 1
    property real strokeWidth: 3
    property color colorRight: "#ffffff"
    property color colorLeft: "#929292"
    property real offsetLeft: 2 * Math.PI * 0.02 // Desfase angular (~7.2°)

    onPaint: {
        const ctx = getContext("2d")
        ctx.reset()
        ctx.clearRect(0, 0, width, height)

        const cx = width / 2
        const cy = height / 2
        const radius = (width - strokeWidth) / 2

        // Arco derecho (horario)
        ctx.beginPath()
        ctx.arc(
            cx, cy, radius,
            -Math.PI / 2,
            -Math.PI / 2 + 2 * Math.PI * progressRight,
            false
        )
        ctx.strokeStyle = colorRight
        ctx.lineWidth = strokeWidth
        ctx.lineCap = "round"
        ctx.stroke()

        // Solo dibujar el arco izquierdo si progressRight es menor a 0.80
        if (progressRight < 0.82) {
            ctx.beginPath()
            ctx.arc(
                cx, cy, radius,
                -Math.PI / 2 - offsetLeft,
                -Math.PI / 2 - offsetLeft - 2 * Math.PI * progressLeft,
                true
            )
            ctx.strokeStyle = colorLeft
            ctx.lineWidth = strokeWidth
            ctx.lineCap = "round"
            ctx.stroke()
        }
    }

    onProgressRightChanged: requestPaint()
    onProgressLeftChanged: requestPaint()
    Component.onCompleted: requestPaint()
}
