# MHC CMS API (FastAPI)

Admin-only backend for uploading images, sermon DOCX files, and managing Firestore content.

## Setup

```bash
cd backend
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
```

Download your Firebase **service account JSON** from Firebase Console → Project settings → Service accounts → Generate new private key. Save as `backend/serviceAccountKey.json` (gitignored) or set `FIREBASE_CREDENTIALS` in `.env`.

## Run locally

```bash
uvicorn app.main:app --reload --port 8000
```

Health check: http://localhost:8000/health

All `/admin/*` routes require `Authorization: Bearer <Firebase ID token>` from an email in `ADMIN_EMAILS`.

## Deploy (Cloud Run)

```bash
gcloud run deploy mhc-cms-api \
  --source . \
  --region asia-south1 \
  --allow-unauthenticated \
  --set-env-vars FIREBASE_STORAGE_BUCKET=your-bucket.firebasestorage.app,ADMIN_EMAILS=admin@example.com
```

Mount service account credentials via Secret Manager in production.

## Seed existing app content

```bash
python scripts/seed.py
```

Requires credentials and paths to `mhc_app/assets/`.
