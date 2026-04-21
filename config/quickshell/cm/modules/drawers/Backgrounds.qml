import qs.modules.overview as Overview
import qs.modules.launcher as Launcher
import qs.modules.background as Backgrounds

import QtQuick
import QtQuick.Shapes

Shape {
    id: root

    required property Panels panels

    anchors.fill: parent 
    preferredRendererType: Shape.CurveRenderer
    /*
    Overview.Background {
        id: overviewBackground
        component: panels.overview

        startX: (root.width - panels.overview.implicitWidth) / 2 - rounding
        startY: 0
    }*/
    Backgrounds.WallSelectorBackground {
        id: wallBackground
        component: panels.wallSelector

        startX: (root.width - panels.wallSelector.implicitWidth) / 2 - rounding
        startY: root.height
    }
    Launcher.LauncherBackground {
        id: launcherBackground
        component: panels.launcher

        startX: (root.width - panels.launcher.implicitWidth) / 2 - rounding
        startY: root.height

    }
}
