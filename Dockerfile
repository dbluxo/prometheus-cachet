# Building
# --------
FROM golang:1.16-alpine as builder

ARG REPO=$GOPATH/src/github.com/dbluxo/prometheus-cachet

COPY . $REPO
WORKDIR $REPO

RUN go build --ldflags '-extldflags "-static"' -o bin/prometheus-cachet-bridge

# Deployment
# ----------
FROM alpine:3.12

ARG REPO=/go/src/github.com/dbluxo/prometheus-cachet

COPY --from=builder $REPO/bin/* /usr/local/bin/

RUN apk add --no-cache ca-certificates

ENTRYPOINT [ "prometheus-cachet-bridge" ]