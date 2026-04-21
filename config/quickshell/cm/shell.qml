//@ pragma UseQApplication
//@ pragma IconTheme MacTahoe-dark
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000
//@ pragma Env QT_SCALE_FACTOR=1

import "services"
import "modules/background/"
import "modules/launcher/"
import "modules/sticks/"
import "modules/drawers/"
import "modules/bar/"
import "modules/overview2/"
import "modules/capsule/"
import "modules/lock/"
import "modules/dock/"
import "modules/osd/"
import "modules/sidebarright/"
import "modules/session/"
//import "./modules/notificationPopup/"
import "modules/screenCorners"


import QtQuick
import QtQuick.Window
import Quickshell


ShellRoot {
    property bool enableBackground: true
    property bool enableLauncher: true
    property bool enableVolumenOsd: true
    property bool enableSticks: true
    property bool enableBar: true
    property bool enableCapsule: true
    property bool enableDrawers: true
    property bool enableOverview: true
    property bool enablePrototype: true
    property bool enableDock: true
    property bool enableSidebarRight: true
    property bool enableNotificationPopup: true
    property bool enableSession: true
    property bool enableLock: true
    property bool enableScreenCorners: true

    //LazyLoader { active: enableDrawers; component: Drawers{} }
    LazyLoader { active: enableScreenCorners; component: ScreenCorners {} }
    LazyLoader { active: enableBar; component: Bar {} }
    LazyLoader { active: enableCapsule; component: Capsule {} }
    //LazyLoader { active: enableLauncher2; component: Launcher2 {} }
    LazyLoader { active: enableLauncher; component: Launcher {} }
    LazyLoader { active: enableDock; component: Dock {} }
    LazyLoader { active: enableSidebarRight; component:  SidebarRight{} }
    LazyLoader { active: enableSession; component: Session {} }
    LazyLoader { active: enableLock; component: Lock {} }
    LazyLoader { active: enableBackground; component: Background {} }
    //LazyLoader { active: enableSticks; component: Sticks {} }
    LazyLoader { active: enableVolumenOsd; component: Osd {} }
    LazyLoader { active: enableOverview; component: Overview {} }

    //LazyLoader { active: enableNotificationPopup; component:  NotificationPopup{} }
    

}
