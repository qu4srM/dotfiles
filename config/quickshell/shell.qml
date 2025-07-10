//@pragma IconTheme Papirus

import "modules"
import "modules/drawers/"
import "modules/bar/"
import "modules/dock/"
import "modules/sidebar/"
import "widgets"
import "services"


import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import Quickshell


ShellRoot {
    property bool enableBar: true
    property bool enableDock: true
    property bool enableSidebarRight: true
    Drawers {}
    LazyLoader { active: enableBar; component: Bar {} }
    LazyLoader { active: enableDock; component: Dock {} }
    LazyLoader { active: enableSidebarRight; component:  SidebarRight{} }


}
