import { Variable, bind } from "astal"
import { execAsync } from "astal/process"
import { show } from "../../hooks/revealer"

import { title } from "../../hooks/initvars"
import { point } from "../../hooks/initvars"
import { artist } from "../../hooks/initvars"
import { iconApp } from "../../hooks/initvars"

import { lengthMusic } from "../../hooks/initvars"
import { position } from "../../hooks/initvars"
import { url } from "../../hooks/initvars"


function lengthStr(length: number) {
    const min = Math.floor(length / 60)
    //const min = length < 1000000000 ? Math.floor(length / 6e+7) : length > 1000000000 && length < 10000000000 ? Math.floor(length / 6e+7) : "nothing"
    const sec = Math.floor(length % 60)
    const sec0 = sec < 10 ? "0" : ""
    return `${min}:${sec0}${sec}`
}
function lengthStrNormal(length: number) {
    const min = Math.floor(length / 60)
    const sec = Math.floor(length % 60)
    const sec0 = sec < 10 ? "0" : ""
    return `${min}:${sec0}${sec}`
}

function Media() {
    
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
        />
        <label label={bind(lengthMusic).as(l => l > 0 ? lengthStr(l) : "0:00")} />
    </centerbox>
}

function Control() {
    return <centerbox className="control">
        <button className="control-play" cursor="pointer" onClicked={
            () => {
                execAsync(["bash", "-c", "bash ~/.config/ags/scripts/music.sh previous"])
                    .then((out) => console.log(out))
                    .catch((err) => console.error(err))
            }
        } >
            <icon
                className="control-play-icon"
                icon="media-skip-backward-symbolic"
            />
        </button>
        <button className="control-play" cursor="pointer" onClicked={
            () => {
                execAsync(["bash", "-c", "bash ~/.config/ags/scripts/music.sh playorpause"])
                    .then((out) => console.log(out))
                    .catch((err) => console.error(err))
            }
        } >
            <icon
                className="control-play-icon"
                icon="media-playback-start-symbolic"
            />
        </button>
        <button className="control-play" cursor="pointer" onClicked={
            () => {
                execAsync(["bash", "-c", "bash ~/.config/ags/scripts/music.sh next"])
                    .then((out) => console.log(out))
                    .catch((err) => console.error(err))
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
            <Media />
            <CoverArt />
            <Time />
            <Control />
        </box>
    </centerbox>
}


export function OnMediaPanel ({ visible }: { visible: Variable<boolean> }) {
    return <revealer
        setup={self => show(self, visible)}
        revealChild={visible()}
        //transitionDuration={400}
        >
        <MediaBox />
    </revealer>
    
}

