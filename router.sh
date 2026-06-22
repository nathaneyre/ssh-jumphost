#!/bin/sh
set -e

ALIAS="${SSH_ORIGINAL_COMMAND:-}"
[ -z "$ALIAS" ] && { echo "usage: ssh root@host <alias>" >&2; exit 1; }

CONTAINER=$(docker ps \
  --filter "label=ssh.user=${ALIAS}" \
  --filter "status=running" \
  --format "{{.Names}}" | head -1)

[ -z "$CONTAINER" ] && { echo "no container for alias '${ALIAS}'" >&2; exit 1; }

TARGET_USER=$(docker inspect "$CONTAINER" --format '{{index .Config.Labels "ssh.target_user"}}')
TARGET_USER="${TARGET_USER:-root}"

exec ssh \
  -i /etc/ssh/ssh_jumphost_key \
  -o StrictHostKeyChecking=no \
  -o UserKnownHostsFile=/dev/null \
  "${TARGET_USER}@${CONTAINER}"