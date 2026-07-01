#!/bin/sh
set -eu

# Install ssh_auth_key for sshkeyfetch user
mkdir -p /home/sshkeyfetch/.ssh \
    && cp /run/secrets/ssh_auth_key /home/sshkeyfetch/.ssh/ssh_auth_key \
    && chown -R sshkeyfetch:sshkeyfetch /home/sshkeyfetch \
    && chmod 700 /home/sshkeyfetch/.ssh \
    && chmod 600 /home/sshkeyfetch/.ssh/ssh_auth_key

exec /usr/sbin/sshd -D -e