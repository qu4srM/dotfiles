import { App, Astal, Gdk, Gtk } from "astal/gtk3"
import { Variable, bind } from "astal"
import { interval,timeout } from "astal/time"
import { safeExecAsync } from "../../utils/exec"
import { show } from "../../utils/revealer"
import { TOP, LEFT} from "../../utils/initvars"
import { SLIDE_DOWN } from "../../utils/initvars"
import { IGNORE } from "../../utils/initvars"
import { END, START } from "../../utils/initvars"

export const mediaWindowName = "media"
export const visibleMedia= Variable(false)

import { title } from "../bar/BarTop"
import { artist } from "../bar/BarTop"
import { iconApp } from "../bar/BarTop"
function timeToSeconds(time: string): number {
    const [min, sec] = time.trim().split(":").map(Number)
    return min * 60 + sec
}

export const iconPlay = Variable("").poll(10000, ["bash", "-c", "~/.config/ags/scripts/music.sh geticonplay"])
export const lengthMusic = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/music.sh getlength"])
export const lengthMusicRaw = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/music.sh getlengthraw"])
export const positionRaw = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/music.sh getpositionraw"])
export const position = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/music.sh getposition"])
export const image = Variable("").poll(1000, ["bash", "-c", "~/.config/ags/scripts/music.sh getimage"]) // NO DELETE

export const lengthSeconds = Variable(0)
export const positionSeconds = Variable(0)

console.log(image.get())

function MediaLabels() {
    return <box className="media-box" vertical>
        <centerbox>
            <label label={bind(title)} halign={START}/>
            <label label=" "/>
            <icon halign={END}
                className="media-icon"
                icon={bind(iconApp)}
            />
        </centerbox>
        <box>
            <label label={bind(artist)} halign={START}/>
        </box>
    </box>
}
function CoverArt() {
    return <centerbox>
        <box className="cover-art" css={`background-image: url("./assets/img/coverArt.jpg")`} />
    </centerbox>
}
function Time() {
    return <centerbox>
        <slider
            value={bind(positionRaw)}
            max={bind(lengthMusicRaw)}
            onDragged={self => {
                const newValue = Math.round(self.value)
                safeExecAsync([
                    "bash", "-c",
                    `bash ~/.config/ags/scripts/music.sh seek ${newValue}`
                ])
            }}
            widthRequest={150}  // Controlamos el tamaño del slider
            heightRequest={10}  // Alto del slider
        />
    </centerbox>
}
function Control() {
    return <box className="control">
        <label label={bind(position)} />
        <box>
            <button className="control-play" cursor="pointer" onClicked={
                () => {
                    safeExecAsync(["bash", "-c", "~/.config/ags/scripts/music.sh previous"])
                }
            } >
                <icon
                    className="control-play-icon"
                    icon="media-skip-backward-symbolic"
                />
            </button>
            <button className="control-play" cursor="pointer" onClicked={
                () => {
                    safeExecAsync(["bash", "-c", "~/.config/ags/scripts/music.sh playorpause"])
                }
            } >
                <icon
                    className="control-play-icon"
                    icon={bind(iconPlay)}
                />
            </button>
            <button className="control-play" cursor="pointer" onClicked={
                () => {
                    safeExecAsync(["bash", "-c", "~/.config/ags/scripts/music.sh next"])
                }
            } >
                <icon
                    className="control-play-icon"
                    icon="media-skip-forward-symbolic"
                />
            </button>
        </box>
        <label label={bind(lengthMusic)} />
    </box>
}
function MediaBox () {
    return <centerbox className="revealer-box">
        <box>
            <CoverArt />
        </box>
        <centerbox className="media-menu" vertical>
            <MediaLabels />
            <Time />
            <Control />
        </centerbox>
    </centerbox>
}

function OnRevealer ({ visible }: { visible: Variable<boolean> }) {   
    return <revealer
        setup={self => show(self, visible)}
        revealChild={visibleMedia()}
        transitionType={SLIDE_DOWN}
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
        setup={self => {
            if (!visibleMedia.get()) {
                self.hide()
            }
        }}
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