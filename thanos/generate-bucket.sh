#!/bin/sh
set -e

# Replace placeholders ${MINIO_ACCESS_KEY} and ${MINIO_SECRET_KEY} in the template
# with the actual environment variable values
sed \
  -e "s|\${MINIO_ACCESS_KEY}|${MINIO_ACCESS_KEY}|g" \
  -e "s|\${MINIO_SECRET_KEY}|${MINIO_SECRET_KEY}|g" \
  /etc/thanos/bucket.yaml.template > /etc/thanos/bucket.yaml

# Print confirmation
echo "bucket.yaml generated successfully"

# Execute the Thanos command with all arguments passed to this script
exec "$@"
