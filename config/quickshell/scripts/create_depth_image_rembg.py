# scripts/python/create_depth_image_rembg.py

import argparse
import sys
import logging
from pathlib import Path
from rembg import new_session, remove
from PIL import Image
import io

# Configuración de logging
logging.basicConfig(
    level=logging.INFO,
    format="[%(levelname)s] %(message)s"
)

def process_image_rembg(
    input_path: Path,
    output_path: Path,
    model_name: str,
    alpha_matting: bool,
    foreground_threshold: int,
    background_threshold: int,
    erode_size: int,
    background_color=None,
):
    """
    Procesa una sola imagen para quitar fondo con rembg.
    """
    if not input_path.is_file():
        logging.error(f"Input file not found: {input_path}")
        return False

    try:
        session = new_session(model_name)

        with open(input_path, "rb") as i:
            input_data = i.read()

        output_data = remove(
            input_data,
            session=session,
            alpha_matting=alpha_matting,
            alpha_matting_foreground_threshold=foreground_threshold,
            alpha_matting_background_threshold=background_threshold,
            alpha_matting_erode_size=erode_size,
        )

        # Convertir a PIL para postprocesamiento (opcional)
        img = Image.open(io.BytesIO(output_data)).convert("RGBA")

        if background_color:
            # Aplicar un fondo sólido en lugar de transparencia
            bg = Image.new("RGBA", img.size, background_color)
            img = Image.alpha_composite(bg, img)

        # Crear carpeta si no existe
        output_path.parent.mkdir(parents=True, exist_ok=True)
        img.save(output_path, "PNG")

        logging.info(
            f"✅ Success: {input_path.name} → {output_path} "
            f"(model={model_name}, alpha_matting={alpha_matting})"
        )
        return True

    except Exception as e:
        logging.error(f"Failed processing {input_path}: {e}")
        return False


def process_batch(input_path: Path, output_dir: Path, **kwargs):
    """
    Procesa un archivo único o todos los de una carpeta.
    """
    if input_path.is_file():
        output_file = output_dir / (input_path.stem + "_fg.png")
        process_image_rembg(input_path, output_file, **kwargs)

    elif input_path.is_dir():
        for img_file in input_path.glob("*.jpg"):
            process_image_rembg(img_file, output_dir / (img_file.stem + "_fg.png"), **kwargs)
        for img_file in input_path.glob("*.png"):
            process_image_rembg(img_file, output_dir / (img_file.stem + "_fg.png"), **kwargs)
    else:
        logging.error(f"Invalid input: {input_path}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Remove background from images using rembg."
    )

    parser.add_argument("input", help="Path to input image or directory.")
    parser.add_argument("output", help="Path to output file or directory.")

    parser.add_argument(
        "-m", "--model",
        choices=["u2net", "isnet-general-use"],
        default="u2net",
        help="Model to use (default: u2net)."
    )
    parser.add_argument(
        "-a", "--alpha-matting",
        action="store_true",
        help="Enable alpha matting for better edges."
    )
    parser.add_argument(
        "-ft", "--foreground-threshold",
        type=int, default=240,
        help="Foreground threshold (default: 240)."
    )
    parser.add_argument(
        "-bt", "--background-threshold",
        type=int, default=10,
        help="Background threshold (default: 10)."
    )
    parser.add_argument(
        "-e", "--erode-size",
        type=int, default=15,
        help="Erode size for alpha matting (default: 15)."
    )
    parser.add_argument(
        "-bg", "--background",
        type=str, default=None,
        help="Background color in hex (e.g., '#FFFFFF'). Default: transparent."
    )

    args = parser.parse_args()

    input_path = Path(args.input)
    output_path = Path(args.output)

    kwargs = dict(
        model_name=args.model,
        alpha_matting=args.alpha_matting,
        foreground_threshold=args.foreground_threshold,
        background_threshold=args.background_threshold,
        erode_size=args.erode_size,
        background_color=args.background,
    )

    # Si output es carpeta → procesar batch
    if input_path.is_dir():
        process_batch(input_path, output_path, **kwargs)
    else:
        if output_path.suffix.lower() not in [".png", ".jpg", ".jpeg"]:
            output_path = output_path.with_suffix(".png")
        process_image_rembg(input_path, output_path, **kwargs)
