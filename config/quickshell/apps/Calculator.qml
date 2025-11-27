//@ pragma UseQApplication
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Qt5Compat.GraphicalEffects

ApplicationWindow {
    id: root
    width: 72*5 + (10*4)
    height: 600
    visible: true
    color: "#121212"
    title: "shell Calculator"

    // --- Estado ---
    property string displayExpression: ""     // toda la operación: "10+10"
    property string displayPreview: ""        // resultado debajo
    property bool newInput: true
    property bool operatorPressed: false
    property string lastOperator: ""
    property real lastValue: 0

    // --- Tema Material ---
    property color surface: "#1E1E1E"
    property color surfaceContainer: "#2A2A2A"
    property color primary: "#BB86FC"
    property color secondary: "#03DAC6"
    property color colOnSurface: "#FFFFFF"
    property color error: "#CF6679"

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        // --- Pantalla ---
        // --- Pantalla ---
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            radius: 24
            color: surfaceContainer

            // Expresión completa (ej: 10+10)
            CalButton { label: "÷"; bgColor: primary; onClicked: root.appendOperator("/") }
            Text {
                id: expression
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.bottom: preview.top
                anchors.bottomMargin: 8
                text: root.displayExpression === "" ? "0" : root.displayExpression
                font.pixelSize: 38
                font.family: "Google Sans"
                color: colOnSurface
                horizontalAlignment: Text.AlignRight
                elide: Text.ElideRight
            }

            // Preview resultado (ej: 20)
            Text {
                id: preview
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 16
                text: root.displayPreview
                font.pixelSize: 22
                color: root.displayPreview === "" ? "transparent" : "#03DAC6"
                horizontalAlignment: Text.AlignRight
            }
        }



        // --- Cuadrícula de botones ---
        GridLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
            columns: 5
            rowSpacing: 10
            columnSpacing: 10


            CalButton { label: "7"; onClicked: root.appendNumber("7") }
            CalButton { label: "8"; onClicked: root.appendNumber("8") }
            CalButton { label: "9"; onClicked: root.appendNumber("9") }
            CalButton { label: "AC"; bgColor: error; onClicked: root.clearAll() }
            CalButton { label: "×"; bgColor: primary; onClicked: root.appendOperator("*") }

            CalButton { label: "4"; onClicked: root.appendNumber("4") }
            CalButton { label: "5"; onClicked: root.appendNumber("5") }
            CalButton { label: "6"; onClicked: root.appendNumber("6") }
            CalButton { label: "()"; onClicked: root.toggleParenthesis() }
            CalButton { label: "-"; bgColor: primary; onClicked: root.appendOperator("-") }

            CalButton { label: "1"; onClicked: root.appendNumber("1") }
            CalButton { label: "2"; onClicked: root.appendNumber("2") }
            CalButton { label: "3"; onClicked: root.appendNumber("3") }
            CalButton { label: "%"; onClicked: root.percent() }
            CalButton { label: "+"; bgColor: primary; onClicked: root.appendOperator("+") }

            CalButton { label: "0"; onClicked: root.appendNumber("0") }
            CalButton { label: "."; onClicked: root.addDot() }
            CalButton { label: "⌫"; onClicked: root.backspace() }
            CalButton { label: "÷"; bgColor: primary; onClicked: root.appendOperator("/") }
            CalButton { label: "="; bgColor: secondary; onClicked: root.calculate() }

        }
    }

    // --- Botón Material ---
    component CalButton: Rectangle {
        id: control
        property color bgColor: surfaceContainer
        property color textColor: colOnSurface
        property string label: ""

        implicitWidth: 72
        implicitHeight: 72
        radius: 100
        color: bgColor

        // Animación de "presionado"
        property bool pressed: false
        scale: pressed ? 0.94 : 1.0
        Behavior on scale {
            NumberAnimation { duration: 90; easing.type: Easing.OutQuad }
        }

        Text {
            text: control.label
            anchors.centerIn: parent
            color: control.textColor
            font.pixelSize: 24
            font.family: "Google Sans"
            font.bold: true
        }

        MouseArea {
            anchors.fill: parent
            onPressed: control.pressed = true
            onReleased: {
                control.pressed = false
                control.clicked()
            }
            onCanceled: control.pressed = false
        }

        signal clicked()
    }


    // --- Lógica principal ---
    function appendNumber(num) {
        if (root.newInput) {
            root.displayExpression = num
            root.newInput = false
        } else {
            root.displayExpression += num
        }
        updatePreview()
    }

    function appendOperator(op) {
        if (root.displayExpression === "") {
            // Si está vacío y el usuario presiona "-", asumimos que quiere un número negativo
            if (op === "-") {
                root.displayExpression = "-"
                root.newInput = false
            }
            return
        }

        const lastChar = root.displayExpression.slice(-1)

        // Si el último carácter ya es un operador
        if ("+-*/".includes(lastChar)) {
            // Caso especial: si pone "*-" o "/-" permitir número negativo (como 50*-2)
            if (op === "-" && (lastChar === "*" || lastChar === "/")) {
                root.displayExpression += "-"
                root.newInput = false
                return
            }

            // De lo contrario, reemplazamos el operador anterior
            root.displayExpression = root.displayExpression.slice(0, -1) + op
        } else {
            root.displayExpression += op
        }

        root.operatorPressed = true
        root.newInput = false
        updatePreview()
    }

    function backspace() {
        if (root.displayExpression.length > 0) {
            root.displayExpression = root.displayExpression.slice(0, -1)
            updatePreview()
        }
    }

    function calculate() {
        try {
            const result = eval(root.displayExpression)
            root.displayPreview = ""
            root.displayExpression = String(result)
            root.newInput = true
        } catch (e) {
            root.displayPreview = "Error"
        }
    }

    function updatePreview() {
        try {
            if (root.displayExpression === "") {
                root.displayPreview = ""
                return
            }
            const lastChar = root.displayExpression.slice(-1)
            if ("+-*/.".includes(lastChar)) {
                root.displayPreview = ""
                return
            }
            root.displayPreview = String(eval(root.displayExpression))
        } catch (e) {
            root.displayPreview = ""
        }
    }

    function clearAll() {
        root.displayExpression = ""
        root.displayPreview = ""
        root.newInput = true
    }

    function toggleParenthesis() {
        let expr = root.displayExpression
        if (expr === "") {
            // Si está vacío, abre un nuevo paréntesis
            root.displayExpression = "("
            root.newInput = false
            updatePreview()
            return
        }

        const lastChar = expr.slice(-1)
        const openCount = (expr.match(/\(/g) || []).length
        const closeCount = (expr.match(/\)/g) || []).length
        const isOperator = "+-*/".includes(lastChar)

        if (isOperator) {
            // Si el último carácter es un operador, siempre abrir uno nuevo
            root.displayExpression += "("
        } else if (openCount > closeCount) {
            // Si hay paréntesis abiertos sin cerrar, cerrar uno
            root.displayExpression += ")"
        } else {
            // En cualquier otro caso, abrir uno nuevo
            root.displayExpression += "("
        }

        root.newInput = false
        updatePreview()
    }


    function percent() {
        if (root.displayExpression === "") return
        root.displayExpression += "/100"
        updatePreview()
    }

    function addDot() {
        const lastChar = root.displayExpression.slice(-1)
        if (lastChar !== ".")
            root.displayExpression += "."
    }
}
