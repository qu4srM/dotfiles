pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: keyring

    // Indica si el keyring está disponible
    property bool available: false

    // Último estado conocido
    property string lastStatus: "unknown"

    /**
     * Llamar después de login o unlock
     * Solo refresca estado, no desbloquea
     */
    function fetchKeyringData() {
        // En setups mínimos no siempre hay keyring,
        // así que esto NO debe romper nada.
        available = true
        lastStatus = "fetched"
    }

    /**
     * Desbloquea el keyring usando contraseña
     * password: string
     */
    function unlock(password) {
        if (!password || password.length === 0) {
            console.warn("KeyringStorage: empty password, skipping unlock")
            return
        }

        // GNOME keyring (secret-tool)
        Quickshell.execDetached([
            "bash",
            "-c",
            `echo '${password.replace(/'/g, "'\\''")}' | secret-tool unlock`
        ])

        lastStatus = "unlock-attempted"
    }
}
