pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: weather

    // Configura tu ciudad aquí (sin tilde)
    readonly property string city: "Ibagué"

    // Datos simples
    property string temperature: ""
    property string condition: ""
    property string location: ""

    // Pide datos de wttr.in
    function fetch() {
        let command = `curl -s "wttr.in/${city}?format=j1" | jq '{temp: .current_condition[0].temp_C, cond: .current_condition[0].weatherDesc[0].value, loc: .nearest_area[0].areaName[0].value}'`;
        fetcher.command[2] = command;
        fetcher.running = true;
    }

    // Proceso para ejecutar curl+jq
    Process {
        id: fetcher
        command: ["bash", "-c", ""]
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.length === 0) return;
                try {
                    const data = JSON.parse(text);
                    weather.temperature = data.temp + "°";
                    weather.condition = data.cond;
                    weather.location = data.loc;
                } catch (e) {
                    console.error("[WeatherService] JSON parse failed:", e.message);
                }
            }
        }
    }

    // Actualiza cada 10 minutos
    Timer {
        running: true
        repeat: true
        interval: 10 * 60 * 1000
        triggeredOnStart: true
        onTriggered: weather.fetch()
    }
}
