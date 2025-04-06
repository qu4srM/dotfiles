import { App } from "astal/gtk3"
import style from "./style.scss"
import Bar, { Charging } from "./widget/Bar"
import CornerScreen from "./widget/CornerScreen"
import OSD from "./widget/OSD"
import Time from "./widget/Time"
import NotificationPopups from "./components/notificationsAylur/NotificationPopups"
import { SideBar } from "./widget/Bar"
import { Charging } from "./widget/Bar"
import { MediaPanel } from "./widget/Bar"
import Osd from "./components/osd/Osd"
import { CalendarPanel } from "./widget/Bar"

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
        SideBar()
        Charging()
        MediaPanel()
        CalendarPanel()
        CornerScreen()
        OSD()
        //Osd()
        //Time()
        NotificationPopups()
    },
})