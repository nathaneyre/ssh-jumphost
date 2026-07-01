#!/bin/sh
set -eu

# Install ssh_jumphost_key for sshkeyfetch user
mkdir -p /home/sshkeyfetch/.ssh \
    && cp /etc/ssh/ssh_jumphost_key /home/sshkeyfetch/.ssh/ssh_jumphost_key \
    && chown -R sshkeyfetch:sshkeyfetch /home/sshkeyfetch \
    && chmod 700 /home/sshkeyfetch/.ssh \
    && chmod 600 /home/sshkeyfetch/.ssh/ssh_jumphost_key

exec /usr/sbin/sshd -D -e