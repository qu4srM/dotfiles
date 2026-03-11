import qs
import qs.services
import qs.configs
import qs.utils
import qs.widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

Item {
    id: root
    property real baseHeight: 40
    property real maxListHeight: 500
    property bool show: false
    signal dismiss()

    visible: show
    enabled: show
    
    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_Escape) {
            root.dismiss();
            event.accepted = true;
        }
    }
    MouseArea {
        anchors.fill: parent
        onPressed: (mouse) => {
            if (!background.contains(mapToItem(background, mouse.x, mouse.y))) {
                root.dismiss()
            }
        }
    }

    Rectangle {
        id: background
        anchors.top: parent.top 
        anchors.left: parent.left 
        anchors.right: parent.right
        anchors.topMargin: Appearance.margins.panelMargin
        anchors.rightMargin: Appearance.margins.panelMargin + 60
        anchors.leftMargin: Appearance.margins.panelMargin
        implicitHeight: columnLayout.implicitHeight + 20
        color: Config.options.bar.showBackground ? Appearance.colors.colBackground : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
        radius: Appearance.rounding.small
        visible: opacity > 0 
        opacity: root.show ? 1 : 0

    }


    ColumnLayout {
        id: columnLayout
        anchors.left: background.left 
        anchors.right: background.right
        anchors.margins: 10
        anchors.verticalCenter: background.verticalCenter
        
        
        StyledSwitchText {
            Layout.fillWidth: true
            implicitHeight: 40
            text: Translation.tr("Internet")
            checked: Network.wifiEnabled
            colBackground: "transparent"
            colBackgroundHover: "transparent"
            onCheckedChanged: {
                Network.enableWifi(checked)
            }
        }
        
        

        Rectangle {
            Layout.fillWidth: true 
            implicitHeight: 1
            color: "white"
        }
        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            height: 30 
            StyledText {
                text: Network.networkName
            }
        }
        Rectangle {
            Layout.fillWidth: true 
            implicitHeight: 1
            color: "white"
        }

        ListView {
            id: list 
            Layout.fillWidth: true 
            implicitHeight: Math.min(contentHeight, root.maxListHeight)
            clip: true 
            spacing: 0
            model: Network.wifiNetworks
            delegate: Rectangle {
                id: item
                required property var modelData
                

                property bool askingPassword: false
                property string password: ""

                width: parent.width
                implicitHeight: column.implicitHeight + 15

                color: mouseArea.containsMouse ? Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9) : "transparent"
                radius: Appearance.rounding.unsharpenmore


                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: {

                        // Si no tiene seguridad → conectar directo
                        if (!item.modelData.security || item.modelData.security === "--") {
                            Network.connect(item.modelData.ssid)
                            return
                        }

                        // Si tiene seguridad → mostrar password
                        item.askingPassword = !item.askingPassword
                    }
                }

                ColumnLayout {
                    id: column
                    width: parent.width - 20 
                    anchors.centerIn: parent

                    RowLayout {
                        width: parent.width

                        StyledText {
                            Layout.fillWidth: true
                            text: item.modelData.ssid
                            color: "white"
                            elide: Text.ElideRight
                        }

                        CustomIcon {
                            size: 18
                            source: item.modelData.security ? "candado" : "wifi"
                        }
                    }

                    /* PASSWORD PROMPT */

                    ColumnLayout {
                        visible: item.askingPassword
                        Layout.fillWidth: true
                        spacing: 6

                        TextField {
                            id: passwordField
                            Layout.fillWidth: true
                            placeholderText: "Password"
                            echoMode: TextInput.Password

                            onAccepted: {
                                Network.connect(item.modelData.ssid, text)
                                item.askingPassword = false
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true

                            Item { Layout.fillWidth: true }

                            ActionButton {
                                colBackground: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                                colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colsecondary_hover : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                                implicitHeight: 40
                                buttonText: "Cancel"
                                buttonRadius: Appearance.rounding.small
                                changeColor: true 
                                textColor: "white"
                                onClicked: {
                                    item.askingPassword = false
                                    passwordField.text = ""
                                }
                            }
                            ActionButton {
                                colBackground: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
                                colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colsecondary_hover : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
                                implicitHeight: 40
                                buttonText: "Connect"
                                buttonRadius: Appearance.rounding.small
                                changeColor: true 
                                textColor: "white"
                                onClicked: {
                                    Network.connect(item.modelData.ssid, passwordField.text)
                                    item.askingPassword = false
                                }
                            }
                        }
                    }
                }
            }
        
        }
    }
}