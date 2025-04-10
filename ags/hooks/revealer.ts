import { Gtk } from "astal/gtk3"
const {SLIDE_LEFT, SLIDE_RIGHT, SLIDE_DOWN, SLIDE_TOP} = Gtk.RevealerTransitionType

export function show(self, visible) {
    
    if (visible === true) {
        self.revealChild = visible.get()
        self.transitionType = SLIDE_TOP
    } else {
        self.revealChild = visible.get()
        self.transitionType = SLIDE_DOWN
    }
}

export function showh(self, visible) {
    
    if (visible === true) {
        self.revealChild = visible.get()
        self.transitionType = SLIDE_RIGHT
    } else {
        self.revealChild = visible.get()
        self.transitionType = SLIDE_LEFT
    }
}
