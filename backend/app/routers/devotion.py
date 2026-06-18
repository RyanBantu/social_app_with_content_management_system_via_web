from fastapi import APIRouter, Depends

from app.auth import verify_admin
from app.firebase import get_db
from app.firestore_paths import devotion_ref
from app.schemas import DailyDevotionPayload
from app.services.firestore_helpers import doc_to_dict, stamp

router = APIRouter(prefix="/admin/devotion", tags=["devotion"])


@router.get("")
def get_devotion(_admin: dict = Depends(verify_admin)):
    db = get_db()
    doc = devotion_ref(db).get()
    if not doc.exists:
        return {}
    return doc_to_dict(doc)


@router.put("")
def update_devotion(payload: DailyDevotionPayload, _admin: dict = Depends(verify_admin)):
    db = get_db()
    ref = devotion_ref(db)
    data = stamp(payload.model_dump())
    ref.set(data, merge=True)
    return doc_to_dict(ref.get())
