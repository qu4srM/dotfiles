import qs.configs
import qs.widgets 
import qs.configs.utils

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Rectangle {
    color: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : "transparent"
    radius: Appearance.rounding.normal
}
