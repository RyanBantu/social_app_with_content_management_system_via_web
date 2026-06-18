#!/usr/bin/env bash
# Deploy FastAPI to Cloud Run (requires gcloud auth)
set -euo pipefail
cd "$(dirname "$0")/../backend"
gcloud run deploy mhc-cms-api \
  --source . \
  --region asia-south1 \
  --allow-unauthenticated \
  "$@"
