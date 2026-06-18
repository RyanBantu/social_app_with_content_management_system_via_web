# MHC Admin Web

React admin panel for Mysore Hope Center CMS. Lives at repo root as `admin-web/` (separate from the Flutter app).

## Setup

```bash
cd admin-web
npm install
cp .env.example .env
# Fill in Firebase web config + VITE_API_URL (FastAPI, default http://localhost:8000)
npm run dev
```

Open http://localhost:5173 and sign in with a Firebase Auth admin account listed in `backend/.env` `ADMIN_EMAILS`.

## Build for Firebase Hosting

```bash
npm run build
```

Output goes to `dist/`. Root `firebase.json` already points hosting to `admin-web/dist`.
