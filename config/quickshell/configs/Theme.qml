pragma Singleton
pragma ComponentBehavior: Bound

import qs.utils

import QtQuick
import Quickshell
import Quickshell.Io


Singleton {
    id: root
    property string filePath: Paths.config + "/quickshell/theme.json"
    property alias options: materialOptionsJsonAdapter
    property bool ready: false

    FileView {
        path: root.filePath
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        onLoaded: root.ready = true
        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                writeAdapter();
            }
        }
        JsonAdapter {
            id: materialOptionsJsonAdapter
            property bool darkmode: true
            property bool transparent: false
            property string scheme: "material"
            property JsonObject material_colors: JsonObject {
                property color colPrimaryPaletteKeyColor: "#AD6258"
                property color colSecondaryPaletteKeyColor: "#926F6A"
                property color colTertiaryPaletteKeyColor: "#8A7444"
                property color colNeutralPaletteKeyColor: "#827472"
                property color colNeutralVariantPaletteKeyColor: "#857370"

                property color colBackground: "#1A1110"
                property color colOnBackground: "#F1DEDC"
                property color colSurface: "#1A1110"
                property color colSurfaceDim: "#1A1110"
                property color colSurfaceBright: "#423735"
                property color colSurfaceContainerLowest: "#140C0B"
                property color colSurfaceContainerLow: "#231918"
                property color colSurfaceContainer: "#271D1C"
                property color colSurfaceContainerHigh: "#322826"
                property color colSurfaceContainerHighest: "#3D3231"
                property color colOnSurface: "#F1DEDC"
                property color colSurfaceVariant: "#534341"
                property color colOnSurfaceVariant: "#D8C2BE"

                property color colInverseSurface: "#F1DEDC"
                property color colInverseOnSurface: "#392E2C"
                property color colOutline: "#A08C89"
                property color colOutlineVariant: "#534341"
                property color colShadow: "#000000"
                property color colScrim: "#000000"
                property color colSurfaceTint: "#FFB4A9"

                property color colPrimary: "#FFB4A9"
                property color colOnPrimary: "#561E17"
                property color colPrimaryContainer: "#73342C"
                property color colOnPrimaryContainer: "#FFDAD5"
                property color colInversePrimary: "#904A41"

                property color colSecondary: "#E7BDB7"
                property color colOnSecondary: "#442926"
                property color colSecondaryContainer: "#5D3F3B"
                property color colOnSecondaryContainer: "#FFDAD5"

                property color colTertiary: "#DFC38C"
                property color colOnTertiary: "#3E2E04"
                property color colTertiaryContainer: "#A68E5B"
                property color colOnTertiaryContainer: "#000000"

                property color colError: "#FFB4AB"
                property color colOnError: "#690005"
                property color colErrorContainer: "#93000A"
                property color colOnErrorContainer: "#FFDAD6"

                property color colPrimaryFixed: "#FFDAD5"
                property color colPrimaryFixedDim: "#FFB4A9"
                property color colOnPrimaryFixed: "#3B0906"
                property color colOnPrimaryFixedVariant: "#73342C"

                property color colSecondaryFixed: "#FFDAD5"
                property color colSecondaryFixedDim: "#E7BDB7"
                property color colOnSecondaryFixed: "#2C1512"
                property color colOnSecondaryFixedVariant: "#5D3F3B"

                property color colTertiaryFixed: "#FCDFA6"
                property color colTertiaryFixedDim: "#DFC38C"
                property color colOnTertiaryFixed: "#251A00"
                property color colOnTertiaryFixedVariant: "#574419"

                property color colSuccess: "#B5CCBA"
                property color colOnSuccess: "#213528"
                property color colSuccessContainer: "#374B3E"
                property color colOnSuccessContainer: "#D1E9D6"
            }
            property JsonObject term_colors: JsonObject {
            }
        }
    }
}
