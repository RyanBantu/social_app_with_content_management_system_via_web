from fastapi import APIRouter, Depends, HTTPException

from app.auth import verify_admin
from app.firebase import get_db
from app.firestore_paths import ministries_col
from app.schemas import MinistryPayload, ReorderPayload
from app.services.firestore_helpers import doc_to_dict, stamp

router = APIRouter(prefix="/admin/ministries", tags=["ministries"])


@router.get("")
def list_ministries(_admin: dict = Depends(verify_admin)):
    db = get_db()
    docs = ministries_col(db).order_by("sortOrder").stream()
    return [doc_to_dict(d) for d in docs]


@router.post("")
def create_ministry(payload: MinistryPayload, _admin: dict = Depends(verify_admin)):
    db = get_db()
    doc_id = payload.id or None
    ref = ministries_col(db).document(doc_id)
    data = stamp(payload.model_dump())
    ref.set(data)
    return doc_to_dict(ref.get())


@router.put("/{ministry_id}")
def update_ministry(
    ministry_id: str,
    payload: MinistryPayload,
    _admin: dict = Depends(verify_admin),
):
    db = get_db()
    ref = ministries_col(db).document(ministry_id)
    if not ref.get().exists:
        raise HTTPException(status_code=404, detail="Ministry not found")
    data = stamp(payload.model_dump())
    data["id"] = ministry_id
    ref.set(data, merge=True)
    return doc_to_dict(ref.get())


@router.delete("/{ministry_id}")
def delete_ministry(ministry_id: str, _admin: dict = Depends(verify_admin)):
    db = get_db()
    ref = ministries_col(db).document(ministry_id)
    if not ref.get().exists:
        raise HTTPException(status_code=404, detail="Ministry not found")
    ref.delete()
    return {"deleted": ministry_id}


@router.post("/reorder")
def reorder_ministries(payload: ReorderPayload, _admin: dict = Depends(verify_admin)):
    db = get_db()
    col = ministries_col(db)
    batch = db.batch()
    for item in payload.items:
        batch.update(col.document(item.id), {"sortOrder": item.sortOrder})
    batch.commit()
    return {"ok": True}
