import { App } from "astal/gtk3"
import style from "./style.scss"

//import Bar from "./components/bar/Bar"
import BarTop from "./components/bar/BarTop"
import BarLeft from "./components/bar/BarLeft"
import CornerScreenTop from "./components/corners/CornerScreenTop"
import CornerScreenBottom from "./components/corners/CornerScreenBottom"
import OSD from "./components/osd/OSD"
/*
import Time from "./components/clock/Time"
*/
//import NotificationPopups from "./components/notificationsAylur/NotificationPopups"
import { ToggleWindow } from "./utils/windows"

// -------Alerts-----
import { visibleVol } from "./utils/initvars"

// --------Panels---------

import SideBar from "./components/sidebar/Sidebar"
import { sidebarWindowName, visibleSideBar } from "./components/sidebar/Sidebar"

import Media from "./components/media/Media"
import { mediaWindowName, visibleMedia } from "./components/media/Media"


import Hack from "./components/hack/Hack"
import { hackWindowName, visibleHack } from "./components/hack/Hack"

import ScreenShot from "./components/screenshot/Screenshot"
import { screenshotWindowName, visibleScreenshot } from "./components/screenshot/Screenshot"

//import { OnVolume } from "./components/osd/VolumeOsd"
//import { OnUpdate } from "./components/update/Update"



// --------Icons---------
App.add_icons("./assets")
App.add_icons("./assets/cornerscreen")
App.add_icons("./assets/img")
App.start({
    css: style,
    instanceName: "js",
    iconTheme: "Papirus",
    main: () => {
        BarLeft(null)
        
        //CornerScreenTop(null)
        //CornerScreenBottom(null)
        
        SideBar(null)
        Media(null)
        Hack(null)
        ScreenShot(null)
        
        //OSD(null)
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
        } else if (request === "hack"){
            ToggleWindow(hackWindowName, visibleHack)
            res("hack toggled")
        }  else if (request === "screenshot"){
            ToggleWindow(screenshotWindowName, visibleScreenshot)
            res("screenshot toggled")
        }
    },
})
