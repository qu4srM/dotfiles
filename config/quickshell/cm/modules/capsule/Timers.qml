import qs
import qs.modules.capsule.components
import qs.configs
import qs.configs.utils
import qs.widgets
import qs.services

import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
    id: root

    implicitWidth: rowLayout.implicitWidth
    implicitHeight: rowLayout.implicitHeight

    RowLayout {
        id: rowLayout
        spacing: 8

        Pomodoro { }

        Rectangle {
            Layout.fillHeight: true
            implicitWidth: 2
            color: Appearance.colors.colSurfaceContainer
        }

        Stopwatch { }
    }
}
