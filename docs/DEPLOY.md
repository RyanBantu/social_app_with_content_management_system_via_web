# Deploy guide — MHC CMS

## Prerequisites

- Firebase project created (see [FIREBASE_SETUP.md](FIREBASE_SETUP.md))
- `gcloud` CLI installed and authenticated
- `firebase` CLI installed (`npm install -g firebase-tools`)
- Copy `.firebaserc.example` → `.firebaserc` and set your project ID

## 1. Deploy Firebase rules + hosting

```bash
# From repo root
firebase login
firebase deploy --only firestore:rules,storage,hosting
```

Hosting serves `admin-web/dist`. Build first:

```bash
cd admin-web
cp .env.example .env.production
# Set VITE_API_URL to your Cloud Run URL (step 2)
npm install
npm run build
cd ..
firebase deploy --only hosting
```

## 2. Deploy FastAPI to Cloud Run

```bash
cd backend

# Store service account as a secret (one-time)
gcloud secrets create mhc-firebase-sa --data-file=serviceAccountKey.json

gcloud run deploy mhc-cms-api \
  --source . \
  --region asia-south1 \
  --allow-unauthenticated \
  --set-env-vars "FIREBASE_STORAGE_BUCKET=YOUR_PROJECT.firebasestorage.app,ADMIN_EMAILS=admin@example.com,CORS_ORIGINS=https://YOUR_PROJECT.web.app" \
  --set-secrets "FIREBASE_CREDENTIALS=mhc-firebase-sa:latest"
```

Note: mount the secret file path via a startup script if needed, or bake credentials using Cloud Run volume mounts.

**Simpler local test before Cloud Run:**

```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

## 3. Point admin web at production API

In `admin-web/.env.production`:

```
VITE_API_URL=https://mhc-cms-api-XXXXXX.asia-south1.run.app
```

Rebuild and redeploy hosting.

## 4. Seed production content

```bash
cd backend
source .venv/bin/activate
python scripts/seed.py
```

## 5. End-to-end test

1. Open admin web → sign in → edit Daily Devotion → Save
2. Open Flutter app on device (Firebase configured via `flutterfire configure`)
3. Devotion card should update within a few seconds without reinstalling

## Environment summary

| Component | Key variables |
|-----------|---------------|
| `backend/.env` | `FIREBASE_CREDENTIALS`, `FIREBASE_STORAGE_BUCKET`, `ADMIN_EMAILS`, `CORS_ORIGINS` |
| `admin-web/.env` | Firebase web config, `VITE_API_URL` |
| Flutter | `lib/firebase_options.dart` via `flutterfire configure` |
