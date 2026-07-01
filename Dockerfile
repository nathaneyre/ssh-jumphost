FROM dhi.io/alpine-base:3.24-dev

# Install basic packages
RUN apk add --no-cache \
    docker-cli \
    git \
    openssh

# Create jumphost user
RUN addgroup -S jumphost \
    && adduser -S -D -h /home/jumphost -s /bin/sh -G jumphost jumphost \
    && sed -i 's/^jumphost:!/jumphost:*/' /etc/shadow

# Generate host keys and create the privilege separation directory sshd requires
RUN ssh-keygen -A
RUN addgroup -S sshd 2>/dev/null || true \
    && adduser -S -D -h /var/empty/sshd -s /sbin/nologin -G sshd sshd \
    && mkdir -p /root/.ssh && chmod 700 /root/.ssh \
    && mkdir -p /var/empty/sshd \
    && chmod 755 /var/empty/sshd \
    && mkdir -p /run/sshd

# Copy the sshd_config
COPY sshd_config /etc/ssh/sshd_config

# Expose ports
EXPOSE 22

# Copy in the entrypoint.sh, remove Windows carriage returns, and make it executable
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN sed -i 's/\r$//' /usr/local/bin/entrypoint.sh \
    && chmod +x /usr/local/bin/entrypoint.sh

CMD ["/usr/local/bin/entrypoint.sh"]