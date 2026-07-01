#!/bin/sh
set -e


log() {
  msg="[router] $*"
  printf '%s\n' "$msg" >&2
}

DEBUG=$(grep '^DEBUG=' /run/debug_flag 2>/dev/null | cut -d= -f2)
debug() {
  [ "${DEBUG:-}" = "true" ] && log "[DEBUG] $*" || true
}

ALIAS="${SSH_ORIGINAL_COMMAND:-}"
[ -z "$ALIAS" ] && { echo "usage: ssh root@host <alias>" >&2; exit 1; }
debug "ALIAS: $ALIAS"

CONTAINER=$(docker ps \
  --filter "label=ssh.user=${ALIAS}" \
  --filter "status=running" \
  --format "{{.Names}}" | head -1)
[ -z "$CONTAINER" ] && { echo "no container for alias '${ALIAS}'" >&2; exit 1; }
debug "CONTAINER: $CONTAINER"

TARGET_USER=$(docker inspect "$CONTAINER" --format '{{index .Config.Labels "ssh.target_user"}}')
TARGET_USER="${TARGET_USER:-root}"
debug "TARGET_USER: $TARGET_USER"

debug "Executing ssh command"
if ! ssh \
  -i /home/keyfetch/.ssh/keyfetch_key \
  -A \
  -o RequestTTY=force \
  -o StrictHostKeyChecking=no \
  -o UserKnownHostsFile=/dev/null \
  "${TARGET_USER}@${CONTAINER}"; then
  rc=$?
  debug "ERROR ssh failed alias=${ALIAS} target=${TARGET_USER}@${CONTAINER} exit=${rc}"
  exit "$rc"
fi