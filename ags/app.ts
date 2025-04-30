import { App } from "astal/gtk3"
import style from "./style.scss"

import Bar from "./components/bar/Bar"
import BarTop from "./components/bar/BarTop"
import CornerScreenTop from "./components/corners/CornerScreenTop"
import CornerScreenBottom from "./components/corners/CornerScreenBottom"
/*
import OSD from "./components/osd/OSD"
import Time from "./components/clock/Time"
import NotificationPopups from "./components/notificationsAylur/NotificationPopups"
*/
//import { WindowLeft, WindowRight, WindowTop, WindowSide, WindowAlert, WindowNormal } from "./components/Windows"
//import { buttonOnCalendarPanel, buttonOnMediaPanel, buttonOnSideBar, buttonOnUpdate } from "./utils/initvars"
//import { sidebarName, mediaName, calendarName, volumeName, updateName } from "./utils/initvars"
import { ToggleWindow } from "./utils/windows"

// -------Alerts-----
import { visibleVol } from "./utils/initvars"

// --------Panel---------
import SideBar from "./components/sidebar/Sidebar"
import { sidebarWindowName } from "./components/sidebar/Sidebar"
import { visibleSideBar } from "./components/sidebar/Sidebar"

import Media from "./components/media/Media"
import { mediaWindowName } from "./components/media/Media"
import { visibleMedia } from "./components/media/Media"


import { OnVolume } from "./components/osd/VolumeOsd"
import { OnUpdate } from "./components/update/Update"



// --------Icons---------
App.add_icons("./assets")
App.add_icons("./assets/cornerscreen")


App.start({
    css: style,
    instanceName: "js",
    iconTheme: "Papirus",
    main: () => {
        BarTop(null)
        
        CornerScreenTop(null)
        CornerScreenBottom(null)
        
        SideBar(null)
        Media(null)
        
        //OSD()
        //Osd()
        //Time()
        //NotificationPopups()
    },
    requestHandler(request, res) {
        
        if (request === "sidebar"){
            ToggleWindow(sidebarWindowName, visibleSideBar)
            res("sidebar toggled")
        } else if (request === "media"){
            ToggleWindow(mediaWindowName, visibleMedia)
            res("media toggled")
        }
    },
})