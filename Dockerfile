FROM dhi.io/alpine-base:3.24-dev
RUN apk add --no-cache openssh openssh-client docker-cli

RUN ssh-keygen -A
RUN mkdir -p /run/sshd

RUN adduser -D -s /bin/sh jumper

COPY sshd_config /etc/ssh/sshd_config
COPY router.sh /usr/local/bin/router
RUN chmod +x /usr/local/bin/router

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]