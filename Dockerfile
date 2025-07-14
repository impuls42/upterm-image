FROM alpine:latest as builder

RUN apk add bash git make go

RUN git clone https://github.com/owenthereal/upterm /src/upterm

WORKDIR /src/upterm
RUN env \
    CGO_ENABLED=0 \
    make build


FROM ubuntu:latest as upterm

ARG UPTERM_VERSION=0.14.3
ARG GITHUB_USER=dtrifiro
RUN apt-get update && \
    apt-get install -y \
        curl \
        git \
        gzip \
        tar \
        tmux  \
    && \
    apt-get clean

COPY --from=builder /src/upterm/bin/upterm /usr/bin/upterm

COPY known_hosts /root/.ssh/known_hosts
COPY authorized_keys /root/.ssh/authorized_keys
COPY entrypoint.sh /entrypoint.sh

ENV UPTERM_GITHUB_USER=${GITHUB_USER}
ENV UPTERM_AUTHORIZED_KEYS=/root/.ssh/authorized_keys

ENTRYPOINT ["/entrypoint.sh"]
CMD ["tmux"]
