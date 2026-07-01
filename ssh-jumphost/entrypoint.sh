#!/bin/sh
set -eu

# Install keyfetch_key for keyfetch user and set .ssh permissions
mkdir -p /home/keyfetch/.ssh \
    && cp /run/secrets/authorized_keys /home/keyfetch/.ssh/authorized_keys \
    && cp /run/secrets/keyfetch_key /home/keyfetch/.ssh/keyfetch_key \
    && cp /run/secrets/keyfetch_key.pub /home/keyfetch/.ssh/keyfetch_key.pub \
    && chown -R keyfetch:keyfetch /home/keyfetch \
    && chmod 700 /home/keyfetch/.ssh \
    && chmod 600 /home/keyfetch/.ssh/authorized_keys \
    && chmod 600 /home/keyfetch/.ssh/keyfetch_key \
    && chmod 644 /home/keyfetch/.ssh/keyfetch_key.pub

# Add keyfetch user to docker group
DOCKER_GID=$(stat -c '%g' /var/run/docker.sock)
addgroup -g "$DOCKER_GID" dockerhost 2>/dev/null || true
adduser keyfetch dockerhost 2>/dev/null || true

# Set debug flag for all users
printf 'DEBUG=%s\n' "${DEBUG:-false}" > /run/debug_flag

exec /usr/sbin/sshd -D -e