import qs
import qs.configs
import qs.widgets
import qs.services
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
    id: notificationPopup

    StyledWindow {
        id: root
        visible: true//(Notifications.popupList.length > 0) && !GlobalStates.screenLocked
        screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? null

        name: "notificationPopup"
        WlrLayershell.layer: WlrLayer.Overlay
        exclusiveZone: 0

        anchors {
            top: true
            right: true
            bottom: true
        }

        mask: Region {
            item: listview.contentItem
        }

        color: "red"
        //implicitWidth: Appearance.sizes.notificationPopupWidth
        implicitWidth: 300
        
        NotificationListView {
            id: listview
            anchors {
                top: parent.top
                bottom: parent.bottom
                right: parent.right
                rightMargin: 4
                topMargin: 4
            }
            implicitWidth: parent.width - Appearance.sizes.panelMargin * 2
            popup: true
        }
    }
}