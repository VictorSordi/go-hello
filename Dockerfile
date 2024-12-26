FROM golang:1.21-bookworm

WORKDIR /app

COPY go.* ./

RUN go mod download

COPY . ./

RUN go build -v -o server

RUN set -x && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

CMD ["/app/server"]
