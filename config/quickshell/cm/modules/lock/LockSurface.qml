import qs 
import qs.configs
import qs.configs.utils
import qs.widgets
import qs.services

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import Quickshell.Services.UPower

MouseArea {
    id: root
    required property LockContext context
    property bool active: false
    property bool showInputField: active || context.currentText.length > 0

    hoverEnabled: true
    acceptedButtons: Qt.LeftButton

    function forceFieldFocus() {
        passwordBox.forceActiveFocus()
    }

    Connections {
        target: context
        function onShouldReFocus() {
            forceFieldFocus()
        }
    }

    onPressed: forceFieldFocus()
    onPositionChanged: forceFieldFocus()

    Component.onCompleted: forceFieldFocus()

    Keys.onPressed: event => {
        root.context.resetClearTimer()
        if (event.key === Qt.Key_Escape)
            root.context.currentText = ""
        forceFieldFocus()
    }

    /* =======================
       TOP: DATE + CLOCK
       ======================= */
    ColumnContainer {
        anchors.top: parent.top
        anchors.topMargin: 70
        anchors.horizontalCenter: parent.horizontalCenter
        colBackground: "transparent"
        spacing: 0
        StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: Time.date
            font.family: Appearance.font.family.background
            font.pixelSize: 20
            color: Colors.setTransparency("white", 0.3)
        }

        Clock {
            Layout.alignment: Qt.AlignHCenter
        }
    }

    /* =======================
       BOTTOM: AVATAR + USER
       ======================= */
    ColumnContainer {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20   // deja espacio para el password
        anchors.horizontalCenter: parent.horizontalCenter
        colBackground: "transparent"
        spacing: 10

        ClippingRectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 50
            height: 50
            color: "transparent"
            radius: Appearance.rounding.full 

            Image {
                source: Config.options.user.avatar 
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                smooth: true
                mipmap: true
                antialiasing: true
                asynchronous: true
                cache: false
            }
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: Config.options.user.nickname
        }
        Rectangle {
            id: box
            visible: root.context.currentText.length
            implicitWidth: layout.implicitWidth
            implicitHeight: layout.implicitHeight
            color: Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
            radius: Appearance.rounding.unsharpenmore + 4
            RowLayout {
                id: layout
                TextField {
                    id: passwordBox
                    Layout.fillHeight: true
                    implicitWidth: 170
                    padding: 10
                    clip: true
                    focus: true

                    placeholderText: root.context.showFailure && text.length === 0
                        ? Translation.tr("Incorrect password")
                        : Translation.tr("Password")

                    placeholderTextColor: Appearance.colors.colOnText
                    verticalAlignment: TextInput.AlignVCenter
                    color: "white"
                    font.pixelSize: Appearance.font.pixelSize.small

                    enabled: !root.context.unlockInProgress
                    echoMode: TextInput.Password
                    inputMethodHints: Qt.ImhSensitiveData

                    onTextChanged: root.context.currentText = text
                    onAccepted: root.context.tryUnlock()

                    background: null


                    Connections {
                        target: root.context
                        function onCurrentTextChanged() {
                            passwordBox.text = root.context.currentText
                        }
                    }

                    Keys.onPressed: root.context.resetClearTimer()
                }

                ActionButton {
                    Layout.fillHeight: true 
                    Layout.margins: 4
                    implicitWidth: implicitHeight
                    colBackground: "transparent"
                    colBackgroundHover: Colors.setTransparency(Appearance.colors.colglassmorphism, 0.7)
                    buttonRadius: Appearance.rounding.unsharpenmore
                    onClicked: root.context.tryUnlock()

                    contentItem: StyledMaterialSymbol {
                        anchors.centerIn: parent
                        size: 24
                        text: "arrow_right_alt"
                        color: "white"
                    }
                }
            }

        }


        StyledText {
            Layout.preferredHeight: box.implicitHeight
            Layout.alignment: Qt.AlignHCenter
            text: "Touch ID or Enter Password"
            color: "#aaaaaa"

            visible: root.context.currentText.length === 0
        }

    }

    Item {
        anchors.bottom: parent.bottom 
        anchors.right: parent.right
        anchors.margins: 10
        implicitWidth: buttonsLayout.implicitWidth
        implicitHeight: buttonsLayout.implicitHeight
        RowLayout {
            id: buttonsLayout
            spacing: 0
            PowerButton {
                iconMaterial: "coffee"
                onPressed: {
                    GlobalStates.sessionOpen = true
                }
            }
            PowerButton {
                iconMaterial: "logout"
                onPressed: {
                    GlobalStates.sessionOpen = true
                }
            }
            PowerButton {
                iconMaterial: "power_settings_new"
                onPressed: {
                    GlobalStates.sessionOpen = true
                }
            }
        }
        
    }
    /* =======================
       COMPONENTS (TAL CUAL)
       ======================= */
    component PowerButton: ActionButtonIcon {
        property string textTooltip
        implicitHeight: 40
        implicitWidth: implicitHeight
        colBackground: "transparent"
        colBackgroundHover: Colors.setTransparency(Appearance.colors.colglassmorphism, 0.7)
        buttonRadius: Appearance.rounding.unsharpenmore
        iconSize: 20
        changeColor: true 
        iconColor: "#fff"
    }

    
    component ColumnContainer: Item {
        id: columnToolBar
        property real padding: 8
        property alias colBackground: background.color
        property alias spacing: columnLayout.spacing
        default property alias data: columnLayout.data 
        property alias radius: background.radius

        implicitWidth: background.implicitWidth
        implicitHeight: background.implicitHeight

        Rectangle {
            id: background 
            anchors.fill: parent 
            color: Appearance.colors.colBackground 
            radius: height / 2

            implicitHeight: columnLayout.implicitHeight + columnToolBar.padding * 2
            implicitWidth: columnLayout.implicitWidth + columnToolBar.padding * 2

            ColumnLayout {
                id: columnLayout
                spacing: 4
                anchors.fill: parent
                anchors.margins: columnToolBar.padding
            }
        }
    }

    component Clock: Row {
        spacing: 0
        Repeater {
            model: Time.time.substring(0, 5)
            delegate: Text {
                text: modelData
                font.family: Appearance.font.family.background
                font.pixelSize: 100
                font.weight: 700
                color: Colors.setTransparency("white", 0.6)
            }
        }
    }
}
