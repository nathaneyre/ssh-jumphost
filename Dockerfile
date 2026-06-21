FROM dhi.io/alpine-base:3.24-dev

# Install basic packages
RUN apk add --no-cache \
    openssh \
    docker-cli

# Generate host keys and create the privilege separation directory sshd requires
RUN ssh-keygen -A
RUN mkdir -p /run/sshd

# Create a user for the jumper
RUN adduser -D -s /bin/sh jumper

# Copy the sshd_config and router.sh files
COPY sshd_config /etc/ssh/sshd_config
COPY router.sh /usr/local/bin/router
RUN chmod +x /usr/local/bin/router

# Expose ports
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]