pragma Singleton
import Quickshell

Singleton {
    id: root 
    
    function setTransparency(color, percentage = 1) {
        var c = Qt.color(color);
        return Qt.rgba(c.r, c.g, c.b, c.a * (1 - percentage));
    }
}