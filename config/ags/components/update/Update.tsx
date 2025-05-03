import { Variable} from "astal"
import { show } from "../../utils/revealer"

export function OnUpdate ({ visible }: { visible: Variable<boolean> }) {
    return <revealer
        setup={self => show(self, visible)}
        revealChild={visible()}
        //transitionDuration={400}
    >
        <label label="Hola" />
    </revealer>
}
