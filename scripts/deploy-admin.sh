#!/usr/bin/env bash
# Deploy admin web to Firebase Hosting (from repo root)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT/admin-web"
npm install
npm run build
cd "$ROOT"
firebase deploy --only hosting
