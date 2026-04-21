import qs
import qs.configs
import qs.modules.lock
import qs.widgets
import qs.services
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland   // ✅ NECESARIO para HyprlandData

Scope {
    id: root

    // Monitor name -> workspace id to restore on unlock (set when locking)
    property var savedWorkspaces: ({})

    property Component sessionLockSurface: WlSessionLockSurface {
        id: sessionLockSurface
        color: "transparent"

        Loader {
            active: GlobalStates.screenLock
            anchors.fill: parent
            opacity: active ? 1 : 0

            Behavior on opacity {
                animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
            }

            sourceComponent: LockSurface {
                context: lockContext
            }
        }
    }

    Process {
        id: unlockKeyringProc
        onExited: (exitCode, exitStatus) => {
            KeyringStorage.fetchKeyringData();
        }
    }

    function unlockKeyring() {
        unlockKeyringProc.exec({
            environment: ({
                "UNLOCK_PASSWORD": lockContext.currentText
            }),
            command: ["bash", "-c", Quickshell.shellPath("scripts/keyring/unlock.sh")]
        })
    }

    LockContext {
        id: lockContext

        Connections {
            target: GlobalStates

            // ✅ FIX: nombre correcto del signal
            function onScreenLockChanged() {
                if (GlobalStates.screenLock) {
                    lockContext.reset();
                    lockContext.tryFingerUnlock();
                }
            }
        }

        onUnlocked: (targetAction) => {
            if (targetAction == LockContext.ActionEnum.Poweroff) {
                Session.poweroff();
                return;
            } else if (targetAction == LockContext.ActionEnum.Reboot) {
                Session.reboot();
                return;
            }

            // ✅ FIX: acceso defensivo al config
            if (Config.options?.lock?.security?.unlockKeyring === true)
                root.unlockKeyring();

            GlobalStates.screenLock = false;

            Quickshell.execDetached([
                "bash",
                "-c",
                "sleep 0.2; hyprctl --batch \"dispatch togglespecialworkspace; dispatch togglespecialworkspace\""
            ])

            lockContext.reset();

            if (lockContext.alsoInhibitIdle) {
                lockContext.alsoInhibitIdle = false;
                Idle.toggleInhibit(true);
            }
        }
    }

    WlSessionLock {
        id: lock
        locked: GlobalStates.screenLock
        surface: root.sessionLockSurface
    }

    function lock() {
        if (Config.options?.lock?.useHyprlock === true) {
            Quickshell.execDetached(["bash", "-c", "pidof hyprlock || hyprlock"]);
            return;
        }
        GlobalStates.screenLock = true;
    }

    IpcHandler {
        target: "lock"

        function activate(): void {
            root.lock();
        }
        function focus(): void {
            lockContext.shouldReFocus();
        }
    }

    GlobalShortcut {
        name: "lock"
        description: "Locks the screen"

        onPressed: root.lock()
    }

    GlobalShortcut {
        name: "lockFocus"
        description: "Re-focuses the lock screen"

        onPressed: lockContext.shouldReFocus()
    }

    function initIfReady() {
        if (!Config.ready || !Persistent.ready)
            return;

        if (Config.options?.lock?.launchOnStartup && Persistent.isNewHyprlandInstance) {
            root.lock();
        } else {
            KeyringStorage.fetchKeyringData();
        }
    }

    // ✅ FIX: NO usar onReadyChanged (no existe)
    Component.onCompleted: initIfReady()

    Timer {
        id: restoreTimer
        interval: 150
        repeat: false

        onTriggered: {
            var batch = ""
            for (var j = 0; j < Quickshell.screens.length; ++j) {
                var monName = Quickshell.screens[j].name
                var wsId = root.savedWorkspaces[monName]
                if (wsId !== undefined) {
                    batch += "dispatch focusmonitor " + monName +
                             "; dispatch workspace " + wsId + "; "
                }
            }
            if (batch.length > 0) {
                Quickshell.execDetached(["hyprctl", "--batch", batch + "reload"])
            }
        }
    }

    Connections {
        target: GlobalStates

        function onScreenLockChanged() {
            if (GlobalStates.screenLock) {
                var next = {}
                var batch = "keyword animation workspaces,1,7,menu_decel,slidevert; "

                for (var i = 0; i < Quickshell.screens.length; ++i) {
                    var mon = Quickshell.screens[i].name
                    var mData = HyprlandData.monitors.find(m => m.name === mon)
                    var ws = (mData?.activeWorkspace?.id ?? 1)

                    next[mon] = ws
                    batch += "dispatch focusmonitor " + mon +
                             "; dispatch workspace " + (2147483647 - ws) + "; "
                }

                root.savedWorkspaces = next
                Quickshell.execDetached(["hyprctl", "--batch", batch + "reload"])
            } else {
                restoreTimer.start()
            }
        }
    }

    Variants {
        model: Quickshell.screens
        delegate: Scope {
            required property ShellScreen modelData
            property bool shouldPush: GlobalStates.screenLock
            property string targetMonitorName: modelData.name
            property int verticalMovementDistance: modelData.height
            property int horizontalSqueeze: modelData.width * 0.2
        }
    }
}
