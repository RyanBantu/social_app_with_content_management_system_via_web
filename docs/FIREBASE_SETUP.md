# Firebase Setup for MHC CMS

## 1. Create project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create project: **mysore-hope-center** (or your chosen name)
3. Enable **Authentication** → Email/Password
4. Create **Firestore** database (production mode)
5. Enable **Storage**

Upgrade to **Blaze (pay-as-you-go)** if you expect heavy Storage downloads; church apps typically stay within free tier.

## 2. Register apps

### iOS (Flutter)

```bash
cd mhc_app
dart pub global activate flutterfire_cli
flutterfire configure
cd ios && pod install && cd ..
```

This generates `lib/firebase_options.dart` and downloads `GoogleService-Info.plist` into `ios/Runner/`.

If not using the CLI yet, copy `lib/firebase_options.dart.example` → `lib/firebase_options.dart` and fill in values from Firebase Console.

### Admin web

1. Firebase Console → Project settings → Your apps → **Add Web app**
2. Copy config into `admin-web/.env` (see `admin-web/.env.example`)

## 3. Service account (FastAPI backend)

1. Project settings → Service accounts → **Generate new private key**
2. Save as `backend/serviceAccountKey.json` (never commit — already in `.gitignore`)
3. Copy `backend/.env.example` → `backend/.env` and set:
   - `FIREBASE_STORAGE_BUCKET` (e.g. `mysore-hope-center.firebasestorage.app`)
   - `ADMIN_EMAILS` (comma-separated church staff emails)

## 4. Deploy rules

```bash
cp .firebaserc.example .firebaserc   # set your project ID
npm install -g firebase-tools
firebase login
firebase deploy --only firestore:rules,storage
```

## 5. Create admin user

Firebase Console → Authentication → **Add user** (church staff email + password).

Add that email to `ADMIN_EMAILS` in `backend/.env`.

## 6. Seed content

```bash
cd backend
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
python scripts/seed.py
```

## 7. Production deploy

See [DEPLOY.md](DEPLOY.md) for Cloud Run + Firebase Hosting.

## Firestore schema

```
content/
  dailyDevotion/current/current     # daily devotion (bilingual)
  upcomingEvents/events/{id}        # event posters
  ministries/entries/{id}           # ministry images + timings
  sermons/entries/{id}              # sermon metadata + docxUrl
config/
  app                               # prayerTeamEmail
```

All content docs include `published`, `sortOrder` (where applicable), and `updatedAt`.
