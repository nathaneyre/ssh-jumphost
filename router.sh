#!/bin/sh
set -e

LABEL_KEY="ssh.user"

# Find a running container with the matching label value
CONTAINER=$(docker ps \
  --filter "label=${LABEL_KEY}=${USER}" \
  --filter "status=running" \
  --format "{{.Names}}" | head -1)

if [ -z "$CONTAINER" ]; then
  echo "ssh-router: no running container found for user '${USER}'" >&2
  exit 1
fi

# Read the target user from the container's own label (falls back to root)
TARGET_USER=$(docker inspect "$CONTAINER" \
  --format '{{index .Config.Labels "ssh.target_user"}}')
TARGET_USER="${TARGET_USER:-root}"

echo "ssh-router: routing to ${TARGET_USER}@${CONTAINER}" >&2

exec ssh \
  -i /etc/ssh/ssh_jumphost_key \
  -o StrictHostKeyChecking=no \
  -o UserKnownHostsFile=/dev/null \
  "${TARGET_USER}@${CONTAINER}"