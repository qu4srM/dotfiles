import qs
import qs.configs
import qs.widgets
import qs.utils
import qs.services

import QtQuick
import QtQuick.Layouts

Rectangle {
    radius: Appearance.rounding.normal 
    color: Colors.setTransparency(Appearance.colors.colglassmorphism, 0.9)
    border.width: 1
    border.color: Colors.setTransparency("white", 0.9)

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
                color: "white"
            }
            StyledText {
                text: Translation.tr("Today")
                color: "white"
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
                        border.color: "white"
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
                        color: "white"
                        width: 200
                    }
                }
            }
        }
    }
}