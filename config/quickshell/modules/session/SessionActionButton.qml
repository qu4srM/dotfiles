import qs 
import qs.configs 
import qs.widgets
import qs.utils
import QtQuick
import QtQuick.Layouts

ActionButtonIcon {
    id: button
    property string toolTipText
    property bool keyboardDown: false

    implicitHeight: 120
    implicitWidth: 120
    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
    colBackground: Config.options.bar.showBackground 
        ? button.keyboardDown ? Appearance.colors.colSecondaryHover : 
            button.focus ? Appearance.colors.colPrimary : 
            Appearance.colors.colSurfaceContainer
        : button.keyboardDown ? Colors.setTransparency(Appearance.colors.colglassmorphism, 0.7) : 
            button.focus ? Colors.setTransparency(Appearance.colors.colglassmorphism, 0.7) : 
            Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
    colBackgroundHover: Appearance.colors.colPrimaryHover
    iconSize: 45
    buttonRadius: (button.focus || button.down) ? implicitWidth / 2 : Appearance.rounding.verylarge

    Behavior on buttonRadius { 
        animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) 
    }
    Behavior on iconSize {
        animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
    }

    onHovered: () => {
        button.iconSize = 90
    }
    onUnhovered: () => {
        button.iconSize = 45
    }

    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            keyboardDown = true
            button.clicked()
            event.accepted = true;
        }
    }
    Keys.onReleased: (event) => {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            keyboardDown = false
            event.accepted = true;
        }
    }
    
    StyledToolTip {
        content: button.toolTipText
    }
}