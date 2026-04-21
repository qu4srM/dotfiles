import qs.configs 

import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root
    property var cavaData: []
    property int bars: 4
    property int framerate: 15
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
monstercat = 1.2
gravity = 80
noise_reduction = 0.25
EOF
        `]

        stdout: SplitParser {
            onRead: data => {
                let newPoints = data.split(";")
                    .map(p => parseFloat(p) / 1000)
                    .filter(p => !isNaN(p));

                let smoothFactor = 0.5;

                if (root.cavaData.length === 0 || root.cavaData.length !== newPoints.length) {
                    root.cavaData = newPoints;
                    return;
                }

                let smoothed = [];

                for (let i = 0; i < newPoints.length; i++) {
                    let oldVal = root.cavaData[i];
                    let val = oldVal + (newPoints[i] - oldVal) * smoothFactor;
                    smoothed.push(val);
                }

                root.cavaData = smoothed;
            }
        }
    }

    Row {
        anchors.fill: parent
        spacing: width * 0.08   // un poco más de separación

        Repeater {
            model: root.bars

            Rectangle {
                width: (root.width / root.bars) * 0.6
                height: parent.height * (root.cavaData[index] || 0.01)

                anchors.bottom: parent.bottom
                radius: 3

                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: Appearance.colors.colPrimary
                    }
                    GradientStop {
                        position: 1.0
                        color: Appearance.colors.colOnPrimary
                    }
                }

                Behavior on height {
                    NumberAnimation {
                        duration: 90
                        easing.type: Easing.OutQuad
                    }
                }
            }
        }
    }
}