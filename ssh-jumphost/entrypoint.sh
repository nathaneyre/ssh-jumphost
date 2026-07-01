#!/bin/sh
set -eu

# Install jumphost_ssh_key for jumphost user and set .ssh permissions
mkdir -p /home/jumphost/.ssh \
    && cp /run/secrets/authorized_keys /home/jumphost/.ssh/authorized_keys \
    && cp /run/secrets/jumphost_ssh_key /home/jumphost/.ssh/jumphost_ssh_key \
    && cp /run/secrets/jumphost_ssh_key.pub /home/jumphost/.ssh/jumphost_ssh_key.pub \
    && chown -R jumphost:jumphost /home/jumphost \
    && chmod 700 /home/jumphost/.ssh \
    && chmod 600 /home/jumphost/.ssh/authorized_keys \
    && chmod 600 /home/jumphost/.ssh/jumphost_ssh_key \
    && chmod 644 /home/jumphost/.ssh/jumphost_ssh_key.pub

# Add jumphost user to docker group
DOCKER_GID=$(stat -c '%g' /var/run/docker.sock)
addgroup -g "$DOCKER_GID" dockerhost 2>/dev/null || true
adduser jumphost dockerhost 2>/dev/null || true

# Set debug flag for all users
printf 'DEBUG=%s\n' "${DEBUG:-false}" > /run/debug_flag

exec /usr/sbin/sshd -D -e