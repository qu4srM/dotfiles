import "root:/"
import "root:/modules/common/"
import "root:/modules/sidebar" as Sidebar
import "root:/modules/drawers/shapes/" as Shapes

import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell

Shape {
    id: root
    
    required property real marginBorder

    anchors.fill: parent 
    anchors.margins: 0
    preferredRendererType: Shape.CurveRenderer

    Shapes.Top { // Good
        id: notch
        w: GlobalStates.notchOpen ?  Appearance.sizes.notchWidthExtended: Appearance.sizes.notchWidth
        h: GlobalStates.notchOpen ? Appearance.sizes.notchHeightExtended : Appearance.sizes.notchHeight
        rounding: 10
        colorMain: "black"

        startX: parent.width / 2 + (w/2) + rounding * 2
        startY: 0
    }
    
    /*
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
