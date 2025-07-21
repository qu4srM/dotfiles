pragma Singleton
import QtQuick

QtObject {
    property var popupController: null

    function openPopup(mode, caller = null) {
        if (popupController) {
            popupController.open(mode, caller)
        }
    }

    function closePopup() {
        if (popupController) {
            popupController.close()
        }
    }
}
