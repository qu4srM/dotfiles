import qs
import qs.configs
import qs.configs.utils
import qs.widgets 

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import Quickshell.Io
import Quickshell


Rectangle {
    id: root
    property string commandToggle: ""
    property string icon: ""
    property string cmd: ""
    property string text: ""

    property bool toggled: false
    property var releaseAction
    property var onClicked


    color: Config.options.bar.showBackground 
        ? mouseArea.containsMouse ? Appearance.colors.colSurfaceContainerHighestHover : Appearance.colors.colSurfaceContainerHigh
        : mouseArea.containsMouse ? Appearance.colors.colGlassHover : Appearance.colors.colGlass

    Layout.fillWidth: true
    implicitHeight: 50
    radius: Appearance.rounding.normal
    RectangleRing {
        id: box
        anchors.fill: parent 
        radius: parent.radius
        source: ShaderEffectSource {
            anchors.fill: parent 
            sourceRect: Qt.rect(0,0,200,400)
            hideSource: true
            live: false
            visible: true
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 6
        spacing: 4
        z: 10
        
        ActionButtonIcon {
            implicitHeight: parent.height - 10
            implicitWidth: parent.height - 10
            Layout.alignment: Qt.AlignVCenter
            colBackground: root.toggled || root.text != "none" ? Appearance.colors.colPrimary : Colors.setTransparency(Appearance.colors.colSurfaceContainer, 0.8)
            colBackgroundHover: Appearance.colors.colPrimaryActive
            iconMaterial: root.icon
            iconSize: 20
            buttonRadiusTopLeft: 8
            buttonRadiusTopRight: 8
            buttonRadiusBottomLeft: 8
            buttonRadiusBottomRight: 8
            onPressed: {
                root.onClicked()
            }

            StyledToolTip {
                content: root.toggled ? root.text + " On" : root.text + " Off"
            }
        }

        StyledText {
            text: root.text
        }
    } 


    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.releaseAction()
    }
    Behavior on color {
        ColorAnimation {
            duration: 300
            easing.type: Easing.InOutQuad
        }
    }
}
