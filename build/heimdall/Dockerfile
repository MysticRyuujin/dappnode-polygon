# Build and Install Heimdall in a stock Go builder container
FROM golang:1.16-alpine

# Install packages we need
RUN apk add --no-cache make gcc musl-dev linux-headers git

# create go src directory and clone heimdall
RUN mkdir -p /root/heimdall

# Clone hemidall release into folder
RUN git clone --branch v0.2.1-mainnet https://github.com/maticnetwork/heimdall.git /root/hemidall

# change work directory
WORKDIR /root/heimdall

# GOBIN required for go install
ENV GOBIN $GOPATH/bin

# Make and Install Heimdall
RUN make install

# Add Volumes?
VOLUME [ "/root/.heimdalld", "/root/heimdall/logs" ]

# Set entrypoint
COPY ./scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod u+x /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
