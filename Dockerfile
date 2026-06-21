FROM dhi.io/alpine-base:3.24-dev

# Update the system
RUN apt-get update

# Install basic packages
RUN apt-get install -y --no-install-recommends \
    openssh-client \
    openssh-server \
    docker-cli

# Generate host keys and create the privilege separation directory sshd requires
RUN ssh-keygen -A
RUN mkdir -p /run/sshd

RUN adduser -D -s /bin/sh jumper

COPY sshd_config /etc/ssh/sshd_config
COPY router.sh /usr/local/bin/router
RUN chmod +x /usr/local/bin/router

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]