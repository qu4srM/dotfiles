import { Variable} from "astal"
import { Astal, Gtk} from "astal/gtk3"


// Windows
export const { TOP, LEFT, RIGHT, BOTTOM } = Astal.WindowAnchor
export const {EXCLUSIVE, NORMAL, IGNORE} = Astal.Exclusivity
export const {START, CENTER, END} = Gtk.Align
export const {SLIDE_LEFT, SLIDE_RIGHT, SLIDE_DOWN, SLIDE_UP} = Gtk.RevealerTransitionType
export const calendarName = "calendar"
export const volumeName = "volume"
export const updateName = "update"

// Alerts
export const visibleVol = Variable(false)

