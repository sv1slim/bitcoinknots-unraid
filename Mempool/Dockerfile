# Stage 1: Build mempool backend and frontend
FROM node:18-bullseye-slim AS builder

# Install build tools, Rust, and rsync
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential curl git pkg-config libssl-dev python3 ca-certificates rsync \
  && curl https://sh.rustup.rs -sSf | sh -s -- -y \
  && export PATH="$PATH:/root/.cargo/bin" \
  && rm -rf /var/lib/apt/lists/*

# Clone Mempool repo
WORKDIR /mempool
RUN git clone https://github.com/mempool/mempool.git . && git checkout master

# Build backend
WORKDIR /mempool/backend
ENV CI=false
RUN export PATH="$PATH:/root/.cargo/bin" && \
    npm install --prefer-offline --no-audit && \
    npm run build

# Build frontend
WORKDIR /mempool/frontend
RUN npm install --prefer-offline --no-audit && \
    npm run build

# Stage 2: Run
FROM debian:bullseye-slim

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx curl ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Copy built backend and frontend
COPY --from=builder /mempool/backend/dist /opt/mempool/backend
COPY --from=builder /mempool/frontend/dist /opt/mempool/frontend

# Add nginx config
COPY nginx.conf /etc/nginx/conf.d/mempool.conf

# Environment variables
ENV CORE_RPC_HOST=127.0.0.1 \
    CORE_RPC_PORT=8332 \
    CORE_RPC_USERNAME=rpcuser \
    CORE_RPC_PASSWORD=rpcpassword \
    STATISTICS_ENABLED=true \
    DATABASE_ENABLED=false

# Expose web port
EXPOSE 80

# Start backend and nginx
CMD node /opt/mempool/backend/index.js & nginx -g 'daemon off;'
