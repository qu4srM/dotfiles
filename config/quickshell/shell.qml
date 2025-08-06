//@pragma IconTheme Papirus

import "modules"
import "modules/background/"
import "modules/launcher/"
import "modules/drawers/"
import "modules/bar/"
import "modules/dock/"
import "modules/sidebar/"
import "modules/sidebarleft/"
//import "modules/overview/"
import "widgets"
import "services"


import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import Quickshell


ShellRoot {
    property bool enableBackground: true
    property bool enableLauncher: true
    property bool enableBar: true
    property bool enableDrawers: true
    property bool enableOverview: true
    property bool enableDock: false
    property bool enableSidebarRight: true
    property bool enableSidebarLeft: true

    LazyLoader { active: enableDrawers; component: Drawers{} }
    LazyLoader { active: enableBar; component: Bar {} }
    LazyLoader { active: enableLauncher; component: Launcher {} }
    //LazyLoader { active: enableDock; component: Dock {} }
    LazyLoader { active: enableSidebarRight; component:  SidebarRight{} }
    LazyLoader { active: enableSidebarLeft; component:  SidebarLeft{} }
    //LazyLoader { active: enableOverview; component:  Overview{} }
    LazyLoader { active: enableBackground; component: Background {} }

}
