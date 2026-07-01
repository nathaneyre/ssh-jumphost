FROM dhi.io/alpine-base:3.24-dev

# Update the system
RUN apk update

# Install basic packages
RUN apk add --no-cache \
    docker-cli \
    git \
    openssh

# Create keyfetch user
RUN addgroup -S keyfetch \
    && adduser -S -D -h /home/keyfetch -s /bin/sh -G keyfetch keyfetch \
    && sed -i 's/^keyfetch:!/keyfetch:*/' /etc/shadow

# Generate host keys and create the privilege separation directory sshd requires
RUN ssh-keygen -A
RUN addgroup -S sshd 2>/dev/null || true \
    && adduser -S -D -h /var/empty/sshd -s /sbin/nologin -G sshd sshd \
    && mkdir -p /root/.ssh && chmod 700 /root/.ssh \
    && mkdir -p /var/empty/sshd \
    && chmod 755 /var/empty/sshd \
    && mkdir -p /run/sshd

# Expose ports
EXPOSE 22

# Copy in the entrypoint.sh, remove Windows carriage returns, and make it executable
COPY ssh-jumphost/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN sed -i 's/\r$//' /usr/local/bin/entrypoint.sh \
    && chmod +x /usr/local/bin/entrypoint.sh

CMD ["/usr/local/bin/entrypoint.sh"]