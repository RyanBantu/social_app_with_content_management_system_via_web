from pathlib import Path

import firebase_admin
from firebase_admin import credentials, firestore, storage

from app.config import FIREBASE_CREDENTIALS, FIREBASE_STORAGE_BUCKET

_initialized = False


def init_firebase() -> None:
    global _initialized
    if _initialized or firebase_admin._apps:
        _initialized = True
        return

    cred_path = Path(FIREBASE_CREDENTIALS)
    if not cred_path.is_absolute():
        cred_path = Path(__file__).resolve().parents[1] / cred_path

    if not cred_path.exists():
        raise FileNotFoundError(
            f"Firebase credentials not found at {cred_path}. "
            "Download service account JSON from Firebase Console."
        )

    cred = credentials.Certificate(str(cred_path))
    options = {}
    if FIREBASE_STORAGE_BUCKET:
        options["storageBucket"] = FIREBASE_STORAGE_BUCKET

    firebase_admin.initialize_app(cred, options or None)
    _initialized = True


def get_db():
    init_firebase()
    return firestore.client()


def get_bucket():
    init_firebase()
    return storage.bucket()
