#!/bin/sh
set -eu

# Install ssh_jumphost_key for sshkeyfetch user
mkdir -p /home/sshkeyfetch/.ssh \
    && cp /run/secrets/authorized_keys /home/sshkeyfetch/.ssh/authorized_keys \
    && cp /run/secrets/ssh_jumphost_key /home/sshkeyfetch/.ssh/ssh_jumphost_key \
    && chown -R sshkeyfetch:sshkeyfetch /home/sshkeyfetch \
    && chmod 700 /home/sshkeyfetch/.ssh \
    && chmod 600 /home/sshkeyfetch/.ssh/ssh_jumphost_key \
    && chmod 600 /home/sshkeyfetch/.ssh/ssh_jumphost_key

# Set debug flag for all users
printf 'DEBUG=%s\n' "${DEBUG:-false}" > /run/debug_flag

exec /usr/sbin/sshd -D -e