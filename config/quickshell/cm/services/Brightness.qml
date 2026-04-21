pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick

/**
 * Servicio simple para manejar el brillo del sistema mediante `brightnessctl`.
 * - Devuelve un valor normalizado entre 0.0 y 1.0
 * - Permite aumentar, disminuir o establecer el brillo directamente
 */
Singleton {
    id: root

    signal brightnessChanged(real value)

    // Brillo actual normalizado (0 a 1)
    property real value: 0.0

    // Valor máximo detectado
    property int maxValue: 1

    // === Lectura inicial al cargar ===
    Component.onCompleted: refresh()

    // === Proceso para leer el brillo actual ===
    Process {
        id: readProc
        command: ["brightnessctl", "g"]
        stdout: SplitParser {
            onRead: data => {
                const current = parseInt(data.trim());
                if (!isNaN(current) && root.maxValue > 0) {
                    const newValue = current / root.maxValue;
                    if (Math.abs(newValue - root.value) > 0.001) {
                        root.value = newValue;
                        root.brightnessChanged(newValue);
                    }
                }
            }
        }
    }

    // === Proceso para leer el brillo máximo ===
    Process {
        id: maxProc
        command: ["brightnessctl", "m"]
        stdout: SplitParser {
            onRead: data => {
                const max = parseInt(data.trim());
                if (!isNaN(max)) {
                    root.maxValue = max;
                    readProc.running = true; // leer brillo actual
                }
            }
        }
    }

    // === Proceso para establecer brillo ===
    Process {
        id: setProc
    }

    // === Funciones públicas ===
    function refresh() {
        maxProc.running = true;
    }

    function setBrightness(value) {
        value = Math.max(0.01, Math.min(1, value));
        const absVal = Math.round(value * root.maxValue);
        setProc.command = ["brightnessctl", "s", absVal.toString(), "--quiet"];
        setProc.startDetached();
        root.value = value;
        root.brightnessChanged(value);
    }

    function increase(amount = 0.05) {
        setBrightness(root.value + amount);
    }

    function decrease(amount = 0.05) {
        setBrightness(root.value - amount);
    }

    IpcHandler {
        target: "brightness"

        function increment() {
            onPressed: root.increase()
        }

        function decrement() {
            onPressed: root.decrease()
        }
    }


    GlobalShortcut {
        name: "brightnessIncrease"
        description: "Increase brightness"
        onPressed: root.increase()
    }

    GlobalShortcut {
        name: "brightnessDecrease"
        description: "Decrease brightness"
        onPressed: root.decrease()
    }
}
