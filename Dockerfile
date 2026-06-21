FROM dhi.io/alpine-base:3.24-dev AS build
RUN apk add --no-cache openssh openssh-client docker-cli

FROM dhi.io/alpine-base:3.24
USER root

COPY --from=build /usr/sbin/sshd /usr/sbin/sshd
COPY --from=build /usr/bin/ssh /usr/bin/ssh
COPY --from=build /usr/bin/docker /usr/bin/docker
# Copy supporting binaries and libs as needed — openssh/docker-cli have deps
COPY --from=build /usr/lib /usr/lib
COPY --from=build /etc/ssh /etc/ssh

COPY sshd_config /etc/ssh/sshd_config
COPY router.sh /usr/local/bin/router
RUN chmod +x /usr/local/bin/router

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]