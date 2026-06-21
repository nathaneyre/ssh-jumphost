FROM dhi.io/alpine-base:3.24-dev

# Install basic packages
RUN apk add --no-cache \
    openssh \
    docker-cli

# Generate host keys and create the privilege separation directory sshd requires
RUN ssh-keygen -A
RUN addgroup -S sshd 2>/dev/null || true \
    && adduser -S -D -h /var/empty/sshd -s /sbin/nologin -G sshd sshd \
    && mkdir -p /var/empty/sshd \
    && chmod 755 /var/empty/sshd \
    && mkdir -p /run/sshd

# Create a user for the jumper
RUN adduser -D -s /bin/sh jumper

# Copy the sshd_config and router.sh files
COPY sshd_config /etc/ssh/sshd_config
COPY router.sh /usr/local/bin/router
RUN chmod +x /usr/local/bin/router

# Expose ports
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]