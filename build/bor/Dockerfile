# Build Bor in a stock Go builder container
FROM golang:1.16-alpine as builder

# Install packages we need
RUN apk add --no-cache make gcc musl-dev linux-headers git

# Make a folder to work in
RUN mkdir /bor

# Clone the repo to that folder
RUN git clone ${UPSTREAM_VERSION} https://github.com/maticnetwork/bor.git /bor

# Build Bor
RUN cd /bor && make bor

# Pull Bor into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /bor/build/bin/bor /usr/local/bin/

# Set entrypoint
COPY ./scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod u+x /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
