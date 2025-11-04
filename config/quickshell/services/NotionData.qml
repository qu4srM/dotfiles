pragma Singleton

import qs.configs
import qs.utils

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root


    property string dataTitle: data.database?.title ?? "Sin título"
    property string dataSourceTitle: data.data_source?.title?.[0]?.plain_text ?? "Sin título"
    property var dataSourceList: data.query?.results ?? []




    property string token: Config.options.notion.token
    property string databaseId: Config.options.notion.database_id
    property string dataSourceId: Config.options.notion.data_source_id

    property var data: ({})
    property var list: []

    function refresh() {
        notionProc.running = true
    }
    Process {
        id: notionProc
        command: [
            "bash",
            "-c",
            `python3 ~/.config/quickshell/scripts/notion_service.py ${root.token} ${root.databaseId} ${root.dataSourceId}`
        ]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const text = this.text.trim()
                if (text === "")
                    return

                try {
                    const parsed = JSON.parse(text)
                    root.data = parsed
                    root.list = parsed.query?.results ?? []
                    console.log("✅ Notion database:", parsed.database?.title)
                } catch (err) {
                    console.error("❌ Error al parsear JSON de Notion:", err)
                    console.error("Salida cruda:", text)
                }
            }
        }
        
    }

    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: notionProc.running = true
    }

    
}
