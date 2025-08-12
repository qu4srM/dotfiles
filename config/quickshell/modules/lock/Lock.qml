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
			// Unlock the screen before exiting, or the compositor will display a
			// fallback lock you can't interact with.
			GlobalStates.screenLock = false;
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
        LazyLoader {
			id: blurLayerLoader
			required property var modelData
			active: GlobalStates.screenLock
			component: StyledWindow {
				screen: blurLayerLoader.modelData
                name: "lockWindow"
				color: "transparent"
				anchors {
					top: true
					left: true
					right: true
				}
				implicitHeight: 1
				exclusiveZone: screen.height * 3 
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