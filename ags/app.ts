import { App } from "astal/gtk3"
import style from "./style.scss"

import Bar from "./components/bar/Bar"
import BarTop from "./components/bar/BarTop"
import CornerScreen from "./components/corners/CornerScreen"
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
        
        CornerScreen(null)
        
        SideBar(null)
        Media(null)
        
        //OSD()
        //Osd()
        //Time()
        //NotificationPopups()
        /*
        WindowSide(
            null,              // monitor (usa el principal por defecto)
            sidebarName,       // nombre de la ventana (string)
            buttonOnSideBar,   // visible (boolean)
            OnSideBar     // tu componente JSX
        )

        
        WindowRight(
            null,
            mediaName,
            buttonOnMediaPanel,
            OnMediaPanel
        )
        
        WindowAlert(
            null,
            volumeName,
            visibleVol,
            OnVolume
        )
        WindowNormal(
            null,
            updateName,
            buttonOnUpdate,
            OnUpdate
        )*/
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