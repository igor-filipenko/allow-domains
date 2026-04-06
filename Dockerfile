FROM ghcr.io/sagernet/sing-box:v1.11.15 AS sing-box

FROM golang:1.25.5-alpine3.23 AS go-builder

RUN CGO_ENABLED=0 GOOS=linux go install -ldflags="-s -w" \
    github.com/v2fly/domain-list-community@20251222003838

FROM alpine:3.23 AS mihomo

ARG MIHOMO_VERSION=1.19.8

RUN apk add --no-cache ca-certificates wget && \
    wget -qO- "https://github.com/MetaCubeX/mihomo/releases/download/v${MIHOMO_VERSION}/mihomo-linux-amd64-v${MIHOMO_VERSION}.gz" | gunzip > /mihomo && \
    chmod +x /mihomo

FROM python:3.12.12-alpine3.23

COPY --from=sing-box /usr/local/bin/sing-box /bin/sing-box

COPY --from=mihomo /mihomo /bin/mihomo

COPY --from=go-builder /go/bin/domain-list-community /bin/domain-list-community

COPY requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir -r /app/requirements.txt

WORKDIR /app

COPY convert.py /app/convert.py
COPY proto /app/proto

CMD ["python3", "convert.py"]