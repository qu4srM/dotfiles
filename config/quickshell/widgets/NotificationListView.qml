import qs
import qs.configs
import qs.widgets
import qs.services
import QtQuick
import Quickshell

StyledListView { // Scrollable window
    id: root
    property bool popup: false
    property real dragDistance: 0
    property int dragIndex: -1

    function resetDrag() {
        dragDistance = 0
        dragIndex = -1
    }


    spacing: 3

    model: ScriptModel {
        values: root.popup ? Notifications.popupAppNameList : Notifications.appNameList
    }
    delegate: NotificationGroup {
        required property int index
        required property var modelData
        popup: root.popup
        anchors.left: parent?.left
        anchors.right: parent?.right
        notificationGroup: popup ? 
            Notifications.popupGroupsByAppName[modelData] :
            Notifications.groupsByAppName[modelData]
    }
}