# Mysore Hope Center — Monorepo

Three separate projects at the repo root:

| Folder | Purpose |
|--------|---------|
| `mhc_app/` | Flutter iOS/Android church app |
| `backend/` | FastAPI CMS API (Firebase Admin writes) |
| `admin-web/` | React admin panel (Firebase Auth + FastAPI) |

Firebase rules and hosting config live in `firebase/` and `firebase.json`.

## Quick start

### 1. Firebase (manual)

Follow [docs/FIREBASE_SETUP.md](docs/FIREBASE_SETUP.md): create project, enable Auth/Firestore/Storage, deploy rules, add admin user.

### 2. Backend

```bash
cd backend
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
# Add serviceAccountKey.json from Firebase Console
uvicorn app.main:app --reload --port 8000
```

### 3. Admin web

```bash
cd admin-web
npm install
cp .env.example .env
# Fill Firebase web config + VITE_API_URL=http://localhost:8000
npm run dev
```

### 4. Flutter app

```bash
cd mhc_app
flutter pub get
dart pub global activate flutterfire_cli
flutterfire configure   # generates lib/firebase_options.dart
cd ios && pod install && cd ..
flutter run --release
```

The app falls back to bundled `app_data.dart` if Firebase is not configured.

### 5. Seed content

After Firebase credentials are in place:

```bash
cd backend && python scripts/seed.py
```

Uploads existing assets from `mhc_app/assets/` into Storage and Firestore.

## Architecture

- **Firestore** — real-time content for the app (read-only from clients)
- **Storage** — images and sermon DOCX files
- **FastAPI** — admin uploads and CRUD (Bearer Firebase ID token)
- **Admin web** — forms for devotion, events, ministries, sermons

Changes in the admin panel appear in the app within seconds via Firestore listeners.

## Production deploy

See [docs/DEPLOY.md](docs/DEPLOY.md) for Cloud Run (API) and Firebase Hosting (admin web).
