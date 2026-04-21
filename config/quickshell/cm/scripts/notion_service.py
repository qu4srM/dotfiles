#!/usr/bin/env python3
import sys
import os
import json

# 📂 Directorio base
SCRIPTS_DIR = os.path.expanduser("~/.config/quickshell/scripts")
sys.path.insert(0, SCRIPTS_DIR)

try:
    from notion_client import Client
except ImportError:
    print(json.dumps({
        "error": "No se encontró la librería 'notion-client'. Instálala con:",
        "install_command": f"pip install notion-client -t {SCRIPTS_DIR}"
    }))
    sys.exit(1)


def get_database(notion, database_id):
    """Obtiene metadatos esenciales de una base de datos de Notion."""
    try:
        db = notion.databases.retrieve(database_id=database_id)

        # Extraer información relevante
        title = (
            db.get("title", [{}])[0]
            .get("plain_text", "")
        )

        simplified = {
            "id": db.get("id"),
            "title": title,
            "created_time": db.get("created_time"),
            "last_edited_time": db.get("last_edited_time"),
            "url": db.get("url"),
            "data_sources": [
                {
                    "id": src.get("id"),
                    "name": src.get("name")
                }
                for src in db.get("data_sources", [])
            ],
        }

        return simplified

    except Exception as error:
        return {"error_retrieving_database": str(error)}

# Sintaxis para devolver todo en JSON
"""
def get_database(notion, id): 
    try:
        return notion.databases.retrieve(database_id=id)
    except Exception as e1:
        return {"error_retrieving_database": str(e1)}
"""

def get_data_source(notion, id):
    try:
        return notion.data_sources.retrieve(id)
    except Exception as e1:
        return {"error_retrieving_data_source": str(e1)}

def query_data_source(notion, id):
    try:
        return notion.data_sources.query(id)
    except Exception as e1:
        return {"error_retrieving_query": str(e1)}

def get_page(notion, id):
    """Versión optimizada: obtiene metadatos, bloques y texto sin sobrecargar la API."""
    try:
        # 📄 1. Obtener datos básicos de la página
        page = notion.pages.retrieve(page_id=id)
        properties = page.get("properties", {})

        # ⚙️ 2. Convertir propiedades simples sin pedir detalle adicional
        props_simplified = {}
        for name, prop in properties.items():
            ptype = prop.get("type")
            val = None

            if ptype == "title":
                val = " ".join(rt.get("plain_text", "") for rt in prop["title"])
            elif ptype == "rich_text":
                val = " ".join(rt.get("plain_text", "") for rt in prop["rich_text"])
            elif ptype == "select":
                val = prop["select"]["name"] if prop["select"] else None
            elif ptype == "multi_select":
                val = [s["name"] for s in prop["multi_select"]]
            elif ptype == "date":
                val = prop["date"]["start"] if prop["date"] else None
            elif ptype == "status":
                val = prop["status"]["name"] if prop["status"] else None
            elif ptype == "people":
                val = [p["id"] for p in prop["people"]]
            elif ptype == "checkbox":
                val = prop["checkbox"]
            elif ptype == "url":
                val = prop["url"]
            elif ptype == "email":
                val = prop["email"]
            elif ptype == "phone_number":
                val = prop["phone_number"]
            elif ptype == "number":
                val = prop["number"]
            elif ptype == "created_time":
                val = prop["created_time"]
            elif ptype == "last_edited_time":
                val = prop["last_edited_time"]
            else:
                # no procesamos relaciones o rollups complejos
                val = None

            props_simplified[name] = val

        # 🧱 3. Obtener contenido de bloques (solo texto plano)
        text_parts = []
        cursor = None
        while True:
            resp = notion.blocks.children.list(block_id=id, start_cursor=cursor) if cursor else notion.blocks.children.list(block_id=id)
            for block in resp.get("results", []):
                btype = block.get("type")
                if btype in (
                    "paragraph", "heading_1", "heading_2", "heading_3",
                    "quote", "bulleted_list_item", "numbered_list_item",
                    "to_do", "callout"
                ):
                    for rt in block[btype].get("rich_text", []):
                        text_parts.append(rt.get("plain_text", ""))
            if not resp.get("has_more"):
                break
            cursor = resp.get("next_cursor")

        # 🧩 4. Combinar resultado
        return {
            "id": page.get("id"),
            "url": page.get("url"),
            "icon": page.get("icon"),
            "created_time": page.get("created_time"),
            "last_edited_time": page.get("last_edited_time"),
            "properties": props_simplified,
            "content": "\n".join(text_parts)
        }

    except Exception as e:
        return {"error_retrieving_page": str(e)}


def main():
    if len(sys.argv) < 4:
        print(json.dumps({
            "error": "Uso: python notion_service.py <integration_token> <database_id> <data_source_id>"
        }))
        sys.exit(1)

    token = sys.argv[1]
    database_id = sys.argv[2]
    data_source_id = sys.argv[3]

    notion = Client(auth=token)

    data_source_info = get_data_source(notion, data_source_id)
    query_result = query_data_source(notion, data_source_id)

    # extraer páginas desde el query
    pages = []
    if "results" in query_result:
        for p in query_result["results"]:
            page_id = p.get("id")
            if page_id:
                page_data = get_page(notion, page_id)
                pages.append(page_data)

    result = {
        "database": get_database(notion, database_id),
        "data_source": data_source_info,
        "query": query_result,
        "pages": pages
    }

    print(json.dumps(result, indent=4, ensure_ascii=False))


if __name__ == "__main__":
    main()
