#!/bin/sh
# =========================
# MinIO Client bootstrap
# =========================
# This script runs once to create the Prometheus bucket in MinIO.
# It waits until MinIO is ready before creating the bucket.

# Environment variables:
# MINIO_ACCESS_KEY - MinIO access key
# MINIO_SECRET_KEY - MinIO secret key
# MINIO_BUCKET     - Bucket name to create (default: "prometheus")
# MINIO_ENDPOINT   - MinIO endpoint (default: http://minio:9000)

MINIO_BUCKET=${MINIO_BUCKET:-prometheus}
MINIO_ENDPOINT=${MINIO_ENDPOINT:-http://minio:9000}

echo "Waiting for MinIO at $MINIO_ENDPOINT..."

# Wait for MinIO to become available
until mc alias set localminio "$MINIO_ENDPOINT" "$MINIO_ACCESS_KEY" "$MINIO_SECRET_KEY" >/dev/null 2>&1; do
  echo "MinIO not ready yet, retrying in 2s..."
  sleep 2
done

echo "MinIO is ready. Creating bucket '$MINIO_BUCKET'..."

# Create the bucket if it doesn't exist
mc mb --ignore-existing localminio/$MINIO_BUCKET

echo "Bucket '$MINIO_BUCKET' is ready!"
