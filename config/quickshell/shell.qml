//@pragma IconTheme Papirus

import "modules"
import "modules/background/"
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
    property bool enableBackground: true
    property bool enableBar: true
    property bool enableDrawers: true
    property bool enableDock: false
    property bool enableSidebarRight: true

    LazyLoader { active: enableDrawers; component: Drawers{} }
    LazyLoader { active: enableBar; component: Bar {} }
    //LazyLoader { active: enableDock; component: Dock {} }
    LazyLoader { active: enableSidebarRight; component:  SidebarRight{} }
    LazyLoader { active: enableBackground; component: Background {} }

}
