import "root:/"
import "root:/modules/common/"
import "root:/modules/sidebar" as Sidebar
import "root:/modules/drawers/shapes/" as Shapes
import "root:/modules/dashboard/" as Dashboard
import "root:/modules/overview/" as Overview
import "root:/modules/background/" as Backgrounds

import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell

Shape {
    id: root

    required property Panels panels

    anchors.fill: parent 
    preferredRendererType: Shape.CurveRenderer

    /*
    Dashboard.Background {
        id: dashboardBackground
        component: panels.dashboard

        startX: (root.width - panels.dashboard.implicitWidth) / 2 - rounding
        startY: 0
    }*/
    Overview.Background {
        id: overviewBackground
        component: panels.overview

        startX: (root.width - panels.overview.implicitWidth) / 2 - rounding
        startY: 0
    }
    
    Backgrounds.WallSelectorBackground {
        id: wallBackground
        component: panels.wallSelector

        startX: (root.width - panels.wallSelector.implicitWidth) / 2 - rounding
        startY: root.height
    }
    /*
    Shapes.Top { // Good
        id: notch
        w: GlobalStates.hackOpen ? Appearance.sizes.notchHackWidth - Appearance.rounding.small : Appearance.sizes.notchWidth
        h: GlobalStates.hackOpen ? Appearance.sizes.notchHackHeight - Appearance.rounding.small: 0

        rounding: GlobalStates.hackOpen ? Appearance.rounding.small : 0

        startX: parent.width / 2 + (w/2) + rounding * 2
        startY: 0
    }

    
    Shapes.TopOut { // Good
        id: notch
        w: Appearance.sizes.notchWidth
        h: GlobalStates.notchSettingsOpen ? Appearance.sizes.notchSettingsHeight : 0

        rounding: GlobalStates.notchSettingsOpen ? Appearance.rounding.small : 0

        startX: parent.width / 2 + (w/2)
        startY: 0

    }
    
    
    Shapes.Right { // Good
        w: 5
        h: 50
        rounding: 10

        startX: parent.width - w - rounding
        startY: parent.height / 2 - h
    }
    
    
    Shapes.Left { // Good
        w: 5
        h: 50
        rounding: 10

        startX: 0 + rounding
        startY: parent.height / 2 - h
    }
    Shapes.TopLeft { // Good
        w: 50
        h: 5
        rounding: 10

        startX: 0
        startY: 0
    }
    Shapes.TopRight { // Good
        w: 50
        h: 5
        rounding: 10

        startX: parent.width - w - (rounding * 3)
        startY: 0
    }
    Shapes.Bottom { // Good
        w: 50
        h: 5
        rounding: 10

        startX: parent.width / 2 - (w/2)
        startY: parent.height - h - (rounding * 2)
    }
    Shapes.BottomLeft { // Good
        w: 50
        h: 5
        rounding: 10

        startX: rounding
        startY: parent.height - h - (rounding * 2)
    }
    Shapes.BottomRight { // Good
        w: 50
        h: 5
        rounding: 10

        startX: parent.width - rounding
        startY: parent.height - h - (rounding * 2)
    }
    */
}
