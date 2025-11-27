import qs
import qs.configs
import qs.widgets 
import qs.utils 
import qs.services

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ContainerRectangle {
    id: root 

    implicitHeight: parent.height - Appearance.margins.panelMargin * 2
    implicitWidth: rowLayout.implicitWidth + Appearance.margins.panelMargin * 2

    RowLayout {
        id: rowLayout 
        anchors.centerIn: parent
        spacing: Appearance.margins.panelMargin
        StyledText {
            Layout.alignment: Qt.AlignHCenter
            property int maxChars: 20

            text: {
                let t = (Players.active?.trackTitle ?? qsTr("No media")) || qsTr("Unknown title")
                return t.length > maxChars ? t.substring(0, maxChars) + "…" : t
            }
        }

        ActionButtonIcon {
            Layout.alignment: Qt.AlignVCenter
            colBackground: Config.options.bar.showBackground ? Appearance.colors.colPrimary : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
            colBackgroundHover: Config.options.bar.showBackground ? Appearance.colors.colPrimaryHover : Colors.setTransparency(Appearance.colors.colglassmorphism, 0.6)
            buttonRadius: Appearance.rounding.full
            implicitHeight: iconSize + 8
            iconMaterial: Players.active?.isPlaying ? "pause" : "play_arrow"
            iconSize: 20
            releaseAction: () => Players.active?.togglePlaying()
        }

        ActionButtonIcon {
            Layout.alignment: Qt.AlignVCenter
            colBackground: Appearance.colors.colSurfaceContainerHigh
            colBackgroundHover: Appearance.colors.colSurfaceContainerHigh
            buttonRadius: Appearance.rounding.full
            implicitHeight: iconSize + 8
            iconMaterial: "skip_next"
            iconSize: 18
            releaseAction: () => Players.active?.next()
        }
    }
}