from datetime import datetime

from google.cloud.firestore_v1 import SERVER_TIMESTAMP


def stamp(data: dict) -> dict:
    data["updatedAt"] = SERVER_TIMESTAMP
    return data


def doc_to_dict(doc) -> dict:
    data = doc.to_dict() or {}
    data["id"] = doc.id
    if "updatedAt" in data and hasattr(data["updatedAt"], "isoformat"):
        data["updatedAt"] = data["updatedAt"].isoformat()
    if "date" in data and hasattr(data["date"], "isoformat"):
        data["date"] = data["date"].isoformat()
    return data
