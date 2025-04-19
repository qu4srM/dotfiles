import { App, Astal, Gdk, Gtk } from "astal/gtk3"
import { Variable, bind } from "astal"
import { interval,timeout } from "astal/time"
import { safeExecAsync } from "../../utils/manage"
import { show } from "../../utils/revealer"
import { TOP, LEFT} from "../../utils/initvars"
import { SLIDE_UP, SLIDE_DOWN } from "../../utils/initvars"
import { IGNORE } from "../../utils/initvars"

export const mediaWindowName = "media"
export const visibleMedia= Variable(false)

import { title } from "../bar/BarTop"
import { point } from "../bar/BarTop"
import { artist } from "../bar/BarTop"
import { iconApp } from "../bar/BarTop"

export const lengthMusic = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/music.sh getlength"])
export const position = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/music.sh getposition"])
export const image = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/music.sh getimage"]) // NO DELETE
export const url = Variable("./assets/img/coverArt.jpg")


function lengthStrNormal(length: number) {
    const min = Math.floor(length / 60)
    const sec = Math.floor(length % 60)
    const sec0 = sec < 10 ? "0" : ""
    return `${min}:${sec0}${sec}`
}

function MediaLabels() {
    return <box className="media-box">
        <label label={bind(title)} />
        <label label={bind(point)} />
        <label label={bind(artist)} />
        <icon
            className="media-icon"
            icon={bind(iconApp)}
        />
    </box>
}

function CoverArt() {
    return <centerbox>
        <box className="cover-art" css={`background-image: url("${url.get()}")`} />
    </centerbox>
}

function Time() {
    return <centerbox>
        <label label={bind(position).as(lengthStrNormal)} />
        <slider 
            visible="true"
            value={bind(position).as(p => bind(lengthMusic) > 0
                ? p / bind(lengthMusic) : 0)}
            onValueChanged={(_, newValue) => {
                // Ajuste la posición de la canción según el valor del slider
                const newPosition = newValue * bind(lengthMusic)
                safeExecAsync(["bash", "-c", `bash ~/.config/ags/scripts/music.sh seek ${newPosition}`])
            }}
            widthRequest={150}  // Controlamos el tamaño del slider
            heightRequest={10}  // Alto del slider
        />
        <label label={bind(lengthMusic).as(l => l > 0 ? lengthStrNormal(l) : "0:00")} />
    </centerbox>
}

function Control() {
    return <centerbox className="control">
        <button className="control-play" cursor="pointer" onClicked={
            () => {
                safeExecAsync(["bash", "-c", "bash ~/.config/ags/scripts/music.sh previous"])
            }
        } >
            <icon
                className="control-play-icon"
                icon="media-skip-backward-symbolic"
            />
        </button>
        <button className="control-play" cursor="pointer" onClicked={
            () => {
                safeExecAsync(["bash", "-c", "bash ~/.config/ags/scripts/music.sh playorpause"])
            }
        } >
            <icon
                className="control-play-icon"
                icon="media-playback-start-symbolic"
            />
        </button>
        <button className="control-play" cursor="pointer" onClicked={
            () => {
                safeExecAsync(["bash", "-c", "bash ~/.config/ags/scripts/music.sh next"])
            }
        } >
            <icon
                className="control-play-icon"
                icon="media-skip-forward-symbolic"
            />
        </button>
    </centerbox>
}

function MediaBox () {
    return <centerbox className="revealer-box">
        <box className="media-menu" vertical>
            <MediaLabels />
            <CoverArt />
            <Time />
            <Control />
        </box>
    </centerbox>
}


function OnRevealer ({ visible }: { visible: Variable<boolean> }) {   
    return <revealer
        setup={self => show(self, visible)}
        revealChild={visibleMedia()}
        transitionType={SLIDE_UP}
        transitionDuration={100}>
        <MediaBox />
    </revealer>
    
}




export default function Media(monitor: Gdk.Monitor) {
    if (!monitor) {
        const display = Gdk.Display.get_default()
        monitor = display?.get_primary_monitor()
    }
    return <window
        className={mediaWindowName}
        name={mediaWindowName}
        application={App}
        gdkmonitor={monitor}
        exclusivity={IGNORE}
        layer={Astal.Layer.OVERLAY}
        anchor={TOP | LEFT}
        marginTop="38"
        marginLeft="6"
        >
        <eventbox onHoverLost={
            ()=> {
                safeExecAsync(["bash", "-c", "~/.config/ags/launch.sh media"])
            }
        }>
            <centerbox>
                <OnRevealer visible={visibleMedia} />
            </centerbox>
        </eventbox>
        
    </window>
}