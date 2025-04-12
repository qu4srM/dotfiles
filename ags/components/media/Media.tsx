import { Variable, bind } from "astal"
import { execAsync } from "astal/process"
import { show } from "../../utils/revealer"

import { title } from "../../utils/initvars"
import { point } from "../../utils/initvars"
import { artist } from "../../utils/initvars"
import { iconApp } from "../../utils/initvars"

import { lengthMusic } from "../../utils/initvars"
import { position } from "../../utils/initvars"
import { url } from "../../utils/initvars"


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
            onValueChanged={(_, newValue) => {
                // Ajuste la posición de la canción según el valor del slider
                const newPosition = newValue * bind(lengthMusic)
                execAsync(["bash", "-c", `bash ~/.config/ags/scripts/music.sh seek ${newPosition}`])
                    .then(() => console.log(`Reproduciendo desde ${newPosition}`))
                    .catch((err) => console.error(err))
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
