import qs
import qs.configs
import qs.configs.utils
import qs.widgets
import qs.services

import QtQuick
import QtQuick.Layouts

DiagonalContainer {
    color: Config.options.bar.showBackground ? Appearance.colors.colBackground : Appearance.colors.colGlass
    borderWidth: 1
    borderColor: Appearance.colors.colGlassBorder

    CustomIcon { 
        anchors.top: parent.top
        anchors.left: parent.left 
        anchors.margins: 10
        source: "calendar-symbolic"
    }

    RowLayout {
        id: rowLayout
        anchors.fill: parent


        Column {
            width: 50
            Layout.alignment: Qt.AlignBottom | Qt.AlignLeft
            Layout.margins: 10

            StyledText {
                text: CalendarData.today
                font.pixelSize: Appearance.font.pixelSize.huge
                font.weight: Appearance.font.weight.medium
                color: Config.options.bar.showBackground ? Appearance.colors.colText : "white"
            }

            StyledText {
                text: CalendarData.month
                color: Config.options.bar.showBackground ? Appearance.colors.colText : "white"
            }
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 10
            spacing: 6
            clip: true
            model: CalendarData.events
            delegate: Rectangle {
                id: block
                required property var modelData
                width: parent.width
                height: column.implicitHeight + 10
                color: modelData.color
                radius: Appearance.rounding.small
                Column {
                    id: column
                    anchors.fill: parent
                    anchors.margins: 6
                    spacing: 2
                    StyledText {
                        text: block.modelData.title
                        elide: Text.ElideRight
                        color: "white"
                        width: 200
                    }
                    
                    Row {
                        spacing: 4
                        StyledText {
                            text:
                                block.modelData.start.slice(0,2) + ":" +
                                block.modelData.start.slice(2,4)
                            color: "white"
                            font.pixelSize: Appearance.font.pixelSize.small
                        }
                        StyledText {
                            text:"a"
                            color: "white"
                            font.pixelSize: Appearance.font.pixelSize.small
                        }
                        

                        StyledText {
                            text:
                                block.modelData.end.slice(0,2) + ":" +
                                block.modelData.end.slice(2,4)
                            color: "white"
                            font.pixelSize: Appearance.font.pixelSize.small
                        }
                    }

                }
            }
            
        }
    }
}