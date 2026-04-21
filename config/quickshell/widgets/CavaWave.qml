import qs.configs

import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Effects

Item {
    id: root
    property var cavaData: []
    property int bars: 20
    property int framerate: 30
    property string method: "pipewire"

    Process {
        id: cavaProc
        running: true

        command: ["sh", "-c", `
            cava -p /dev/stdin <<EOF
[general]
bars = ${root.bars}
framerate = ${root.framerate}
autosens = 1

[input]
method = ${root.method}

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 1000
bar_delimiter = 59

[smoothing]
monstercat = 1.5
gravity = 100
noise_reduction = 0.20

[eq] 
1 = 1 
2 = 1 
3 = 1 
4 = 1
5 = 1
EOF
        `]

        stdout: SplitParser {
            onRead: data => {
                let newPoints = data.split(";")
                    .map(p => parseFloat(p.trim()) / 1000)
                    .filter(p => !isNaN(p));

                // smoothing más ligero
                let smoothFactor = 0.6;

                if (root.cavaData.length === 0 || root.cavaData.length !== newPoints.length) {
                    root.cavaData = newPoints;
                    canvas.requestPaint();
                    return;
                }

                let smoothed = [];
                let changed = false;

                for (let i = 0; i < newPoints.length; i++) {
                    let oldVal = root.cavaData[i];
                    let newVal = newPoints[i];

                    let val = oldVal + (newVal - oldVal) * smoothFactor;
                    smoothed.push(val);

                    if (Math.abs(val - oldVal) > 0.01) {
                        changed = true;
                    }
                }

                root.cavaData = smoothed;

                if (changed) {
                    canvas.requestPaint();
                }
            }
        }
    }

    Canvas {
        id: canvas
        anchors.fill: parent

        property var gradientCache: null

        onPaint: {
            var ctx = getContext('2d')
            ctx.clearRect(0, 0, width, height)

            // cachear gradiente
            if (!gradientCache) {
                gradientCache = ctx.createLinearGradient(0, 0, width, 0)
                gradientCache.addColorStop(0.0, Appearance.colors.colPrimary)
                gradientCache.addColorStop(1.0, Appearance.colors.colOnPrimary)
            }

            drawWave(ctx, root.cavaData)
        }

        function drawWave(ctx, data) {
            if (data.length < 2) return

            ctx.beginPath()
            ctx.fillStyle = gradientCache

            ctx.moveTo(0, height)

            var barWidth = width / (data.length - 1)

            for (var i = 0; i < data.length - 1; i++) {
                var x = i * barWidth
                var y = height - (data[i] * height)

                var nx = (i + 1) * barWidth
                var ny = height - (data[i + 1] * height)

                var mx = (x + nx) / 2
                var my = (y + ny) / 2

                ctx.quadraticCurveTo(x, y, mx, my)
            }

            ctx.lineTo(width, height)
            ctx.closePath()
            ctx.fill()
        }
    }
}