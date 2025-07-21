import "root:/modules/common"
import QtQuick
import QtQuick.Layouts

Text {
    property real size
    renderType: Text.NativeRendering
    verticalAlignment: Text.AlignVCenter
    font {
        family: Appearance?.font.family.main ?? "sans-serif"
        pixelSize: Appearance?.font.pixelSize.smaller ?? size
        weight: Appearance?.font.weight.medium ?? 400
    }
    color: Appearance?.colors.colprimarytext ?? "black"
}