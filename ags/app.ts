import { App } from "astal/gtk3"
import style from "./style.scss"
import Bar from "./widget/Bar"
import CornerScreen from "./widget/CornerScreen"
import OSD from "./widget/OSD"
import Time from "./widget/Time"
import NotificationPopups from "./components/notificationsAylur/NotificationPopups"
import { Charging } from "./widget/Bar"
import Osd from "./components/osd/Osd"
import { CalendarPanel } from "./widget/Bar"
import { WindowLeft, WindowRight, WindowTop, WindowSide } from "./components/Windows"
import { buttonOnCalendarPanel, buttonOnMediaPanel, buttonOnSideBar } from "./hooks/initvars"
import { sidebarName, mediaName, calendarName } from "./hooks/initvars"

// --------Panels--------
import { OnSideBar } from "./components/sidebar/Sidebar"
import { OnMediaPanel } from "./components/media/Media"

App.add_icons("./assets")

App.start({
    css: style,
    instanceName: "js",
    iconTheme: "Papirus",
    requestHandler(request, res) {
        print(request)
        res("ok")
    },
    main: () => {//App.get_monitors().map(Bar, CornerScreen)
        Bar()
        Charging()
        CalendarPanel()
        CornerScreen()
        OSD()
        //Osd()
        //Time()
        NotificationPopups()
        WindowSide( // Sidebar
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
    },
})