import qs.utils
import qs.configs
import QtQuick
import QtQuick.Controls

/**
 * Material 3 styled SpinBox component.
 */
SpinBox {
    id: root

    property real baseHeight: 35
    property real radius: Appearance.rounding.small
    property real innerButtonRadius: Appearance.rounding.unsharpen
    editable: true

    opacity: root.enabled ? 1 : 0.4

    background: Rectangle {
        color: Appearance.colors.colOnSecondary
        radius: root.radius
    }

    contentItem: Item {
        implicitHeight: root.baseHeight
        implicitWidth: Math.max(labelText.implicitWidth, 40)

        StyledTextInput {
            id: labelText
            anchors.centerIn: parent
            text: root.value // displayText would make the numbers weird like 1,000 instead of 1000
            color: Appearance.colors.colText
            font.pixelSize: Appearance.font.pixelSize.small
            validator: root.validator
            onTextChanged: {
                root.value = parseFloat(text);
            }
        }
    }

    down.indicator: Rectangle {
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
        }
        implicitHeight: root.baseHeight
        implicitWidth: root.baseHeight
        topLeftRadius: root.radius
        bottomLeftRadius: root.radius
        topRightRadius: root.innerButtonRadius
        bottomRightRadius: root.innerButtonRadius

        color: root.down.pressed ? Appearance.colors.colSecondaryActive : 
            root.down.hovered ? Appearance.colors.colSecondaryHover : 
            Appearance.colors.colSecondaryContainer
        Behavior on color {
            animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
        }

        StyledMaterialSymbol {
            anchors.centerIn: parent
            text: "remove"
            size: 20
            color: Appearance.colors.colOnSecondary
        }
    }

    up.indicator: Rectangle {
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
        }
        implicitHeight: root.baseHeight
        implicitWidth: root.baseHeight
        topRightRadius: root.radius
        bottomRightRadius: root.radius
        topLeftRadius: root.innerButtonRadius
        bottomLeftRadius: root.innerButtonRadius

        color: root.up.pressed ? Appearance.colors.colSecondaryActive : 
            root.down.hovered ? Appearance.colors.colSecondaryHover : 
            Appearance.colors.colSecondaryContainer
        Behavior on color {
            animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
        }

        StyledMaterialSymbol {
            anchors.centerIn: parent
            text: "add"
            size: 20
            color: Appearance.colors.colOnSecondary
        }
    }
}