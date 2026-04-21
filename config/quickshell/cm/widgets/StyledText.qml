import qs.configs
import QtQuick
import QtQuick.Layouts

Text {
    property real size
    renderType: Text.NativeRendering
    verticalAlignment: Text.AlignVCenter
    font {
        family: Appearance?.font.family.main ?? "sans-serif"
        pixelSize: Appearance?.font.pixelSize.normal ?? size
    }
    color: Config.options.bar.showBackground ? Appearance?.colors.colText ?? "black" : Appearance.colors.colOnText
}