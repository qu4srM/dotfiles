import qs 
import qs.configs
import qs.widgets
import qs.utils
import qs.services

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Services.UPower

MouseArea {
    id: root
    required property LockContext context
    property bool active: false
    property bool showInputField: active || context.currentText.length > 0

    function forceFieldFocus() {
        passwordBox.forceActiveFocus();
    }

    Connections {
        target: context
        function onShouldReFocus() {
            forceFieldFocus();
        }
    }

    hoverEnabled: true
    acceptedButtons: Qt.LeftButton
    onPressed: mouse => {
        forceFieldFocus();
    }
    onPositionChanged: mouse => {
        forceFieldFocus();
    }
    Component.onCompleted: {
        forceFieldFocus();
    }

    Keys.onPressed: event => {
        root.context.resetClearTimer();
        if (event.key === Qt.Key_Escape) { // Esc to clear
            root.context.currentText = "";
        }
        forceFieldFocus();
    }
    

    /*
    
    Rectangle {
        anchors.fill: parent 
        anchors.margins: 90
        color: "black"
        RowLayout {
            anchors.fill: parent
            spacing: 30
            Rectangle {
                implicitWidth: parent.width / 2 - 30 / 2
                implicitHeight: parent.height
                color: "#111111"
                radius: Appearance.rounding.normal
                StyledText {
                    anchors.left: parent.left 
                    anchors.bottom: parent.bottom 
                    anchors.margins: 20 
                    text: Time.meridiem
                    color: "white"
                    font.pixelSize: 50

                }
                StyledText {
                    anchors.centerIn: parent 
                    text: Time.hour
                    color: "white"
                    font.pixelSize: parent.implicitHeight - 100
                }
            }
            Rectangle {
                implicitWidth: parent.width / 2 - 30 / 2
                implicitHeight: parent.height
                color: "#111111"
                radius: Appearance.rounding.normal
                StyledText {
                    anchors.centerIn: parent 
                    text: Time.minutes
                    color: "white"
                    font.pixelSize: parent.implicitHeight - 100
                }
            }   
        }
        
    }
    */
    Item {
        id: mainIsland 
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom

        implicitWidth: 200
        implicitHeight: 60
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: root.showInputField ? 20 : - height
        }
        Behavior on anchors.bottomMargin {
            animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
        }
        RowLayout {
            id: toolbarLayout
            anchors {
                fill: parent
                margins: 8
            }
            spacing: 4
            TextField {
                id: passwordBox
                placeholderText: root.context.showFailure && passwordBox.text.length == 0 ? Translation.tr("Incorrect password") : Translation.tr("Enter password")
                placeholderTextColor: Appearance.colors.colOutline

                Layout.fillHeight: true
                implicitWidth: 200
                padding: 10
                clip: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                focus: true
                onFocusChanged: if (!focus) root.forceFieldFocus()

                color: Appearance.colors?.colOnSurface ?? "white"
                font.pixelSize: Appearance.font.pixelSize.small
                renderType: Text.NativeRendering
                selectedTextColor: Appearance.colors.colOnSecondaryContainer
                selectionColor: Appearance.colors.colSecondaryContainer

                // Password
                enabled: !root.context.unlockInProgress
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhSensitiveData

                // Synchronizing (across monitors) and unlocking
                onTextChanged: root.context.currentText = this.text
                onAccepted: root.context.tryUnlock()
                

                background: Rectangle {
                    color: Appearance.colors.colSurfaceContainer
                    radius: Appearance.rounding.full
                }

                Connections {
                    target: root.context
                    function onCurrentTextChanged() {
                        passwordBox.text = root.context.currentText;
                    }
                }
                Keys.onPressed: event => {
                    root.context.resetClearTimer();
                }
            }
            ActionButton {
                implicitHeight: parent.height
                implicitWidth: Layout.preferredHeight
                colBackground: Appearance.colors?.colPrimary ?? "#0078d7"
                onClicked: root.context.tryUnlock()
                buttonRadius: Appearance.rounding.full

                contentItem: StyledMaterialSymbol {
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    size: 24
                    text: "arrow_right_alt"
                    color: Appearance.colors?.colSurfaceContainer ?? "white"
                }
            }
            
        }

    }
}
