# Build Gbas in a stock Go builder container
FROM golang:1.11-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers

ADD . /go-abassian
RUN cd /go-abassian && make gbas

# Pull Gbas into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /go-abassian/build/bin/gbas /usr/local/bin/

EXPOSE 8515 8516 30313 30313/udp
ENTRYPOINT ["gbas"]
