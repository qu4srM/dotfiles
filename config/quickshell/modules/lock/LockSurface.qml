import qs 
import qs.configs
import qs.widgets
import qs.services

import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
//import qs.modules.common.functions

MouseArea {
    id: root
    required property LockContext context
    property bool active: false
    property bool showInputField: active || context.currentText.length > 0

    function forceFieldFocus() {
        passwordBox.forceActiveFocus();
    }

    Component.onCompleted: {
        forceFieldFocus();
    }

    Connections {
        target: context
        function onShouldReFocus() {
            forceFieldFocus();
        }
    }

    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_Escape) {
            root.context.currentText = ""
        }
        forceFieldFocus();
    }

    hoverEnabled: true
    acceptedButtons: Qt.LeftButton
    onPressed: (mouse) => {
        forceFieldFocus();
    }
    onPositionChanged: (mouse) => {
        forceFieldFocus();
    }

    anchors.fill: parent

    Rectangle {
        id: passwordBoxContainer
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: root.showInputField ? 20 : -height
        }
        Behavior on anchors.bottomMargin {
            animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
        }
        radius: Appearance.rounding.full
        color: Appearance.colors.colLayer2
        implicitWidth: 160
        implicitHeight: 44

        StyledText {
            visible: root.context.showFailure && passwordBox.text.length == 0
            anchors.centerIn: parent
            text: "Incorrect"
            color: Appearance.m3colors.m3error
        }
        StyledTextInput {
            id: passwordBox

            anchors {
                fill: parent
                margins: 10
            }
            clip: true
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            focus: true
            onFocusChanged: root.forceFieldFocus();
            color: Appearance.colors.colOnLayer2
            font {
                pixelSize: 10
            }

            // Password
            enabled: !root.context.unlockInProgress
            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhSensitiveData

            // Synchronizing (across monitors) and unlocking
            onTextChanged: root.context.currentText = this.text
            onAccepted: root.context.tryUnlock()
            Connections {
                target: root.context
                function onCurrentTextChanged() {
                    passwordBox.text = root.context.currentText;
                }
            }
        }
        
    }
    ActionButton {
        anchors{
            verticalCenter: passwordBoxContainer.verticalCenter
            left: passwordBoxContainer.right
            leftMargin: 5
        }
        visible: opacity > 0
        implicitHeight: passwordBoxContainer.implicitHeight - 12
        implicitWidth: implicitHeight
        buttonRadius: passwordBoxContainer.radius
        colBackground: Appearance.colors.colprimary
        onClicked: root.context.tryUnlock()

        contentItem: StyledMaterialSymbol {
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            size: 24
            text: "arrow_right_alt"
            color: Appearance.colors.colbackground
        }
    }
}