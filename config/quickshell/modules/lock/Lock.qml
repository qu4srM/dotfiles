import qs
import qs.configs
import qs.modules.lock
import qs.widgets
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
    id: root 
    LockContext {
		id: lockContext

		onUnlocked: {
			GlobalStates.screenLock = false;
			Quickshell.execDetached(["bash", "-c", `sleep 0.2; hyprctl --batch "dispatch togglespecialworkspace; dispatch togglespecialworkspace"`])
		}
	}
    WlSessionLock {
        id: lock
		locked: GlobalStates.screenLock

		WlSessionLockSurface {
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
    }
	Variants {
        model: Quickshell.screens
		delegate: Scope {
			required property ShellScreen modelData
			property bool shouldPush: GlobalStates.screenLock
			property string targetMonitorName: modelData.name
			property int verticalMovementDistance: modelData.height
			property int horizontalSqueeze: modelData.width * 0.2
			onShouldPushChanged: {
				if (shouldPush) {
					Quickshell.execDetached(["bash", "-c", `hyprctl keyword monitor ${targetMonitorName}, addreserved, ${verticalMovementDistance}, ${-verticalMovementDistance}, ${horizontalSqueeze}, ${horizontalSqueeze}`])
				} else {
					Quickshell.execDetached(["bash", "-c", `hyprctl keyword monitor ${targetMonitorName}, addreserved, 0, 0, 0, 0`])
				}
			}
		}
	}
    IpcHandler {
        target: "lock"

        function activate(): void {
            GlobalStates.screenLock = true;
        }
		function focus(): void {
			lockContext.shouldReFocus();
		}
    }

	GlobalShortcut {
        name: "lock"
        description: "Locks the screen"

        onPressed: {
            GlobalStates.screenLock = true;
        }
    }

	GlobalShortcut {
        name: "lockFocus"
        description: "Re-focuses the lock screen. This is because Hyprland after waking up for whatever reason"
			+ "decides to keyboard-unfocus the lock screen"

        onPressed: {
			// console.log("I BEG FOR PLEAS REFOCUZ")
            lockContext.shouldReFocus();
        }
    }
}