//@ pragma UseQApplication
//@ pragma IconTheme Papirus
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000
//@ pragma Env QT_SCALE_FACTOR=1

import "./modules/background/"
import "./modules/launcher/"
import "./modules/drawers/"
import "./modules/bar/"
import "./modules/lock/"
import "./modules/dock/"
import "./modules/sidebarright/"
import "./modules/sidebarleft/"
import "./modules/session/"
//import "./modules/notificationPopup/"


import QtQuick
import QtQuick.Window
import Quickshell


ShellRoot {
    property bool enableBackground: true
    property bool enableLauncher: true
    property bool enableBar: true
    property bool enableDrawers: true
    property bool enableOverview: true
    property bool enableDock: true
    property bool enableSidebarRight: true
    property bool enableSidebarLeft: true
    property bool enableNotificationPopup: true
    property bool enableSession: true
    property bool enableLock: true

    LazyLoader { active: enableDrawers; component: Drawers{} }
    LazyLoader { active: enableBar; component: Bar {} }
    LazyLoader { active: enableLauncher; component: Launcher {} }
    LazyLoader { active: enableDock; component: Dock {} }
    LazyLoader { active: enableSidebarRight; component:  SidebarRight{} }
    LazyLoader { active: enableSidebarLeft; component:  SidebarLeft{} }
    LazyLoader { active: enableSession; component: Session {} }
    LazyLoader { active: enableLock; component: Lock {} }
    LazyLoader { active: enableBackground; component: Background {} }
    //LazyLoader { active: enableNotificationPopup; component:  NotificationPopup{} }

}
