const weekDays = [
    { day: 'Sun', today: 0 },
    { day: 'Mon', today: 0 },
    { day: 'Tue', today: 0 },
    { day: 'Wen', today: 0 },
    { day: 'Thu', today: 0 },
    { day: 'Fri', today: 0 },
    { day: 'Sat', today: 0 },
]

function checkLeapYear(year) {
    return (
        year % 400 == 0 ||
        (year % 4 == 0 && year % 100 != 0));
}

function getMonthDays(month, year) {
    const leapYear = checkLeapYear(year);
    // Meses con 31 días: Enero(1), Marzo(3), Mayo(5), Julio(7), Agosto(8), Octubre(10), Diciembre(12)
    if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) return 31;
    // Febrero (2)
    if (month == 2) return leapYear ? 29 : 28;
    // Meses con 30 días: Abril(4), Junio(6), Septiembre(9), Noviembre(11)
    return 30;
}

function getNextMonthDays(month, year) {
    // Si el mes actual es Diciembre (12), el siguiente es Enero (1) del AÑO SIGUIENTE
    if (month === 12) return 31;
    // Para el resto de meses, llama a getMonthDays con el siguiente mes
    return getMonthDays(month + 1, year);
}

function getPrevMonthDays(month, year) {
    // Si el mes actual es Enero (1), el anterior es Diciembre (12) del AÑO ANTERIOR
    if (month === 1) return 31;
    // Para el resto de meses, llama a getMonthDays con el mes anterior
    return getMonthDays(month - 1, year);
}

function getDateInXMonthsTime(x) {
    var currentDate = new Date(); // Obtener la fecha actual
    if (x == 0) return currentDate; // Si x es 0, devolver la fecha actual

    var targetMonth = currentDate.getMonth() + x; // Calcular el mes objetivo
    var targetYear = currentDate.getFullYear(); // Obtener el año actual

    // Ajustar el año y el mes si es necesario
    targetYear += Math.floor(targetMonth / 12);
    targetMonth = (targetMonth % 12 + 12) % 12;

    // Crear un nuevo objeto de fecha con el año y mes objetivo
    // El día se establece en 1 por defecto
    var targetDate = new Date(targetYear, targetMonth, 1);

    return targetDate;
}

function getCalendarLayout(dateObject, highlight) {
    if (!dateObject) dateObject = new Date();
    
    // dateObject.getDay() devuelve 0 (Domingo) a 6 (Sábado). 
    // Ahora **Domingo es el primer día de la semana (0)**, no se necesita ajuste.
    const weekday = dateObject.getDay(); 
    
    const day = dateObject.getDate();
    const month = dateObject.getMonth() + 1; // 1-12
    const year = dateObject.getFullYear();
    
    // Obtenemos el día de la semana (0-6) para el primer día del mes actual.
    // dateObject es la fecha actual. Restamos (day - 1) días para llegar al 1er día.
    const weekdayOfMonthFirst = (weekday + 35 - (day - 1)) % 7; 
    
    const daysInMonth = getMonthDays(month, year);
    // Usamos el año actual para el siguiente/anterior mes, aunque técnicamente
    // para Enero/Diciembre debería ser ajustado, las funciones getNextMonthDays/getPrevMonthDays 
    // lo manejan solo con el número de mes, lo cual es suficiente por la forma en que están escritas.
    const daysInNextMonth = getNextMonthDays(month, year); 
    const daysInPrevMonth = getPrevMonthDays(month, year);

    // Llenar
    var monthDiff = (weekdayOfMonthFirst == 0 ? 0 : -1); // 0 si el 1er día es Domingo, -1 para los días del mes anterior
    var toFill, dim;
    
    if(weekdayOfMonthFirst == 0) { // El 1er día del mes actual cae en Domingo (0)
        toFill = 1;
        dim = daysInMonth;
    }
    else { // El calendario debe comenzar con días del mes anterior
        // Calcular el día inicial: Ej: si el 1er día es Miércoles (3), necesitamos 3 días anteriores (31, 30, 29)
        // Días a mostrar del mes anterior: weekdayOfMonthFirst
        // El día inicial será: (días en el mes anterior - días a mostrar) + 1
        toFill = daysInPrevMonth - weekdayOfMonthFirst + 1;
        dim = daysInPrevMonth;
    }
    
    var calendar = [...Array(6)].map(() => Array(7));
    var i = 0, j = 0;
    while (i < 6 && j < 7) {
        calendar[i][j] = {
            "day": toFill,
            "today": (
                (toFill == day && monthDiff == 0 && highlight) ? 1 : ( // Es el día actual y está en el mes actual
                    monthDiff == 0 ? 0 : // Está en el mes actual pero no es el día de hoy
                    -1 // Pertenece a otro mes
            ))
        };
        // Incrementar
        toFill++;
        if (toFill > dim) { // Siguiente mes?
            monthDiff++;
            if (monthDiff == 0) // Transición de Mes Anterior a Mes Actual
                dim = daysInMonth;
            else if (monthDiff == 1) // Transición de Mes Actual a Mes Siguiente
                dim = daysInNextMonth;
            toFill = 1;
        }
        // Siguiente casilla
        j++;
        if (j == 7) {
            j = 0;
            i++;
        }
    }
    return calendar;
}