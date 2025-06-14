# Stage 1: Build frontend
FROM node:20 AS frontend

WORKDIR /app

# Clone mempool repository
RUN git clone https://github.com/mempool/mempool.git .

WORKDIR /app/frontend

# Install dependencies and build frontend
RUN npm install && npm run build

# Stage 2: Build backend
FROM node:20 AS backend

WORKDIR /app

# Clone again for backend
RUN git clone https://github.com/mempool/mempool.git .

WORKDIR /app/backend

# Install backend dependencies
RUN npm install

# Stage 3: Runtime image
FROM node:20-slim

# Create app directory
WORKDIR /mempool

# Copy built frontend and backend
COPY --from=backend /app/backend /mempool/backend
COPY --from=frontend /app/frontend/dist /mempool/frontend/dist

# Set environment defaults
ENV MEMPOOL_NETWORK=mainnet
ENV MEMPOOL_BACKEND=none

# Install PM2 to run multiple services
RUN npm install -g pm2

# Start backend (port 8998) and frontend (port 8080) with PM2
COPY start.sh /mempool/start.sh
RUN chmod +x /mempool/start.sh

EXPOSE 8080
EXPOSE 8998

CMD ["/mempool/start.sh"]
