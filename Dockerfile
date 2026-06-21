FROM dhi.io/alpine:3.24
RUN apk add --no-cache openssh openssh-client docker-cli

COPY sshd_config /etc/ssh/sshd_config
COPY router.sh /usr/local/bin/router
RUN chmod +x /usr/local/bin/router

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]