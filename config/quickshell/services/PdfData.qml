pragma Singleton
import qs.configs
import qs.utils

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property var allPages: []       // rutas de imágenes del PDF
    property int numItems: 0
    property string filePath        // ruta del PDF
    property string endPath: "~/.cache/quickshell/pdfImages"
    property real dpi: 300
    property string format: "jpg"

    readonly property string jsonPath: `${Paths.expandTilde(endPath)}/output.json`

    Process {
        id: convertPdfToImage
    }

    // 🔥 FileView para observar el JSON dinámicamente
    FileView {
        id: jsonFileView
        path: root.jsonPath

        onLoaded: {
            try {
                const fileContents = jsonFileView.text()
                const parsed = JSON.parse(fileContents)
                root.allPages = parsed
                root.numItems = parsed.length
                console.log(`[PdfImages] JSON cargado: ${root.numItems} páginas.`)
            } catch (e) {
                console.error("[PdfImages] Error al parsear JSON:", e)
            }
        }

        onLoadFailed: (error) => {
            if (error === FileViewError.FileNotFound) {
                console.log("[PdfImages] JSON no encontrado. Se creará al convertir el PDF.")
                root.allPages = []
            } else {
                console.error("[PdfImages] Error cargando JSON:", error)
            }
        }

        onFileChanged: {
            // Se llama automáticamente cuando cambia el archivo
            console.log("[PdfImages] Detectado cambio en JSON, recargando...")
            jsonFileView.reload()
        }
    }

    function execConvertPdfToImage() {
        const dir = Paths.expandTilde(endPath)
        Io.ensureDir(dir) // asegúrate de que la carpeta exista
        const cmd = `python3 ~/pdf_to_images.py ${filePath} ${dir} -r ${dpi} -f ${format} -j`
        convertPdfToImage.command = ["bash", "-c", cmd]
        convertPdfToImage.startDetached()
        console.log("[PdfImages] Ejecutando conversión:", cmd)
    }
}
