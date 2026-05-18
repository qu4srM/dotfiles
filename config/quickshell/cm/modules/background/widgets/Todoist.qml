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
        source: "todoist-symbolic"
    }
    RowLayout {
        anchors.fill: parent 
        Column {
            width: 40
            Layout.alignment: Qt.AlignBottom || Qt.AlignLeft 
            Layout.margins: 10
            StyledText {
                text: TodoistData.list.length ?? "0"
                font.pixelSize: Appearance.font.pixelSize.huge
                font.weight: Appearance.font.weight.medium
                color: Config.options.bar.showBackground ? Appearance.colors.colText : "white"
            }
            StyledText {
                text: Translation.tr("Today")
                color: Config.options.bar.showBackground ? Appearance.colors.colText : "white"
            }
        }
        Column {
            Layout.fillHeight: true 
            Layout.fillWidth: true
            Layout.margins: 10
            spacing: 6

            Repeater {
                model: TodoistData.list

                Row {
                    id: row
                    required property var modelData
                    spacing: 6

                    Rectangle {
                        id: checkbox

                        width: 16
                        height: 16
                        radius: Appearance.rounding.full
                        border.width: 1
                        border.color: Config.options.bar.showBackground ? Appearance.colors.colOutline : "white"
                        color: row.modelData.checked ? "green" : "transparent"

                        MouseArea {
                            anchors.fill: parent
                            onClicked: TodoistData.completeTask(row.modelData.id)
                        }
                    }
                    StyledText {
                        anchors.verticalCenter: parent.verticalCenter
                        text: row.modelData.content
                        elide: Text.ElideRight
                        color: Config.options.bar.showBackground ? Appearance.colors.colText : "white"
                        width: 200
                    }
                }
            }
        }
    }
}