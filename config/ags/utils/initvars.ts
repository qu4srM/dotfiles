import { Variable } from "astal"
import { Astal, Gtk } from "astal/gtk3"

// POLLS


export const countSeconds = (n) => n * 1000
export const countMinutes = (n) => n * 60000
export const countHours = (n) => n * 60 * 60000

// Vars

export const activeBar = Variable("bartop")

// Windows
export const { TOP, LEFT, RIGHT, BOTTOM } = Astal.WindowAnchor
export const { EXCLUSIVE, NORMAL, IGNORE } = Astal.Exclusivity
export const { START, CENTER, END } = Gtk.Align
export const { SLIDE_LEFT, SLIDE_RIGHT, SLIDE_DOWN, SLIDE_UP } = Gtk.RevealerTransitionType

// Alerts
export const visibleVol = Variable(false)

// Nets
export const net1 = Variable('')
export const net2 = Variable('')
export const net3 = Variable('')
export const net4 = Variable('')
export const net5 = Variable('')
export const net6 = Variable('')
export const signal1 = Variable(0)
export const signal2 = Variable(0)
export const signal3 = Variable(0)
export const signal4 = Variable(0)
export const signal5 = Variable(0)
export const signal6 = Variable(0)

