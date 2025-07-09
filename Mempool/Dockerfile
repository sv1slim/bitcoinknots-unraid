FROM node:18-bullseye-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
  git \
  curl \
  nginx \
  && rm -rf /var/lib/apt/lists/*

# Set up working directory
WORKDIR /mempool

# Clone mempool project
RUN git clone https://github.com/mempool/mempool.git . && \
    git checkout master

# Install backend dependencies and build
WORKDIR /mempool/backend
RUN npm ci && npm run build

# Install frontend dependencies and build
WORKDIR /mempool/frontend
RUN npm ci && npm run build

# Configure Nginx to serve frontend and proxy backend API
RUN rm /etc/nginx/sites-enabled/default
COPY nginx.conf /etc/nginx/conf.d/mempool.conf

# Set environment variables for the backend
ENV CORE_RPC_HOST=bitcoin
ENV CORE_RPC_PORT=8332
ENV CORE_RPC_USERNAME=bitcoinrpc
ENV CORE_RPC_PASSWORD=changeme
ENV MEMPOOL_BACKEND=none
ENV DATABASE_ENABLED=false
ENV STATISTICS_ENABLED=true

# Expose port for Nginx frontend
EXPOSE 80

# Start both backend and nginx in parallel
CMD ["sh", "-c", "node /mempool/backend/dist/index.js & nginx -g 'daemon off;'"]
