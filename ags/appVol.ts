import { App } from "astal/gtk3"
import style from "./widget/stylewidget/widget.scss"
import Volume from "./widget/Volume"

App.add_icons("./assets")

App.start({
    css: style,
    instanceName: "volume",
    iconTheme: "Papirus",
    requestHandler(request, res) {
        print(request)
        res("ok")
    },
    main: () => {//App.get_monitors().map(Bar, CornerScreen)
        Volume()
    },
})