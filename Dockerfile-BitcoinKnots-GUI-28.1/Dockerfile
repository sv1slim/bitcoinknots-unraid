FROM debian:bullseye-slim

# Install dependencies for bitcoin-qt GUI
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    ca-certificates \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-render-util0 \
    libxcb-xinerama0 \
    libxcb-xinput0 \
    libqt5gui5 \
    libqt5core5a \
    libqt5widgets5 \
    libqt5dbus5 \
    qt5dxcb-plugin \
    x11-apps \
    && rm -rf /var/lib/apt/lists/*

# Environment variables
ENV BITCOIN_KNOTS_VERSION=28.1.knots20250305
ENV BITCOIN_KNOTS_URL=https://bitcoinknots.org/files/28.x/${BITCOIN_KNOTS_VERSION}/bitcoin-${BITCOIN_KNOTS_VERSION}-x86_64-linux-gnu.tar.gz

# Install Bitcoin Knots
RUN wget -q $BITCOIN_KNOTS_URL && \
    tar -xzf bitcoin-${BITCOIN_KNOTS_VERSION}-x86_64-linux-gnu.tar.gz && \
    mv bitcoin-${BITCOIN_KNOTS_VERSION}/bin/* /usr/local/bin/ && \
    rm -rf bitcoin-${BITCOIN_KNOTS_VERSION}*

# Expose ports
EXPOSE 8332 8333

# Define data volume
VOLUME ["/bitcoin"]

# Default GUI entry
ENTRYPOINT ["bitcoin-qt"]
CMD ["-datadir=/bitcoin", "-conf=/bitcoin/bitcoin.conf"]
