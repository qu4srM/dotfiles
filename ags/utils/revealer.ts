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

export function showNumber(self, visible, number) {
    if (number === 1) {
        self.revealChild = visible.get();  // Visibilidad basada en la variable 'visible'
        self.transitionType = Gtk.RevealerTransitionType.SLIDE_RIGHT;  // Transición hacia la derecha
    } else {
        self.revealChild = visible.get();  // Visibilidad basada en la variable 'visible'
        self.transitionType = Gtk.RevealerTransitionType.SLIDE_LEFT;  // Transición hacia la izquierda
    }
}