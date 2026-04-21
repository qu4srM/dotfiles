import qs.configs
import QtQuick
import QtQuick.Controls

TextInput {
    renderType: Text.NativeRendering
    selectedTextColor: "transparent" //Appearance.colors.col
    selectionColor: Appearance.colors.colSecondary
    font {
        family: Appearance?.font.family.main ?? "sans-serif"
        pixelSize: Appearance?.font.pixelSize.small ?? 15
        hintingPreference: Font.PreferFullHinting
    }
}