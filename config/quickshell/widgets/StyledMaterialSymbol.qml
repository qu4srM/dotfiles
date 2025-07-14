import "root:/modules/common/"

import QtQuick
import QtQuick.Layouts

Text {
    id: root 
    property real size
    property real fill
    property real truncatedFill: Math.round(fill * 100) / 100
    renderType: Text.NativeRendering

    font {
        hintingPreference: Font.PreferFullHinting
        family: Appearance?.font.family.iconMaterial ?? "Material Symbols Rounded"
        pixelSize: size
        weight: Font.Normal + (Font.DemiBold - Font.Normal) * fill
        variableAxes: { 
            "FILL": truncatedFill,
            // "wght": font.weight,
            // "GRAD": 0,
            "opsz": size,
        }
    }
    verticalAlignment: Text.AlignVCenter
    color: Appearance.colors.background
}