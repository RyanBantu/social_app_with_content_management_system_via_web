import io
import uuid
from pathlib import Path

from PIL import Image

from app.firebase import get_bucket


def resize_and_upload_image(
    file_bytes: bytes,
    folder: str,
    max_width: int = 1200,
    quality: int = 85,
) -> tuple[str, str]:
    """Resize image and upload to Firebase Storage. Returns (public_url, storage_path)."""
    img = Image.open(io.BytesIO(file_bytes))
    if img.mode in ("RGBA", "P"):
        img = img.convert("RGB")

    if img.width > max_width:
        ratio = max_width / img.width
        new_size = (max_width, int(img.height * ratio))
        img = img.resize(new_size, Image.Resampling.LANCZOS)

    buf = io.BytesIO()
    img.save(buf, format="JPEG", quality=quality, optimize=True)
    buf.seek(0)

    ext = "jpg"
    name = f"{uuid.uuid4().hex}.{ext}"
    storage_path = f"{folder.rstrip('/')}/{name}"

    bucket = get_bucket()
    blob = bucket.blob(storage_path)
    blob.upload_from_file(buf, content_type="image/jpeg")
    blob.make_public()

    return blob.public_url, storage_path
