FROM golang:1.21-bookworm

RUN useradd -m -s /bin/bash gouser

WORKDIR /app

COPY go.mod ./

RUN go mod download

COPY . ./

RUN set -x && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    --no-install-recommends \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    go build -v -o server && \
    chown -R gouser:gouser /app

USER gouser

EXPOSE 8080

CMD ["/app/server"]
