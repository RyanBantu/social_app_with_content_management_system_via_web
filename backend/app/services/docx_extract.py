import io
import uuid

from docx import Document

from app.firebase import get_bucket


def extract_docx_text(file_bytes: bytes) -> str:
    doc = Document(io.BytesIO(file_bytes))
    paragraphs = [p.text.strip() for p in doc.paragraphs if p.text.strip()]
    return "\n\n".join(paragraphs)


def upload_docx(file_bytes: bytes, original_filename: str) -> tuple[str, str, str]:
    """Upload DOCX to Storage. Returns (public_url, fileName, bodyText)."""
    body_text = extract_docx_text(file_bytes)

    safe_name = _safe_filename(original_filename)
    storage_path = f"sermons/{uuid.uuid4().hex}_{safe_name}"

    bucket = get_bucket()
    blob = bucket.blob(storage_path)
    blob.upload_from_string(
        file_bytes,
        content_type="application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    )
    blob.make_public()

    return blob.public_url, safe_name, body_text


def _safe_filename(filename: str) -> str:
    name = filename.replace(" ", "_")
    if not name.lower().endswith(".docx"):
        name += ".docx"
    return name
