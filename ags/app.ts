import { App } from "astal/gtk3"
import style from "./style.scss"
import Bar from "./components/bar/Bar"
import CornerScreen from "./components/corners/CornerScreen"
import OSD from "./components/osd/OSD"
import Time from "./components/clock/Time"
import NotificationPopups from "./components/notificationsAylur/NotificationPopups"

import { WindowLeft, WindowRight, WindowTop, WindowSide, WindowAlert } from "./components/Windows"
import { buttonOnCalendarPanel, buttonOnMediaPanel, buttonOnSideBar } from "./utils/initvars"
import { sidebarName, mediaName, calendarName, volumeName } from "./utils/initvars"

// -------Alerts-----
import { visibleVol } from "./utils/initvars"

// --------Panel---------
import { OnSideBar } from "./components/sidebar/Sidebar"
import { OnMediaPanel } from "./components/media/Media"
import { OnVolume } from "./components/osd/VolumeOsd"

// --------Icons---------
App.add_icons("./assets")
App.add_icons("./assets/cornerscreen")


App.start({
    css: style,
    instanceName: "js",
    iconTheme: "Papirus",
    requestHandler(request, res) {
        print(request)
        res("ok")
    },
    main: () => {
        Bar()

        
        //CalendarPanel()
        CornerScreen()
        OSD()
        //Osd()
        //Time()
        NotificationPopups()
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
    },
})