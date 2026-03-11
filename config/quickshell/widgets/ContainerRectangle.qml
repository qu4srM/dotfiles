import qs 
import qs.configs
import qs.widgets 
import qs.utils

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Rectangle {
    color: Config.options.bar.showBackground ? Appearance.colors.colSurfaceContainer : Colors.setTransparency(Appearance.colors.colglassmorphism, 1)
    radius: Appearance.rounding.normal
}
