from fastapi import APIRouter, Depends, File, Form, UploadFile

from app.auth import verify_admin
from app.firebase import get_db
from app.schemas import AppConfigPayload, UploadImageResponse, UploadSermonResponse
from app.services.docx_extract import upload_docx
from app.services.firestore_helpers import doc_to_dict, stamp
from app.services.image import resize_and_upload_image

router = APIRouter(prefix="/admin", tags=["uploads"])


@router.post("/upload/image", response_model=UploadImageResponse)
async def upload_image(
    file: UploadFile = File(...),
    folder: str = Form("images"),
    _admin: dict = Depends(verify_admin),
):
    contents = await file.read()
    url, path = resize_and_upload_image(contents, folder)
    return UploadImageResponse(url=url, path=path)


@router.post("/upload/sermon", response_model=UploadSermonResponse)
async def upload_sermon_file(
    file: UploadFile = File(...),
    _admin: dict = Depends(verify_admin),
):
    contents = await file.read()
    filename = file.filename or "sermon.docx"
    url, safe_name, body_text = upload_docx(contents, filename)
    return UploadSermonResponse(docxUrl=url, fileName=safe_name, bodyText=body_text)


config_router = APIRouter(prefix="/admin/config", tags=["config"])


@config_router.get("")
def get_config(_admin: dict = Depends(verify_admin)):
    doc = get_db().collection("config").document("app").get()
    if not doc.exists:
        return {"prayerTeamEmail": "prayer@mysorehopecenter.org"}
    return doc_to_dict(doc)


@config_router.put("")
def update_config(payload: AppConfigPayload, _admin: dict = Depends(verify_admin)):
    ref = get_db().collection("config").document("app")
    data = stamp(payload.model_dump())
    ref.set(data, merge=True)
    return doc_to_dict(ref.get())
