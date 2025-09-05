FROM debian:bullseye-slim

# Install required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    gnupg \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV BITCOIN_KNOTS_VERSION=29.1.knots20250903
ENV BITCOIN_KNOTS_URL=https://bitcoinknots.org/files/29.x/${BITCOIN_KNOTS_VERSION}/bitcoin-${BITCOIN_KNOTS_VERSION}-x86_64-linux-gnu.tar.gz

# Download and install Bitcoin Knots
RUN wget -q ${BITCOIN_KNOTS_URL} && \
    tar -xzf bitcoin-${BITCOIN_KNOTS_VERSION}-x86_64-linux-gnu.tar.gz && \
    install -m 0755 -t /usr/local/bin bitcoin-${BITCOIN_KNOTS_VERSION}/bin/* && \
    rm -rf bitcoin-${BITCOIN_KNOTS_VERSION}*

# Create datadir
RUN mkdir -p /root/.bitcoin
VOLUME ["/root/.bitcoin"]

# Expose RPC and P2P ports
EXPOSE 8332 8333

# Default command
ENTRYPOINT ["bitcoind"]
CMD ["-datadir=/root/.bitcoin", "-conf=/root/.bitcoin/bitcoin.conf"]
