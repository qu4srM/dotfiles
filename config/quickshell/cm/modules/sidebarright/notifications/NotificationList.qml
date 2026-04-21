import qs.configs
import qs.widgets
import qs.services
import qs
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    

    NotificationListView { // Scrollable window
        id: listview
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: statusRow.top
        anchors.bottomMargin: 5

        clip: true
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: listview.width
                height: listview.height
                radius: Appearance.rounding.normal
            }
        }

        popup: false
    }

    // Placeholder when list is empty
    Item {
        anchors.fill: listview

        visible: opacity > 0
        opacity: (Notifications.list.length === 0) ? 1 : 0


        ColumnLayout {
            anchors.centerIn: parent
            spacing: 5

            StyledMaterialSymbol {
                Layout.alignment: Qt.AlignHCenter
                size: 55
                color: Appearance.colors.colOutline
                text: "notifications_active"
            }
            StyledText {
                Layout.alignment: Qt.AlignHCenter
                font.pixelSize: Appearance.font.pixelSize.normal
                color: Appearance.colors.colOutline
                horizontalAlignment: Text.AlignHCenter
                text: Translation.tr("No notifications")
            }
        }
    }

    Item {
        id: statusRow
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Layout.fillWidth: true
        implicitHeight: Math.max(
            controls.implicitHeight,
            statusText.implicitHeight
        )

        StyledText {
            id: statusText
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 10
            horizontalAlignment: Text.AlignHCenter
            text: Translation.tr("%1 notifications").arg(Notifications.list.length)

            opacity: Notifications.list.length > 0 ? 1 : 0
            visible: opacity > 0
            Behavior on opacity {
                animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
            }
        }
        RowLayout {
            id: controls 
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 5
            ActionButton {
                colBackground: Appearance.colors.colSurfaceContainer
                colBackgroundHover: Appearance.colors.colPrimaryHover
                buttonRadius: Appearance.rounding.normal
                buttonText: Translation.tr("Clear")
                onClicked: () => {
                    Notifications.discardAllNotifications()
                }
            }
        }
    }
}