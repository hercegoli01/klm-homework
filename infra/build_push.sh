#!/bin/bash
set -euo pipefail

# --- CONFIG ---
PROJECT_ID="homework-klm"
REGION="us-east1"
REPO="notes-api"
IMAGE="notes-api"
TAG="latest"
SERVICE_ACCOUNT_KEY="./cred.json" # ha szükséges

# --- LOGIN to Artifact Registry ---
echo "🔑 Logging in to Artifact Registry..."
gcloud auth activate-service-account --key-file="$SERVICE_ACCOUNT_KEY" --project="$PROJECT_ID"
gcloud auth configure-docker "${REGION}-docker.pkg.dev" -q

# --- BUILD IMAGE ---
IMAGE_URI="${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO}/${IMAGE}:${TAG}"
echo "🐳 Building image: $IMAGE_URI"
cd ..
docker buildx build \
  --platform linux/amd64 \
  -t "$IMAGE_URI" \
  --push \
  .

# --- PUSH IMAGE ---
echo "⬆️ Pushing image..."
docker push "$IMAGE_URI"

echo "✅ Done! Image pushed to $IMAGE_URI"
