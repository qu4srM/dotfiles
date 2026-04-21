import qs
import qs.configs
import qs.widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications

Item {
    id: root

    ColumnLayout {
        id: notifications

        NotificationServer {
            id: notifServer
            onNotification: notif => {
                notif.tracked = true;
            }
        }

        Repeater {
            model: notifServer.trackedNotifications
            delegate: Ntf {
                required property Notification modelData
                appName: modelData.appName
                appIcon: modelData.appIcon
                summary: modelData.summary
                image:   modelData.image
                body:    modelData.body
            }
        }
    }

    component Ntf: Item {
        id: ntf
        property string appName
        property string appIcon
        property string summary
        property string body
        property string image

        property bool shown: true       // 👈 controla visibilidad local

        implicitWidth:  shown ? 300 : 0
        implicitHeight: shown ? rowLayout.implicitHeight + 20 : 0
        opacity:        shown ? 1 : 0
        visible:        shown
        clip:           true

        // Oculta el popup a los 5 segundos, sin tocar la notificación
        Timer {
            interval: 5000
            running: true
            repeat: false
            onTriggered: ntf.shown = false
        }

        Behavior on opacity        { NumberAnimation { duration: 300 } }
        Behavior on implicitHeight { NumberAnimation { duration: 300 } }

        RectangleRing {
            id: box
            anchors.fill: parent
            radius: 10
            source: ShaderEffectSource {
                anchors.fill: parent
                sourceRect: Qt.rect(0, 0, 200, 400)
                hideSource: true
                live: false
                visible: true
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: ntf.shown = false   // 👈 clic también lo oculta
        }

        RowLayout {
            id: rowLayout
            anchors.top:    parent.top
            anchors.left:   parent.left
            anchors.right:  parent.right
            anchors.margins: 10

            ClippingRectangle {
                implicitWidth:  40
                implicitHeight: 40
                color: "transparent"
                radius: Appearance.rounding.full
                Image {
                    anchors.fill: parent
                    source: ntf.image
                }
                Image {
                    anchors.right:  parent.right
                    anchors.bottom: parent.bottom
                    source: Quickshell.iconPath(ntf.appIcon, true)
                    sourceSize.width:  20
                    sourceSize.height: 20
                    visible: ntf.appIcon !== ""
                    Rectangle {
                        anchors.fill: parent
                        radius: 10
                        visible: parent.status !== Image.Ready
                        color: "gray"
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true

                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: ntf.summary + " · " + ntf.appName
                    }
                }

                Text {
                    Layout.fillWidth: true
                    text: ntf.body
                    color: "white"
                    wrapMode: Text.Wrap
                    visible: ntf.body !== ""
                    opacity: 0.7
                }
            }
        }
    }
}