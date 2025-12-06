FROM alpine:latest AS builder
ARG UPTERM_VERSION=refs/tags/v0.20.0

RUN apk add bash git make go

RUN git clone --revision ${UPTERM_VERSION} https://github.com/owenthereal/upterm /src/upterm
WORKDIR /src/upterm
RUN env \
    CGO_ENABLED=0 \
    make build


FROM ubuntu:latest AS upterm

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

COPY entrypoint.sh /entrypoint.sh


ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
