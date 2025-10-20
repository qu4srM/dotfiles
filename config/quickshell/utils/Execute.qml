pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

Singleton {
    id: root

    //--------------------------------- COPY ---------------------------------------------
    function copyTextToClipboard(text) {
        Quickshell.execDetached(["bash", "-c", `echo "${text}" | wl-copy -n`])
    }
    //--------------------------------- Open Apps ---------------------------------------------
    function openScreenshot() {
        Quickshell.execDetached(["bash", "-c", "~/.config/quickshell/scripts/screenshot.sh"])
    }
    function openHyprpicker() {
        Quickshell.execDetached(["bash", "-c", "hyprpicker | wl-copy -n"])
    }
    function sendNotification(subject, body, icon, timeout, urgency) {
        // Evitar ejecutar si todo está vacío
        if ((!subject || subject.trim() === "") && (!body || body.trim() === "")) {
            console.log("⚠️ Notificación no enviada: faltan parámetros.")
            return
        }

        // Construir el comando base
        let cmd = "notify-send"

        // Argumentos opcionales
        if (urgency && urgency.trim() !== "")
            cmd += ` -u ${urgency.trim()}` // low | normal | critical

        if (timeout && timeout.toString().trim() !== "")
            cmd += ` -t ${timeout}` // milisegundos

        if (icon && icon.trim() !== "")
            cmd += ` -i "${icon.trim()}"`

        // Agregar título y cuerpo (si existen)
        if (subject && subject.trim() !== "")
            cmd += ` "${subject.trim()}"`
        if (body && body.trim() !== "")
            cmd += ` "${body.trim()}"`

        // Ejecutar el comando si hay al menos subject o body
        Quickshell.execDetached(["bash", "-c", cmd])
    }
}