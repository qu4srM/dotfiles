import qs 
import qs.configs 
import qs.widgets
import qs.utils
import qs.services

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
    id: root 
    property var focusedScreen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name)
    property bool packageManagerRunning: false
    property bool downloadRunning: false

    function closeAllWindows() {
        HyprlandData.windowList.map(w => w.pid).forEach((pid) => {
            Quickshell.execDetached(["kill", pid]);
        });
    }
    function detectRunningStuff() {
        packageManagerRunning = false;
        downloadRunning = false;
        detectPackageManagerProc.running = false;
        detectPackageManagerProc.running = true;
        detectDownloadProc.running = false;
        detectDownloadProc.running = true;
    }

    Process {
        id: detectPackageManagerProc
        command: ["pidof", "pacman", "yay", "paru", "dnf", "zypper", "apt", "apx", "xbps", "flatpak", "snap", "apk",
            "yum", "epsi", "pikman"]
        onExited: (exitCode, exitStatus) => {
            root.packageManagerRunning = (exitCode === 0);
        }
    }

    Process {
        id: detectDownloadProc
        command: ["bash", "-c", "pidof curl wget aria2c yt-dlp || ls ~/Downloads | grep -E '\.crdownload$|\.part$'"]
        onExited: (exitCode, exitStatus) => {
            root.downloadRunning = (exitCode === 0);
        }
    }
    Loader {
        id: sessionLoader 
        active: GlobalStates.sessionOpen
        onActiveChanged: {
            if (sessionLoader.active) root.detectRunningStuff();
        }
        Connections {
            target: GlobalStates
            function onScreenLockChanged() {
                if (GlobalStates.screenLock) {
                    GlobalStates.sessionOpen = false;
                }
            }

        }
        sourceComponent: StyledWindow {
            id: session
            visible: sessionLoader.active 

            function hide() {
                GlobalStates.sessionOpen = false;
            }
            exclusionMode: ExclusionMode.Ignore
            name: "session"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            color: Colors.setTransparency(Appearance.colors.colbackground, 0.3)

            anchors {
                top: true
                left: true
                right: true
            }
            implicitWidth: root.focusedScreen?.width ?? 0
            implicitHeight: root.focusedScreen?.height ?? 0

            MouseArea {
                id: sessionMouseArea
                anchors.fill: parent
                onClicked: {
                    session.hide()
                }
            }
            ColumnLayout {
                id: contentColumn
                anchors.centerIn: parent
                spacing: 15

                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_Escape) {
                        session.hide();
                    }
                }
                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 0
                    StyledText {
                        Layout.alignment: Qt.AlignHCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.family: Appearance.font.family.title
                        font.pixelSize: Appearance.font.pixelSize.title
                        font.weight: Font.DemiBold
                        text: Translation.tr("Session")
                    }

                    StyledText {
                        Layout.alignment: Qt.AlignHCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: Appearance.font.pixelSize.normal
                        text: Translation.tr("Arrow keys to navigate, Enter to select\nEsc or click anywhere to cancel")
                    }
                }
                RowLayout {
                    spacing: 15
                    SessionActionButton {
                        id: sessionLock 
                        toolTipText: Translation.tr("Lock")
                        focus: session.visible 
                        iconMaterial: "lock"
                        onClicked: ()=> {
                            //Quickshell.execDetached(["loginctl", "lock-session"]); session.hide() 
                            //Quickshell.execDetached(["bash", "-c", "swaylock"]); session.hide() 
                            //session.hide(); Quickshell.execDetached(["bash", "-c", "swaylock"])
                            GlobalStates.screenLock = true 
                            session.hide()
                        }
                        KeyNavigation.right: sessionSleep
                    }
                    SessionActionButton {
                        id: sessionSleep
                        toolTipText: Translation.tr("Sleep")
                        iconMaterial: "dark_mode"
                        onClicked: ()=> {
                            Quickshell.execDetached(["bash", "-c", "systemctl suspend || loginctl suspend"]); session.hide()
                        }
                        KeyNavigation.left: sessionLock
                        KeyNavigation.right: sessionLogout
                    }
                    SessionActionButton {
                        id: sessionLogout
                        toolTipText: Translation.tr("Logout")
                        iconMaterial: "logout"
                        onClicked: ()=> {
                           root.closeAllWindows(); Quickshell.execDetached(["pkill", "Hyprland"]); session.hide()
                        }
                        KeyNavigation.left: sessionSleep
                        KeyNavigation.right: sessionHibernate
                    }
                    SessionActionButton {
                        id: sessionHibernate
                        toolTipText: Translation.tr("Hibernate")
                        iconMaterial: "do_not_disturb_on"
                        onClicked: ()=> {
                            Quickshell.execDetached(["bash", "-c", `systemctl hibernate || loginctl hibernate`]); session.hide() 
                        }
                    }
                    SessionActionButton {
                        id: sessionShutdown
                        toolTipText: Translation.tr("Shutdown")
                        iconMaterial: "power_settings_new"
                        onClicked: ()=> {
                            root.closeAllWindows(); Quickshell.execDetached(["bash", "-c", `systemctl poweroff || loginctl poweroff`]); session.hide()
                        }
                        KeyNavigation.left: sessionHibernate
                        KeyNavigation.right: sessionReboot
                    }
                    SessionActionButton {
                        id: sessionReboot
                        toolTipText: Translation.tr("Reboot")
                        iconMaterial: "restart_alt"
                        onClicked: ()=> {
                            root.closeAllWindows(); Quickshell.execDetached(["bash", "-c", `reboot || loginctl reboot`]); session.hide()
                        }
                        KeyNavigation.left: sessionShutdown
                    }  
                }
            }
            RowLayout {
                anchors {
                    top: contentColumn.bottom
                    topMargin: 10
                    horizontalCenter: contentColumn.horizontalCenter
                }
                spacing: 10

                Loader {
                    active: root.packageManagerRunning
                    visible: active
                    sourceComponent: StyledText {
                        text: Translation.tr("Your package manager is running")
                        color: Appearance.colors.colprimary_error
                    }
                }
                Loader {
                    active: root.downloadRunning
                    visible: active
                    sourceComponent: StyledText {
                        text: Translation.tr("There might be a download in progress")
                        color: Appearance.colors.colprimary_error
                    }
                }
            }
        }
    }
    IpcHandler {
        target: "session"

        function toggle(): void {
            GlobalStates.sessionOpen = !GlobalStates.sessionOpen;
        }

        function close(): void {
            GlobalStates.sessionOpen = false
        }

        function open(): void {
            GlobalStates.sessionOpen = true
        }
    }
    GlobalShortcut {
        name: "sessionToggle"
        description: "Toggles session screen on press"

        onPressed: {
            GlobalStates.sessionOpen = !GlobalStates.sessionOpen;
        }
    }

    GlobalShortcut {
        name: "sessionOpen"
        description: "Opens session screen on press"

        onPressed: {
            GlobalStates.sessionOpen = true
        }
    }

    GlobalShortcut {
        name: "sessionClose"
        description: "Closes session screen on press"

        onPressed: {
            GlobalStates.sessionOpen = false
        }
    }
}