from fastapi import APIRouter, Depends, HTTPException

from app.auth import verify_admin
from app.firebase import get_db
from app.firestore_paths import events_col
from app.schemas import ReorderPayload, UpcomingEventPayload
from app.services.firestore_helpers import doc_to_dict, stamp

router = APIRouter(prefix="/admin/events", tags=["events"])


@router.get("")
def list_events(_admin: dict = Depends(verify_admin)):
    db = get_db()
    docs = events_col(db).order_by("sortOrder").stream()
    return [doc_to_dict(d) for d in docs]


@router.post("")
def create_event(payload: UpcomingEventPayload, _admin: dict = Depends(verify_admin)):
    db = get_db()
    ref = events_col(db).document()
    data = stamp(payload.model_dump())
    ref.set(data)
    return doc_to_dict(ref.get())


@router.put("/{event_id}")
def update_event(
    event_id: str,
    payload: UpcomingEventPayload,
    _admin: dict = Depends(verify_admin),
):
    db = get_db()
    ref = events_col(db).document(event_id)
    if not ref.get().exists:
        raise HTTPException(status_code=404, detail="Event not found")
    data = stamp(payload.model_dump())
    ref.set(data, merge=True)
    return doc_to_dict(ref.get())


@router.delete("/{event_id}")
def delete_event(event_id: str, _admin: dict = Depends(verify_admin)):
    db = get_db()
    ref = events_col(db).document(event_id)
    if not ref.get().exists:
        raise HTTPException(status_code=404, detail="Event not found")
    ref.delete()
    return {"deleted": event_id}


@router.post("/reorder")
def reorder_events(payload: ReorderPayload, _admin: dict = Depends(verify_admin)):
    db = get_db()
    col = events_col(db)
    batch = db.batch()
    for item in payload.items:
        batch.update(col.document(item.id), {"sortOrder": item.sortOrder})
    batch.commit()
    return {"ok": True}
