FROM debian:bullseye-slim

# Install required packages
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV BITCOIN_KNOTS_VERSION=28.1.knots20250305
ENV BITCOIN_KNOTS_URL=https://bitcoinknots.org/files/28.x/${BITCOIN_KNOTS_VERSION}/bitcoin-${BITCOIN_KNOTS_VERSION}-x86_64-linux-gnu.tar.gz

# Download and install Bitcoin Knots
RUN wget -q $BITCOIN_KNOTS_URL && \
    tar -xzf bitcoin-${BITCOIN_KNOTS_VERSION}-x86_64-linux-gnu.tar.gz && \
    mv bitcoin-${BITCOIN_KNOTS_VERSION}/bin/* /usr/local/bin/ && \
    rm -rf bitcoin-${BITCOIN_KNOTS_VERSION}* 

# Expose typical Bitcoin ports
EXPOSE 8332 8333 18332 18333 28332 28333

# Define a volume for configuration and blockchain data
VOLUME ["/bitcoin"]

# Set default command
ENTRYPOINT ["bitcoind"]
CMD ["-datadir=/bitcoin", "-conf=/bitcoin/bitcoin.conf"]
