from fastapi import APIRouter, Depends, HTTPException

from app.auth import verify_admin
from app.firebase import get_db
from app.firestore_paths import sermons_col
from app.schemas import ReorderPayload, SermonPayload
from app.services.firestore_helpers import doc_to_dict, stamp

router = APIRouter(prefix="/admin/sermons", tags=["sermons"])


@router.get("")
def list_sermons(_admin: dict = Depends(verify_admin)):
    db = get_db()
    docs = sermons_col(db).order_by("sortOrder").stream()
    return [doc_to_dict(d) for d in docs]


@router.post("")
def create_sermon(payload: SermonPayload, _admin: dict = Depends(verify_admin)):
    db = get_db()
    ref = sermons_col(db).document()
    data = stamp(payload.model_dump())
    ref.set(data)
    return doc_to_dict(ref.get())


@router.put("/{sermon_id}")
def update_sermon(
    sermon_id: str,
    payload: SermonPayload,
    _admin: dict = Depends(verify_admin),
):
    db = get_db()
    ref = sermons_col(db).document(sermon_id)
    if not ref.get().exists:
        raise HTTPException(status_code=404, detail="Sermon not found")
    data = stamp(payload.model_dump())
    ref.set(data, merge=True)
    return doc_to_dict(ref.get())


@router.delete("/{sermon_id}")
def delete_sermon(sermon_id: str, _admin: dict = Depends(verify_admin)):
    db = get_db()
    ref = sermons_col(db).document(sermon_id)
    if not ref.get().exists:
        raise HTTPException(status_code=404, detail="Sermon not found")
    ref.delete()
    return {"deleted": sermon_id}


@router.post("/reorder")
def reorder_sermons(payload: ReorderPayload, _admin: dict = Depends(verify_admin)):
    db = get_db()
    col = sermons_col(db)
    batch = db.batch()
    for item in payload.items:
        batch.update(col.document(item.id), {"sortOrder": item.sortOrder})
    batch.commit()
    return {"ok": True}
