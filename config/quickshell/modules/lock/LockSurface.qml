import qs 
import qs.configs
import qs.widgets
import qs.utils
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
        anchors.topMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
        colBackground: "transparent"
        spacing: 0

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: Time.date
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
        anchors.bottomMargin: 40   // deja espacio para el password
        anchors.horizontalCenter: parent.horizontalCenter
        colBackground: "transparent"
        spacing: 10

        ClippingRectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 40
            height: 40
            color: "transparent"
            radius: Appearance.rounding.full 

            Image {
                source: Qt.resolvedUrl(
                    Quickshell.shellPath("assets/") + "avatar.jpg"
                )
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
            text: "Qu4s4r"
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: "Touch ID or Enter Password"
            color: "#aaaaaa"

            visible: root.context.currentText.length === 0
        }

    }

    /* =======================
       PASSWORD ISLAND (TUYA)
       ======================= */
    Item {
        id: mainIsland 
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20

        implicitWidth: mainIslandLayout.implicitWidth
        implicitHeight: mainIslandLayout.implicitHeight

        visible: root.context.currentText.length > 0
        RowLayout {
            id: mainIslandLayout
            anchors.margins: 8
            spacing: 4

            TextField {
                id: passwordBox
                Layout.fillHeight: true
                implicitWidth: 200
                padding: 10
                clip: true
                focus: true

                placeholderText: root.context.showFailure && text.length === 0
                    ? Translation.tr("Incorrect password")
                    : Translation.tr("Password")

                placeholderTextColor: Appearance.colors.colOutline
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                color: Appearance.colors?.colOnSurface ?? "white"
                font.pixelSize: Appearance.font.pixelSize.small

                enabled: !root.context.unlockInProgress
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhSensitiveData

                onTextChanged: root.context.currentText = text
                onAccepted: root.context.tryUnlock()

                background: Rectangle {
                    color: Appearance.colors.colSurfaceContainer
                    radius: Appearance.rounding.full
                }

                Connections {
                    target: root.context
                    function onCurrentTextChanged() {
                        passwordBox.text = root.context.currentText
                    }
                }

                Keys.onPressed: root.context.resetClearTimer()
            }

            ActionButton {
                implicitHeight: parent.height
                implicitWidth: Layout.preferredHeight
                colBackground: Appearance.colors?.colPrimary ?? "#0078d7"
                buttonRadius: Appearance.rounding.full
                onClicked: root.context.tryUnlock()

                contentItem: StyledMaterialSymbol {
                    anchors.centerIn: parent
                    size: 24
                    text: "arrow_right_alt"
                    color: Appearance.colors?.colSurfaceContainer ?? "white"
                }
            }
        }
    }

    /* =======================
       COMPONENTS (TAL CUAL)
       ======================= */
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
                color: "white"
            }
        }
    }
}
